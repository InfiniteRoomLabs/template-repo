# Scripts

Utility scripts that support development, CI, and operational tasks. These are not part of the application -- they are developer tools.

## Conventions

### Location

All utility scripts live in `tools/scripts/`. Do not scatter one-off scripts in the project root or other directories.

### Naming

Use lowercase kebab-case with a descriptive name:

```
tools/scripts/
  seed-database.sh
  generate-api-client.py
  check-env-vars.sh
  run-integration-tests.sh
```

Prefix scripts with a domain if the directory grows large:

```
tools/scripts/
  db-seed.sh
  db-migrate-down.sh
  ci-preflight.sh
  ci-notify-slack.sh
```

### Language Choice

| Use case | Preferred language |
|----------|--------------------|
| Shell automation, piping, CI steps | `bash` (shebang: `#!/usr/bin/env bash`) |
| Data processing, complex logic | `python` (via `uv run` -- never bare `python`) |
| Node-adjacent tasks (e.g., bundling, codegen) | `node` / `ts-node` via `nvm` |

Avoid mixing languages unnecessarily. If a task can be done cleanly in bash, do it in bash.

### Script Structure (Bash)

Every bash script must:

1. Start with `#!/usr/bin/env bash`
2. Set `set -euo pipefail` immediately after the shebang
3. Define a `usage()` function if the script accepts arguments
4. Print what it is doing at each major step (`echo "Seeding database..."`)

```bash
#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <environment>"
  echo "  environment: dev | staging | prod"
  exit 1
}

[[ $# -lt 1 ]] && usage

ENV="$1"
echo "Seeding database for environment: $ENV"
# ...
```

### Script Structure (Python via uv)

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["httpx", "rich"]
# ///

"""
Short description of what this script does.
Usage: uv run tools/scripts/my-script.py [args]
"""
```

### Documentation

Every script must have a comment block at the top explaining:
- What it does
- When to run it
- Required environment variables or arguments
- Example invocation

### Permissions

Scripts meant to be executed directly must have execute permissions:

```
chmod +x tools/scripts/my-script.sh
```

Commit the permission bit: `git update-index --chmod=+x tools/scripts/my-script.sh`

### Testing

Scripts that are run in CI or handle sensitive operations (migrations, data transforms) should have a `--dry-run` flag that prints what would happen without doing it.
