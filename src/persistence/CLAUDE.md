# Persistence Layer Context

<!-- SCOPED CLAUDE.md: This file provides context to AI agents when working within the src/persistence/ directory.
     It is read automatically when an agent's working context includes files under this path.

     INSTRUCTIONS FOR CUSTOMIZING THIS FILE:
     - Replace all [PLACEHOLDER] sections with project-specific content
     - Remove [OPTIONAL] sections that do not apply
     - Keep this file focused on the persistence layer only -- cross-cutting concerns belong in the root CLAUDE.md
     - Aim for under 100 lines -- agents read this on every persistence task, so keep it dense and useful -->

## What This Layer Does

<!-- [PLACEHOLDER] One short paragraph describing the role of the persistence layer.
     Example: "This layer owns all database access. It contains migrations, models/entities,
     repositories, and query objects. No other layer accesses the database directly." -->

[PLACEHOLDER: Describe the persistence layer's responsibility and boundaries]

## Technology

<!-- [PLACEHOLDER] Database engine, ORM or query builder, and notable configuration. -->

- Database: [PLACEHOLDER, e.g., PostgreSQL 16 / SQLite / MySQL 8]
- ORM / query builder: [PLACEHOLDER, e.g., Eloquent / SQLAlchemy / Drizzle]
- Migrations tool: [PLACEHOLDER, e.g., Laravel migrations / Alembic / Flyway]
- Connection config: [PLACEHOLDER, e.g., .env DB_* variables / config/database.php]

## Schema Conventions

<!-- [PLACEHOLDER] Rules for table naming, column naming, primary keys, etc. -->

- Table names: [PLACEHOLDER, e.g., plural snake_case: `user_profiles`, not `UserProfile`]
- Primary key: [PLACEHOLDER, e.g., auto-increment integer `id` on all tables]
- Timestamps: [PLACEHOLDER, e.g., all tables have `created_at` and `updated_at`]
- Soft deletes: [PLACEHOLDER, e.g., soft deletes via `deleted_at` where data must be retained]
- Foreign keys: [PLACEHOLDER, e.g., always enforced at the database level, not just ORM level]

## Migration Rules

<!-- [PLACEHOLDER] Conventions for writing and running migrations. -->

- [PLACEHOLDER: e.g., Migrations are append-only -- never edit a migration that has been merged to main]
- [PLACEHOLDER: e.g., Each migration must have a down() method that fully reverses it]
- [PLACEHOLDER: e.g., Column changes must be done via new migration, not by editing existing ones]
- To run migrations: [PLACEHOLDER, e.g., `php artisan migrate` / `alembic upgrade head`]
- To rollback: [PLACEHOLDER, e.g., `php artisan migrate:rollback`]

## Repository / Query Pattern

<!-- [PLACEHOLDER] How data access is structured. -->

[PLACEHOLDER: Describe the access pattern. Examples:
- "All data access goes through Repository classes in src/persistence/Repositories/"
- "Models are accessed directly via Eloquent -- no repository layer"
- "Query objects in src/persistence/Queries/ are used for complex reads; simple CRUD uses the ORM directly"]

## Sensitive Data

<!-- [PLACEHOLDER] Which fields contain PII or secrets and how they are handled. -->

- [PLACEHOLDER: e.g., `users.email` is considered PII -- do not log it, mask in test fixtures]
- [PLACEHOLDER: e.g., `users.password_hash` must never be returned from the API layer]
- [OPTIONAL: encryption-at-rest details]

## Testing

<!-- [PLACEHOLDER] How persistence layer code is tested. -->

- Test database: [PLACEHOLDER, e.g., SQLite in-memory / test PostgreSQL instance / Docker Compose]
- Seeding: [PLACEHOLDER, e.g., Factories in database/factories/, seeders in database/seeders/]
- To run: [PLACEHOLDER, e.g., `php artisan test --filter Persistence`]
- Transaction isolation: [PLACEHOLDER, e.g., "Tests wrap each test case in a transaction that is rolled back"]

## Related Layers

<!-- [OPTIONAL] Point to other scoped CLAUDE.md files for adjacent layers. -->

- API layer: `src/api/CLAUDE.md`
- Business logic / services: [OPTIONAL: path to CLAUDE.md if present]
