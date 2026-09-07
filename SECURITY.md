# Security

Report vulnerabilities privately through GitHub's "Report a vulnerability" form on this repository's Security tab (private vulnerability reporting), not in a public issue. You will get an acknowledgement within a few days.

Secrets never live in this repository: they are injected per command with `fnox exec --` from a gitignored `fnox.toml`. If you find a committed credential, report it the same way and treat it as compromised.
