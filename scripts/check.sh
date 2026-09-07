#!/usr/bin/env -S usage bash
#USAGE arg "[step]" help="A single gate step, or 'all' (default: all)"

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
step="${usage_step:-all}"

# Add one run_<step> function per gate step this project needs, list the step
# names in `steps`, and wire them into run_step's case. Ships with only the
# language-agnostic `arch` step so `mise run check` is green on a fresh clone
# of any language.
#
#   run_lint() { echo "== lint =="; (cd "$repo_root" && <lint command>); }
#   run_test() { echo "== test =="; (cd "$repo_root" && <test command>); }

run_arch() {
  echo "== arch =="
  if ! ls "$repo_root"/docs/architecture/*.c4 >/dev/null 2>&1; then
    echo "arch: no .c4 sources in docs/architecture -- skipping"
    return 0
  fi
  local likec4="pnpm dlx --config.enable-global-virtual-store=false -y likec4@${LIKEC4_VERSION:-1.59.2}"
  (cd "$repo_root" && $likec4 validate)
  (cd "$repo_root" && $likec4 format --check)
  # --check never writes, so the dirty-tree banner below stays meaningful.
  "$repo_root/scripts/arch-gen.sh" --check
  # Custom model rules (every service has a technology, no #deprecated element
  # has inbound relationships, ...) are a Vitest + LikeC4 API recipe in the
  # docs ("Enforce and validate your model"); add a run_arch_rules step here
  # when this project has a Node test runner.
}

steps=(arch)   # e.g. steps=(fmt lint test cover build arch)

run_step() {
  case "$1" in
  arch) run_arch ;;
  # lint) run_lint ;;
  # test) run_test ;;
  *)
    echo "check.sh: unknown step: $1" >&2
    exit 2
    ;;
  esac
}

if [ "$step" = "all" ]; then
  # ${steps[@]+...}: bash 3.2 (macOS) errors on an empty array under set -u.
  for s in ${steps[@]+"${steps[@]}"}; do run_step "$s"; done
else
  run_step "$step"
fi

dirty=$(cd "$repo_root" && git status --porcelain)
if [ -n "$dirty" ]; then
  echo
  echo "!! gate ran on a DIRTY tree -- this result describes disk, not HEAD:"
  echo "$dirty"
  echo
  # Flip to a hard gate once this repo runs review lanes: exit 1
fi

echo "check.sh: $step OK"
