# TESTING.md -- how <project> tests

Referenced from `CLAUDE.md` and `README.md`. This is the single source of truth for **how we test**; the concrete steps are the ones `scripts/check.sh` runs (`<gate-steps>`).

## The green rule -- always run green, never ignore, never silence

Non-negotiable, enforced by tooling, not honor system:

- **Never skip or focus:** no `.skip`, `.only`, `.todo`, `xit`, `t.Skip`, `@pytest.mark.skip` or their equivalents in committed tests without an inline link to a tracked issue. Ban them in the linter **and** in a `check.sh` grep step, not in a review checklist.
- **Never silence:** no blanket ignore pragmas (`@ts-ignore`, `eslint-disable`, `# noqa`, `//nolint`, muted output) without an inline justification linked to an issue.
- **Never ignore:** a failing test blocks the merge. There is no "known-failing" allowance -- intentionally divergent behavior is fixed or locked in by a *passing* test that documents it.
- **Warnings are errors.** Lint and compiler warnings fail the gate.

`mise run check` must be green on a clean tree (`git status --porcelain` empty) before any phase merges. A green gate on a dirty tree describes disk, not HEAD.

## The pyramid

Bias toward the cheapest layer that can catch the bug: unit and functional tests at the base, integration above, end-to-end at the tip. A bug found by an e2e test that a unit test could have caught is a missing unit test.

## Path taxonomy

Tag test names so triage can grep them. A feature is not done until every applicable tag is covered.

| Tag | Covers |
|---|---|
| `happy` | the intended path with valid input |
| `sad` | invalid input, expected failures, error responses |
| `raging` | hostile or malformed input, abuse, limits exceeded |
| `edge` | boundaries: empty, one, maximum, unicode, time zones |
| `corner` | two or more edges at once |

## Coverage

Set a floor and enforce it in the gate (`scripts/check.sh`), not in promises. Excluding files from the measurement is a design decision: flag it in the same commit and keep the excluded set tiny (an entrypoint with one statement, not "everything hard to test").
