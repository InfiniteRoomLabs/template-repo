# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added

- `mise.toml` as the single toolchain entry point, with a `check` task and a language-agnostic gate skeleton (`scripts/check.sh`) that ends in a dirty-tree banner
- `scripts/redaction-check.sh`: public-repo hygiene check against the agent-ops redaction term list; no-op when `REDACTION_TERMS_RESOLVER` is not set
- LikeC4 tasks (`arch:validate`, `arch:fmt`, `arch:gen`, `arch:dev`) pinned through `pnpm dlx`, and `scripts/arch-gen.sh` with a `--check` mode that fails the gate on stale diagrams
- CI workflow (`.github/workflows/ci.yml`) running `mise run check` on SHA-pinned actions, with the `pnpm dlx` store cached per `LIKEC4_VERSION`
