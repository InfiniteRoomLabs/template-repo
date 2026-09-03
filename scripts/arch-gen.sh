#!/usr/bin/env -S usage bash
# Regenerates the committed Mermaid diagrams in docs/architecture/generated/
# from the LikeC4 model, and splices the landscape view (index.mmd) into
# docs/architecture/README.md between the arch:index markers. --check is the
# gate mode: it regenerates and fails if anything differs from what is
# committed, so a model change that forgot `mise run arch:gen` cannot merge
# with stale diagrams.
#USAGE flag "--check" help="Fail if the committed diagrams are stale instead of leaving the regenerated files in place"

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

out=docs/architecture/generated
readme=docs/architecture/README.md
likec4="pnpm dlx --config.enable-global-virtual-store=false -y likec4@${LIKEC4_VERSION:-1.59.2}"

$likec4 gen mmd -o "$out"

# Replace the block between the markers with the current landscape view so the
# README renders on GitHub without a build step and cannot drift from the model.
if [ -f "$readme" ] && [ -f "$out/index.mmd" ] && grep -q '<!-- arch:index:start -->' "$readme"; then
  {
    sed '/<!-- arch:index:start -->/q' "$readme"
    echo '```mermaid'
    cat "$out/index.mmd"
    echo '```'
    sed -n '/<!-- arch:index:end -->/,$p' "$readme"
  } >"$readme.tmp"
  mv "$readme.tmp" "$readme"
fi

if [ "${usage_check:-false}" = "true" ]; then
  if ! git diff --quiet -- "$out" "$readme" || [ -n "$(git ls-files --others --exclude-standard -- "$out")" ]; then
    echo "arch-gen: committed diagrams are stale -- run 'mise run arch:gen' and commit the result" >&2
    git --no-pager status --short -- "$out" "$readme" >&2
    exit 1
  fi
fi
