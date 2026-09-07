#!/usr/bin/env -S usage bash
# Greps what you are about to commit against the agent-ops redaction term
# list (vault item names, internal hostnames, personal identifiers, ...).
# Default mode scans the staged index (a pre-commit check). --range scans a
# branch diff's added lines instead, for a review lane that cannot use the
# index. Optional for outside contributors: it needs `usage` on PATH (this
# script's interpreter, so `mise install` first), and when no resolver is
# configured it exits 0 with a notice instead of failing.
#
# Point REDACTION_TERMS_RESOLVER at the resolver script (for Infinite Room
# Labs operators: agent-ops/scripts/resolve-redaction-terms.py). Set it in a
# gitignored mise.local.toml [env] block -- never hardcode a path here, this
# file is public.
#USAGE flag "--range <range>" help="Scan a git diff range (base..head)'s added lines instead of the staged index, e.g. main..phase-1/foo"

set -euo pipefail

# Validate the range before scanning anything: the file list below comes from
# a process substitution whose exit status is discarded, so an unresolvable
# range (a typo, a shallow CI checkout) would otherwise yield an empty list
# and a green result.
if [ -n "${usage_range:-}" ] && ! git rev-list --count "$usage_range" >/dev/null 2>&1; then
  echo "redaction-check: unusable range: $usage_range" >&2
  exit 2
fi

resolver="${REDACTION_TERMS_RESOLVER:-}"

if [ -z "$resolver" ] || [ ! -f "$resolver" ]; then
  echo "redaction-check: term list not configured (optional for outside contributors)"
  exit 0
fi

terms_raw=$(cd "$(dirname "$resolver")" && uv run "$(basename "$resolver")")
if [ -z "$terms_raw" ]; then
  echo "redaction-check: no redaction terms configured"
  exit 0
fi

mapfile -t terms <<<"$terms_raw"

# Short terms (< 8 chars) are ordinary-English-word collision risks; require
# word boundaries for those. Longer terms are specific enough that a
# fixed-string substring match is fine and catches more (a leak embedded
# mid-identifier).
short_term_threshold=8

# added_lines emits the added (non-context) lines of file's diff over range.
added_lines() {
  local range="$1" file="$2" dline
  while IFS= read -r dline; do
    if [[ "$dline" == +++* ]]; then
      continue
    elif [[ "$dline" == +* ]]; then
      printf '%s\n' "${dline:1}"
    fi
  done < <(git diff "$range" -U0 -- "$file")
}

# content_of emits file's full staged content, or its added lines in range
# mode. One extractor for both modes so they cannot drift apart.
content_of() {
  local file="$1"
  if [ -n "${usage_range:-}" ]; then
    added_lines "$usage_range" "$file"
  else
    git show ":$file" 2>/dev/null
  fi
}

found=0

scan_terms() {
  local file="$1" content="$2" i term search escaped hit
  for i in "${!terms[@]}"; do
    term="${terms[$i]}"
    search="${term%%==>*}"
    [ -z "$search" ] && continue
    if [ "${#search}" -lt "$short_term_threshold" ]; then
      escaped=$(printf '%s' "$search" | sed 's/[][\.^$*+?(){}|\\]/\\&/g')
      hit=$(printf '%s' "$content" | grep -qiE "\\b${escaped}\\b" && echo 1 || true)
    else
      hit=$(printf '%s' "$content" | grep -qiF -- "$search" && echo 1 || true)
    fi
    if [ -n "$hit" ]; then
      echo "redaction-check: possible leak in $file (term #$i)" >&2
      found=1
    fi
  done
}

if [ -n "${usage_range:-}" ]; then
  files_cmd=(git diff "$usage_range" --name-only)
else
  files_cmd=(git diff --cached --name-only)
fi

while IFS= read -r file; do
  [ -z "$file" ] && continue
  content=$(content_of "$file") || continue # deleted in this commit; nothing to scan
  scan_terms "$file" "$content"
done < <("${files_cmd[@]}")

if [ "$found" -ne 0 ]; then
  exit 1
fi

echo "redaction-check: clean"
