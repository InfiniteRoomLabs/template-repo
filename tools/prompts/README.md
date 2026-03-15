# Prompt Templates

Reusable prompt templates for common AI-assisted tasks in this project. These are starting points, not magic words -- adapt them to your specific situation.

## What Goes Here

A prompt template belongs here if:

- It is used repeatedly across the project (not a one-off)
- It encodes project-specific context that would otherwise be re-typed each time
- It produces consistent, high-quality output when followed

A prompt does NOT belong here if it is specific to a single task or feature -- those should live in the relevant `kitty-specs/NNN-feature/` directory.

## File Format

Each prompt template is a plain `.md` file. Name it descriptively:

```
tools/prompts/
  generate-unit-tests.md
  write-api-documentation.md
  analyze-performance-bottleneck.md
  review-database-schema.md
```

### Template Structure

```markdown
# [Task Name]

## Purpose
[One sentence: what does this prompt help accomplish?]

## When to Use
[Conditions under which this template is appropriate]

## Context to Provide
Before using this prompt, gather:
- [Required context item 1]
- [Required context item 2]

## Prompt

---
[The actual prompt text. Use {{VARIABLE}} syntax for slots that must be filled in.]
---

## Expected Output
[Brief description of what a good response looks like]

## Notes
[Any caveats, known limitations, or tips for getting better results]
```

## Usage

1. Open the relevant template
2. Gather the context items listed under "Context to Provide"
3. Paste the prompt into your AI tool, filling in `{{VARIABLE}}` slots
4. Review the output against the "Expected Output" criteria

## Relationship to Skills

Skills (in `.claude/skills/`) are agent-executable workflows -- the agent runs them end to end. Prompt templates (here) are human-in-the-loop -- you copy, customize, and invoke them yourself.

Use skills for repetitive multi-step tasks. Use prompt templates for tasks where you want to stay in control of each step.

## Example Template

```markdown
# Generate Unit Tests for a Function

## Purpose
Generate comprehensive unit tests for a single function or method.

## When to Use
When adding tests to untested code, or when writing tests for a new function before implementation (TDD).

## Context to Provide
- The function signature and body (or a description if TDD)
- The language and test framework in use
- Any known edge cases

## Prompt

---
Write unit tests for the following {{LANGUAGE}} function using {{TEST_FRAMEWORK}}.

Function:
{{FUNCTION_CODE}}

Requirements:
- Cover the happy path
- Cover at least 3 edge cases: {{EDGE_CASES_OR_"identify them yourself"}}
- Use descriptive test names that read as documentation
- Do not test implementation details -- test observable behavior only
---

## Expected Output
A test file with clearly named test cases, each covering one behavior.
```
