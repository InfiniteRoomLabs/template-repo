# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

This repository was created from the `InfiniteRoomLabs/template-repo` template. It comes pre-configured with Spec Kitty for structured, spec-driven development.

## First-Time Setup

If this project has no `kitty-specs/` directory yet, it hasn't been initialized for development work. **Prompt the user to run `/init` to set up the project.** Offer to brainstorm if they're still figuring out what to build.

## Spec Kitty

This repo uses **Spec Kitty** for structured development workflows.

### Workflow Phases (in order)
`specify` -> `plan` -> `tasks` -> `implement` -> `review` -> `accept` -> `merge`

Each phase has a corresponding `/spec-kitty.{phase}` command. Always run them in sequence.

### Three Mission Types
- **software-dev**: research -> design -> implement -> test -> review. TDD-first, library-first architecture.
- **research**: question -> methodology -> gather -> analyze -> synthesize -> publish. Tracks sources in CSV evidence logs.
- **documentation**: discover -> audit -> design -> generate -> validate -> publish. Follows Divio 4-type system (tutorial, how-to, reference, explanation).

### Key Directories
- `.kittify/` -- Mission definitions, templates, and scripts. Ignored by `.claudeignore` -- do not scan.
- `.claude/commands/spec-kitty.*.md` -- Agent-facing commands generated from `.kittify/` templates.
- `kitty-specs/NNN-feature-name/` -- Working artifacts for each feature (spec.md, plan.md, tasks.md, etc.).

## Agent Marketplace

This project is configured to use the Infinite Room Labs private Claude Code marketplace. Install plugins with:

```
/plugin marketplace add InfiniteRoomLabs/agent-ops
/plugin install core@infinite-room-labs
```

## Project Structure

This repo uses a layered structure for documentation, agent skills, tooling, and scoped context.

```
project/
  CLAUDE.md                        <- root agent context (this file)
  docs/
    architecture.md                <- system architecture overview
    decisions/                     <- Architecture Decision Records (ADRs)
      000-template.md              <- copy this to create a new ADR
    runbooks/
      README.md                    <- operational runbook conventions
  .claude/
    commands/                      <- Spec Kitty agent commands (generated)
    skills/
      code-review/SKILL.md         <- reusable code review workflow
      refactor/SKILL.md            <- safe refactoring workflow
      release/SKILL.md             <- versioning, changelog, tagging, publish
  tools/
    scripts/
      README.md                    <- utility script conventions
    prompts/
      README.md                    <- reusable prompt template conventions
  src/
    api/
      CLAUDE.md                    <- scoped context for the API layer
    persistence/
      CLAUDE.md                    <- scoped context for the persistence layer
  kitty-specs/                     <- Spec Kitty working artifacts (created on use)
```

## Scoped CLAUDE.md Files

Context files can exist at any directory level. Agents load the CLAUDE.md closest to the files they are working with, in addition to this root file. This means:

- `src/api/CLAUDE.md` provides API-layer context when working in `src/api/`
- `src/persistence/CLAUDE.md` provides persistence context when working in `src/persistence/`
- You can add a CLAUDE.md to any subdirectory to provide scoped guidance

**When creating a scoped CLAUDE.md:**

1. Keep it focused on that layer only -- cross-cutting concerns stay in this root file
2. Aim for under 100 lines -- agents read this on every task in the directory
3. Include: what the layer does, its tech, key conventions, how to test it, and links to adjacent layers
4. Replace all `[PLACEHOLDER]` blocks before committing -- placeholders in CLAUDE.md files confuse agents

## Agent Skills

Reusable agent workflows live in `.claude/skills/`. Each skill is a structured procedure an agent can follow end-to-end. Available skills:

| Skill | Path | Invocation |
|-------|------|-----------|
| Code Review | `.claude/skills/code-review/SKILL.md` | "Use the code-review skill to review this PR" |
| Refactor | `.claude/skills/refactor/SKILL.md` | "Use the refactor skill to clean up src/api/UserController.php" |
| Release | `.claude/skills/release/SKILL.md` | "Use the release skill to cut a patch release" |

Note: `.claude/` is in `.claudeignore` and `.gitignore` -- skills are available to local agents but are not committed to the repo. This is by design (see Git Discipline below). To share skills with a team, publish them via the agent-ops marketplace.

## Documentation

- `docs/architecture.md` -- fill in the system overview, component diagram, data flow, tech stack, and deployment topology for this project
- `docs/decisions/` -- use ADRs for any significant technical choice. Copy `docs/decisions/000-template.md` to create a new one. Name files `NNN-short-slug.md` with a sequential number
- `docs/runbooks/` -- operational procedures for recurring production tasks. See `docs/runbooks/README.md` for conventions

## Tooling

- `tools/scripts/` -- utility scripts for development, CI, and ops. See `tools/scripts/README.md` for conventions
- `tools/prompts/` -- reusable prompt templates for common AI-assisted tasks. See `tools/prompts/README.md` for format

## Conventions

### File Encoding
**UTF-8 only.** No Windows-1252 smart quotes, em/en dashes, or copy-pasted Office characters. Use ASCII equivalents (`"` not curly quotes, `-` not em dash, `->` not arrows). Run `spec-kitty validate-encoding --feature <id>` to check, add `--fix` to auto-repair.

### Diagrams
**Always use Mermaid** for all diagrams. No ASCII art dependency graphs or architecture diagrams.

### Path References
Always use absolute paths or paths relative to project root. Never refer to a folder by name alone.

### Git Discipline
- Never commit agent directories (`.claude/`, `.codex/`, `.gemini/`, etc.)
- Imperative mood commit messages
- Never rewrite shared branch history
- Never commit secrets or credentials
