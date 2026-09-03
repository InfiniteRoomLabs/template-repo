# <project>

<one-line-description>

MIT licensed. Built by [Infinite Room Labs](https://github.com/InfiniteRoomLabs).

## Install / run

```sh
git clone https://github.com/InfiniteRoomLabs/<repo>.git
cd <repo>
mise install
mise run check
```

## Architecture

The architecture is modelled as code with [LikeC4](https://likec4.dev) in `docs/architecture/`. The landscape view is rendered in [docs/architecture/README.md](docs/architecture/README.md); `mise run arch:dev` opens the interactive version.

## Contributing

- Toolchain via [mise](https://mise.jdx.dev/): `mise install`. `<toolchain>`.
- The gate: `mise run check`. See `TESTING.md` for the testing rules.
- Commits: [Conventional Commits](https://www.conventionalcommits.org/), imperative mood, scoped.
- If you use Claude Code, install the [agent-ops marketplace](https://github.com/InfiniteRoomLabs/agent-ops) -- it provides the changelog guard that keeps `CHANGELOG.md` honest and the `/new-goal-loop` skill this repo is built with.
- `scripts/redaction-check.sh` (a pre-commit hygiene check) is optional for outside contributors; it no-ops when `REDACTION_TERMS_RESOLVER` is not set.

## Using this template (delete this section after cutting a new repo)

1. Replace every placeholder: `<project>`, `<one-line-description>`, `<toolchain>`, `<gate-steps>`, `<repo>`, `<slug>`. Verify with `grep -rEn '<(project|one-line-description|toolchain|gate-steps|repo|slug)>' --exclude-dir=.git .` -- it must print nothing. (Angle-bracket notation like `<cmd>` in CLAUDE.md, and the per-phase slots in `docs/progress.md`, are not placeholders.)
2. Pin the real toolchain in `mise.toml [tools]`.
3. Fill in `scripts/check.sh`: one `run_<step>` per gate step, list them in `steps`, wire them into `run_step`. Verify `mise run check` is green.
4. Describe the system in `docs/architecture/model.c4` (and `spec.c4`/`views.c4` as needed), then `mise run arch:gen` and commit the regenerated diagrams.
5. Truncate `CHANGELOG.md` to an empty `[Unreleased]` section.
6. Run `/new-goal-loop <what you are building>` in Claude Code to produce `GOAL.md`, the design spec, and the phase work orders.
7. Delete this section.
