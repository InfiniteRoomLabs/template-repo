# Progress

Living status doc. Read first, update at every phase boundary. Last updated: <date>.

## Current state

- Repo cut from `InfiniteRoomLabs/template-repo`. Toolchain (`mise.toml`), gate (`mise run check`), CI, LikeC4 architecture workspace, and the Claude Code harness bootstrap are in place; no product code yet.
- Not yet planned: no `GOAL.md`, no design spec, no phase roadmap.

## Phase ledger

| Phase | Status | Branch / merge | Notes |
|---|---|---|---|
| <n> <name> | not started | `phase-<n>/<slug>` | <notes> |

## Discoveries

- <date>: <discovery that changed the plan or the spec, with a pointer to the STATE AS OF callout>

## Next action

Run `/new-goal-loop <what you are building>` to produce the design spec, `GOAL.md`, and the phase work orders.

## How to resume in a fresh session

1. Read this file, then `GOAL.md`, then `CLAUDE.md`.
2. `git status --porcelain` must be empty and `git log --oneline -5` should match the ledger above. If not, reconcile before starting.
3. Read only the spec sections the current phase names.
4. Start the goal.
