# Database migrations (future)

> **Status:** not implemented. This document is the product placeholder so CLI and docs stay honest.

## Planned direction (L1 — SQLite first)

```text
db/
  migrations/
    001_init.sql
    002_add_posts.sql
  schema_migrations   # table: version TEXT PRIMARY KEY, applied_at …
```

```bash
# future CLI (not available yet)
ori-web db migrate
ori-web db status
```

## Runner sketch

1. Open SQLite via `ori-sqlite` / configured DSN.
2. Ensure `schema_migrations` exists.
3. Apply pending `*.sql` files in lexicographic order inside a transaction.
4. Record version after success.

## Out of scope for L1

- Multi-database drivers (Postgres/MySQL)
- Auto-generated migrations from models
- Down/rollback chains
- ORM

## Until then

- Demos use **in-memory** stores or ad-hoc SQL at boot.
- Production apps should manage schema with external tooling or hand-written SQL scripts checked into the repo.

## Tracking

When implementing, start from `ori-sqlite` + a small package `web_db` (name TBD) so `ori-web` stays free of storage policy.
