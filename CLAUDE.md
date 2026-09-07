# <project> -- Project Instructions for Claude

<one-line-description>

Cut from `InfiniteRoomLabs/template-repo`. This file is the living rulebook: when you find a gotcha, write it into **Gotchas** below in the same commit -- just enough that future you knows it is not a bug.

## First run

- If there is no `GOAL.md`, this repo has not been planned yet. Run `/new-goal-loop <what you are building>` (agent-ops `agency` plugin, enabled by `.claude/settings.json`). It runs the planning session and writes `GOAL.md`, the design spec under `docs/superpowers/specs/`, `docs/phases/_templates/`, and fills `docs/progress.md`. After that, every phase is `/goal complete everything in @GOAL.md` in a fresh context.
- Replace every placeholder first (the checklist is in `README.md`, "Using this template").

## Read-first

- **`docs/progress.md`** -- living status. Always read before starting work; update at every phase boundary.
- **`GOAL.md`** (once it exists) -- the current autonomous phase goal + full roadmap.
- **The design spec** in `docs/superpowers/specs/` -- locked sections are not re-litigated; read only the sections the current phase needs.
- **`docs/architecture/`** -- the LikeC4 model. Read it (via the MCP tools) before designing anything structural.

## Toolchain

- **Everything through `mise`:** `mise install`, then `mise run check` is the gate. Pin real versions in `mise.toml [tools]`; never bare tool invocations (version drift). `<toolchain>`.
- **Python:** `uv run` only. **JS:** `pnpm` only (`pnpm dlx`, never `npx`).
- **Secrets:** a **gitignored** `fnox.toml` maps env vars to Bitwarden items; run anything that needs them as `fnox exec -- <cmd>`. No `.env`/`.envrc`, never export a secret in a shell, never echo a value (test resolution by length: `fnox exec -- sh -c 'echo ${#MY_SECRET}'`). Add `fnox.toml` only when there is a real secret.

## Working conventions

- **Phases, not tasks.** One GOAL block = one phase = one branch `phase-<n>/<slug>` = one gate = one `--no-ff` merge. Parallel batches (if any) run as worktrees under `.worktrees/` (gitignored); everything else is in-place branches.
- **Four-lane review gate before every merge:** code review, simplification, security (parallel, read-only), then QA (the only lane that runs `mise run check`). Work orders in `docs/phases/_templates/`; reports to `docs/phases/<n>/reports/<lane>.md` and via `SendMessage` to `team-lead`. Triage, ONE fix commit, re-gate, merge.
- **Model rules (non-negotiable):** pass `model:` explicitly on every dispatch; reviewers one tier above the implementer (sonnet -> opus, opus -> fable); haiku only for read-only sweeps that cannot hit a permission prompt. Check an agent's `tools:` before writing its prompt; `general-purpose` has everything.
- **Clean up agents** with `TaskStop` once they are no longer needed: review lanes after triage, implementers after their merge, QA after its verdict is acted on.
- **Green rule:** see `TESTING.md`. No skipped/focused/silenced tests without an issue link; warnings are errors; the coverage floor is enforced by the gate, not by promises.
- **Commits:** conventional, imperative, scoped (`feat(<scope>): ...`, `fix: ...`, `docs: ...`, `chore(ci): ...`). **Stage and commit in separate tool calls** (version guard); never `-a`/`-am`, never `--no-verify`. On `main`, `CHANGELOG.md` must be staged with the commit (changelog guard -- a Claude hook, not a git hook). Keep a Changelog, `[Unreleased]` on top. Co-author trailer per harness rules.
- **Public-repo hygiene on every commit:** no vault item names, internal IPs/domains, real tenant/account IDs, tokens, or personal correspondents. Fixtures synthetic. Run `scripts/redaction-check.sh` before committing.
- **Docs are ASCII-only and never hard-wrapped.** No smart quotes, em dashes, or arrows: use `--` and `->`. Diagrams are Mermaid.
- **Remotes:** this repo may dual-push (GitHub + an internal mirror). `git remote -v` before pushing a WIP branch; internal hostnames never appear in tracked files.

## Architecture (LikeC4)

The architecture is modelled as code in `docs/architecture/*.c4` and is part of the deliverable, not a side artifact. The LikeC4 **workspace** is the repo root; the **project** is scoped by `docs/architecture/likec4.config.json`.

- Read the model before designing. The `likec4` MCP server is wired in `.mcp.json`: use `read-project-summary`, `search-element`, `read-element`, `find-relationships` instead of grepping `.c4` files (they resolve FQNs and derived relationships; grep does not). `preview-view` renders a draft view without writing files.
- A structural change to the code -- a new service, a new datastore, a relationship that did not exist -- updates `docs/architecture/*.c4` **in the same commit**. A phase that adds a component without its element is not done. The design spec lists, by FQN, what a phase adds, changes, or removes.
- `mise run check` runs `likec4 validate`, `likec4 format --check`, and a staleness check on the committed Mermaid in `docs/architecture/generated/` (and the landscape view spliced into `docs/architecture/README.md`). Regenerate with `mise run arch:gen` and commit the result.
- The gate proves the model is well-formed and the diagrams are current. It does **not** prove the model is true -- that is the code-review lane's job.

## Key locations

| Concern | Path |
|---|---|
| Gate, scripts, CI | `mise.toml`, `scripts/`, `.github/workflows/ci.yml` |
| Process | `GOAL.md`, `docs/progress.md`, `docs/phases/` |
| Design spec | `docs/superpowers/specs/` |
| Architecture model / project config / generated diagrams | `docs/architecture/*.c4`, `docs/architecture/likec4.config.json`, `docs/architecture/generated/` |
| Testing rules | `TESTING.md` |
| Harness bootstrap (marketplaces, plugins, MCP allowlist) | `.claude/settings.json`, `.mcp.json` |
| Codex brief | `AGENTS.md` |

## Commands you'll want

```bash
mise install                          # pinned toolchain
mise run check                        # the gate (all steps + dirty-tree banner); `mise run check -- <step>` for one
mise run arch:dev                     # live diagram browser at http://localhost:5173
mise run arch:validate                # LikeC4 syntax + layout-drift check
mise run arch:fmt                     # format .c4 sources in place
mise run arch:gen                     # regenerate committed Mermaid diagrams + README splice
scripts/redaction-check.sh            # staged index; --range main..phase-1/foo for a branch
fnox exec -- <cmd>                    # run with secrets injected
usage lint scripts/check.sh           # validate a #USAGE spec
```

## Gotchas

- `#USAGE` directives take **no space** after `#`. `usage` 6.0.0 silently ignores `# USAGE`, and the script then runs with every `usage_*` variable unset.
- The changelog guard and version guard are Claude hooks from agent-ops, not git hooks. If a commit is blocked, read the message and fix the staging -- do not bypass.
- `.claude/` is committed through a `.gitignore` allowlist (`settings.json` and `.gitignore` only). `git add .claude/anything-else` is silently ignored.
- `mise run check` on a dirty tree prints a banner and still exits 0: green describes disk, not HEAD. Verify `git status --porcelain` is empty before reporting a gate result.
- LikeC4 is pinned in `mise.toml [env] LIKEC4_VERSION`, not `[tools]` (it is not in the mise registry; every call is `pnpm dlx`). Bump only to a release at least 7 days old -- the pnpm release-age gate refuses younger ones and the failure reads as a resolution error, not a LikeC4 error.
- `.mcp.json` uses `${CLAUDE_PROJECT_DIR}`, not `${workspaceFolder}`: Claude Code does not expand the VS Code variable and passes it through literally.
- The first `mise run check` on a clean machine downloads ~120 MB of LikeC4; it is cached after that. There is no SVG export -- diagrams are committed as Mermaid so GitHub renders them; PNG needs Playwright and is not in the gate.
- The VS Code LikeC4 extension registers its own `likec4` MCP server, so you may see two. Both work; pick one.

## If you break something

- Gate red: read the first failing step's output; `mise run check -- <step>` isolates it.
- Hook blocked a commit: it is doing its job; check what you staged.
- Fresh session disoriented: `docs/progress.md` has the ledger and the how-to-resume checklist.
- CI green locally, red on GitHub: check that the `mise.toml` pins match and nothing depends on a local `mise.local.toml`.
