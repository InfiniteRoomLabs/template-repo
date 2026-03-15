# Runbooks

Runbooks are step-by-step operational procedures for tasks that recur in production or staging environments. They exist so that any team member (or agent) can execute a critical operation correctly without tribal knowledge.

## Conventions

### One File Per Operation

Each runbook covers exactly one operation or incident type. Name files with a short, imperative slug:

```
docs/runbooks/
  deploy-production.md
  rollback-release.md
  restore-database-backup.md
  rotate-api-keys.md
  debug-worker-queue-backlog.md
```

### Required Sections

Every runbook must have:

1. **Purpose** -- one sentence on what this runbook accomplishes and when to use it
2. **Prerequisites** -- access, credentials, tools, or state required before starting
3. **Steps** -- numbered, atomic steps. Each step should be independently verifiable
4. **Verification** -- how to confirm the operation succeeded
5. **Rollback** -- what to do if something goes wrong mid-operation

### Optional Sections

- **Estimated Duration** -- rough time expectation so operators know if something is taking too long
- **Escalation** -- who to contact if the runbook fails or the situation is out of scope
- **Background** -- optional context for understanding *why* each step is done

### Writing Style

- Use imperative mood: "Run the migration" not "You should run the migration"
- Include exact commands where possible, not paraphrases
- Mark variables in commands clearly: `export DB_HOST=<your-host>`
- If a step requires human judgment, say so explicitly: "Verify the output looks correct before proceeding"
- Keep steps short -- one action per step. Multi-action steps hide failures

### Example Runbook Skeleton

```markdown
# [Operation Name]

**Purpose**: [One sentence]

**Last verified**: YYYY-MM-DD

## Prerequisites

- [ ] [Access or credential 1]
- [ ] [Tool installed: e.g., `kubectl` >= 1.28]
- [ ] [State requirement: e.g., staging deploy must be green]

## Steps

1. [First action]

       # command example
       some-command --flag value

2. [Second action]

3. [Verification check mid-process, if needed]

## Verification

[How to confirm success]

## Rollback

[What to do if this fails partway through]
```

## Maintenance

- Update a runbook any time you discover a step is wrong or missing
- Add a "Last verified" date each time you successfully execute it
- If a runbook is no longer needed, delete it -- stale runbooks cause incidents
