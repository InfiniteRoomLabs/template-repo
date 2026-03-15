# API Layer Context

<!-- SCOPED CLAUDE.md: This file provides context to AI agents when working within the src/api/ directory.
     It is read automatically when an agent's working context includes files under this path.

     INSTRUCTIONS FOR CUSTOMIZING THIS FILE:
     - Replace all [PLACEHOLDER] sections with project-specific content
     - Remove [OPTIONAL] sections that do not apply
     - Keep this file focused on the API layer only -- cross-cutting concerns belong in the root CLAUDE.md
     - Aim for under 100 lines -- agents read this on every API task, so keep it dense and useful -->

## What This Layer Does

<!-- [PLACEHOLDER] One short paragraph describing the role of the API layer in this system.
     Example: "This is a REST API built with Laravel. It handles authentication, request validation,
     and delegates business logic to services in src/services/. It does not contain business logic itself." -->

[PLACEHOLDER: Describe the API layer's responsibility and boundaries]

## Technology

<!-- [PLACEHOLDER] Framework, version, and any notable configuration. -->

- Framework: [PLACEHOLDER, e.g., Laravel 11 / FastAPI 0.110 / Express 4]
- Auth: [PLACEHOLDER, e.g., Laravel Sanctum / JWT / OAuth2]
- API style: [PLACEHOLDER, e.g., REST / GraphQL / JSON:API]

## Request Lifecycle

<!-- [PLACEHOLDER] Brief description of how a request flows through this layer.
     Include middleware order if it is non-obvious. -->

1. [PLACEHOLDER: e.g., Request hits router]
2. [PLACEHOLDER: e.g., Auth middleware validates token]
3. [PLACEHOLDER: e.g., Form Request validates and transforms input]
4. [PLACEHOLDER: e.g., Controller delegates to Service]
5. [PLACEHOLDER: e.g., Response is serialized and returned]

## Key Conventions

<!-- [PLACEHOLDER] Rules that apply specifically to API layer code. -->

- [PLACEHOLDER: e.g., Controllers must not contain business logic -- delegate to Services]
- [PLACEHOLDER: e.g., All responses use a consistent envelope: { data, meta, errors }]
- [PLACEHOLDER: e.g., Validation lives in Form Request classes, not inline in controllers]
- [PLACEHOLDER: e.g., HTTP status codes must be meaningful -- no 200 OK with an error body]

## Directory Structure

<!-- [PLACEHOLDER] Brief map of this layer's subdirectories and what goes where. -->

```
src/api/
  [PLACEHOLDER: directory]  -- [PLACEHOLDER: what it contains]
  [PLACEHOLDER: directory]  -- [PLACEHOLDER: what it contains]
```

## Error Handling

<!-- [PLACEHOLDER] How errors are caught, formatted, and returned. -->

[PLACEHOLDER: Describe error handling strategy, e.g., "All exceptions are caught by a global handler
that maps them to structured error responses. See src/api/Exceptions/Handler.php."]

## Testing

<!-- [PLACEHOLDER] How API layer code is tested. -->

- Test location: [PLACEHOLDER, e.g., tests/Feature/Api/]
- Test style: [PLACEHOLDER, e.g., HTTP feature tests that hit real routes with a test database]
- To run: [PLACEHOLDER, e.g., `php artisan test --filter Api`]

## Related Layers

<!-- [OPTIONAL] Point to other scoped CLAUDE.md files for adjacent layers. -->

- Business logic / services: [OPTIONAL: path to CLAUDE.md if present]
- Persistence: `src/persistence/CLAUDE.md`
