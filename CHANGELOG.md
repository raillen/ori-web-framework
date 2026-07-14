# Changelog — ori-web-framework

## [0.1.0] — 2026-07-14

### Added
- Initial import from `ori-lang` packages (feature freeze v1):
  - `ori-templates` (S8 whitespace trim)
  - `ori-web` (HTTP, session, CSRF, middleware, nested JSON, upload, B7, keep-alive)
  - `ori-web-app` (generators, standard_app)
  - `ori-web-auth` (TOTP 2FA helpers)
  - `ori-web-session-sqlite` (SQLite session adapter)
  - Demos: hello, notes, API, auth+2FA, upload, blog_app, SEC8
- Docs: FREEZE-WEB, phase B/C/D, middleware, packaging notes
- QA scripts under `tools/qa/`

Requires **Ori** language runtime with crypto (argon2/TOTP) and net timeouts for full demos.
