# Lantern

**Ori is my light. Lantern is how it shines on the web.**

HTML-first web stack for **[Ori](https://github.com/raillen/ori-lang)**  
(templates · HTTP · app generators · optional 2FA / SQLite sessions).

| | |
|--|--|
| **Product** | **Lantern** |
| **Repo** | https://github.com/raillen/ori-web-framework |
| **Language** | Ori ≥ **0.3.5+** (argon2, TOTP, net timeouts for full demos) |
| **Status** | Feature freeze v1 — see [`FREEZE-WEB.md`](FREEZE-WEB.md) |
| **Registry** | **[OriLamp](https://github.com/raillen/ori-lamp)** (`ORI_REGISTRY`) |

This monorepo is the **Lantern** libraries + demos.  
The **Ori compiler** lives in [ori-lang](https://github.com/raillen/ori-lang).  
Brand notes: [`docs/BRAND.md`](docs/BRAND.md).

## Layout

```text
ori-web-framework/          # Lantern monorepo
  packages/
    ori-templates/          # package id: templates
    ori-web/                # package id: web
    ori-web-app/
    ori-web-auth/
    ori-web-session-sqlite/
  demos/                    # product demos
  docs/                     # CLEAN-CODE, CLI, UI-PRESETS, BRAND, MIGRATIONS
  tools/ori-web             # developer CLI
  tools/qa/                 # smoke scripts + content-length test
  FREEZE-WEB.md
```

## CLI (scaffold & serve)

```bash
./tools/ori-web help
./tools/ori-web new myapp
./tools/ori-web new notes --template=notes
./tools/ori-web new site --template=landing --ui=svelte
cd myapp && ori get . && ../../tools/ori-web serve
./tools/ori-web generate scaffold posts
```

| Docs | Topic |
|------|--------|
| [`docs/BRAND.md`](docs/BRAND.md) | Lantern name + tagline |
| [`docs/CLEAN-CODE.md`](docs/CLEAN-CODE.md) | Style (framework + apps) |
| [`docs/CLI.md`](docs/CLI.md) | Templates & generators |
| [`docs/UI-PRESETS.md`](docs/UI-PRESETS.md) | Optional HTMX / Svelte / Vue / Solid |
| [`docs/MIGRATIONS.md`](docs/MIGRATIONS.md) | Future — not implemented |

Package IDs stay short (`web`, `templates`). The **product** is Lantern.

## Prerequisites

1. **Ori** on `PATH`.  
2. Optional: runtime with `ori.crypto` + TOTP for 2FA demos.  
3. Optional: [ori-sqlite](https://github.com/raillen/ori-sqlite) for SQLite:

```bash
ln -sfn "$HOME/Documentos/Projetos/ori-sqlite" packages/ori-sqlite
( cd packages/ori-sqlite && ./tools/build_linux.sh )   # .a + .so
```

## Use in your app

```toml
# your-app/ori.proj
[dependencies]
web = { path = "../ori-web-framework/packages/ori-web", version = "0.1.0" }
templates = { path = "../ori-web-framework/packages/ori-templates", version = "0.1.0" }
```

Or from OriLamp: `web_framework` meta-package (core: web + templates + web_app).

### What to depend on

| Need | Packages |
|------|----------|
| Minimal HTML site | `templates` + `web` |
| Generators / conventions | + `web_app` |
| TOTP 2FA | + `web_auth` |
| SQLite sessions | + `web_session_sqlite` + `sqlite` |

## Demos

| Demo | Stack | Port |
|------|--------|------|
| **ori-notes** | templates notes (Fly) | `3460` / `$PORT` |
| **landing-page** | Svelte + Ori API (Fly) | `3461` / `$PORT` |
| **micro-blog** | Auth · SQLite · Markdown (Fly) | `3470` / `$PORT` |
| ori-web-demo | templates + HTMX | `3457` |
| ori-web-demo-auth | TOTP 2FA | `3459` |
| hello_server | minimal | `3456` |

```bash
export ORI_BIN=ori
cd demos/micro-blog && ori get . && ori run main.orl   # needs sqlite .so or AOT
cd demos/ori-notes && ori run main.orl
```

Live:

- https://ori-notes.fly.dev/  
- https://ori-landing.fly.dev/  
- https://ori-micro-blog.fly.dev/ (demo login `test` / `password123`)

## QA / CI

```bash
./tools/qa/web_sec8.sh
./tools/qa/content_length_utf8.sh
./tools/qa/demo_smoke.sh
```

GitHub Actions runs the same gate on push (see `.github/workflows/ci.yml`).

## Philosophy

Lantern keeps Ori’s promise — **read first, magic last**: explicit routes, safe template defaults, small apps you can reopen months later.
