# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `mise.toml` as the single toolchain entry point, with a `check` task and a language-agnostic gate skeleton (`scripts/check.sh`) that ends in a dirty-tree banner
- `scripts/redaction-check.sh`: public-repo hygiene check against the agent-ops redaction term list; no-op when `REDACTION_TERMS_RESOLVER` is not set
- LikeC4 tasks (`arch:validate`, `arch:fmt`, `arch:gen`, `arch:dev`) pinned through `pnpm dlx`, and `scripts/arch-gen.sh` with a `--check` mode that fails the gate on stale diagrams
- CI workflow (`.github/workflows/ci.yml`) running `mise run check` on SHA-pinned actions, with the `pnpm dlx` store cached per `LIKEC4_VERSION`
- Claude Code harness bootstrap: committed `.claude/settings.json` (marketplaces, default plugins `agency@infinite-room-labs`, `superpowers`, `claude-md-management`, and the `likec4` MCP allowlist) via a `.gitignore` allowlist, `.claude/.gitignore` for local overrides, and a `.claudeignore` that deliberately does not hide `.claude/`
- `CLAUDE.md` rewritten as the project rulebook (first run, toolchain, working conventions, LikeC4 architecture, key locations, gotchas), plus `AGENTS.md` (Codex pointer), `TESTING.md` (the green rule), `docs/progress.md` (resume anchor), `docs/superpowers/specs/` (where the design spec lands), and an MIT `LICENSE`
- LikeC4 architecture workspace: `docs/architecture/{likec4.config.json,spec.c4,model.c4,views.c4}` with a seeded model, committed Mermaid exports in `docs/architecture/generated/` spliced into `docs/architecture/README.md`, the `likec4` MCP server in `.mcp.json` (pinned, `pnpm dlx` under the pnpm hardening flags), and a VS Code extension recommendation

### Changed

- `.gitignore` now ignores secret and tool wiring (`fnox.toml`, `mise.local.toml`, `.env*`, `.envrc`), `.worktrees/`, and build output, and allowlists the committed `.claude/` files instead of ignoring the directory
- The GOAL treadmill is installed by running `/new-goal-loop` (agent-ops), not vendored: the template ships only `docs/progress.md`
