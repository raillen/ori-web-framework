# Clean code for ori-web-framework

This monorepo follows the project **clean-code** contract (modularization, verb+domain names, Rule of Three, anti-primitive obsession, no `utils` dump).

## Framework (contributors)

| Rule | Practice |
|------|----------|
| One concept per module | `web` = HTTP; `templates` = HTML; `web_app` = conventions |
| Small functions | Handlers orchestrate; helpers do one job |
| Explicit errors | Prefer `result` / match over silent failure |
| Names | English identifiers; decision comments only when non-obvious |
| No drive-by refactors | Scoped PRs |

Scaffolds and demos **must** stay easy to read — they teach the default style.

## Applications (users)

We **encourage** the same rules without enforcing a linter on your code:

1. **Use generators** — `tools/ori-web new` / `generate scaffold` produce thin controllers + explicit routes.
2. **No HTML in handlers** — render `.orix` (or return JSON); never build large markup strings.
3. **No `raw` for user data** — templates escape by default; `raw` is for trusted layout HTML only.
4. **Domain modules when logic grows** — third copy of the same block → extract (Rule of Three).
5. **Config vs secrets** — ports/paths in config; secrets only via env (`ORI_WEB_SECRET`).

## Anti-patterns

- God `main.orl` with all routes and SQL
- Shared `utils.orl` grab-bag
- Catch-all error messages that hide causes
- Magic globals instead of function parameters

## Related

- `docs/CLI.md` — project generators
- `docs/UI-PRESETS.md` — optional frontends
- Global skill: clean-code (Grok / agents)
