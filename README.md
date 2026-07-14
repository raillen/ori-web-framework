# ori-web-framework

HTML-first web stack for **[Ori](https://github.com/raillen/ori-lang)**  
(templates · HTTP library · App generators · optional 2FA / SQLite sessions).

| | |
|--|--|
| **Repo** | https://github.com/raillen/ori-web-framework |
| **Language** | Ori ≥ **0.3.5+** (runtime with argon2, TOTP, net timeouts for full demos) |
| **Status** | Feature freeze v1 — see [`FREEZE-WEB.md`](FREEZE-WEB.md) |
| **Package registry (name)** | **OriLamp** — public package index / `ORI_REGISTRY` (site TBD: Pages or Vercel) |

This repository is the **framework monorepo** (libraries + demos only).  
The **Ori compiler** lives in [ori-lang](https://github.com/raillen/ori-lang).

## Layout

```text
ori-web-framework/
  packages/                 # libraries (path-depend these)
    ori-templates/
    ori-web/
    ori-web-app/
    ori-web-auth/
    ori-web-session-sqlite/
  demos/                    # examples (not required for apps)
  docs/                     # phase B/C/D, middleware
  tools/qa/                 # smoke scripts
  FREEZE-WEB.md
  ori-sqlite.README.md      # optional native SQLite link
```

## Prerequisites

1. **Ori** on `PATH` (install from ori-lang releases / local build).  
2. For password/TOTP demos: runtime staged with `ori.crypto` + TOTP.  
3. For SQLite sessions: build [ori-sqlite](https://github.com/raillen/ori-sqlite) and symlink:

```bash
ln -sfn "$HOME/Documentos/Projetos/ori-sqlite" packages/ori-sqlite
( cd packages/ori-sqlite && ./tools/build_linux.sh )
```

## Use in your app

```bash
git clone git@github.com:raillen/ori-web-framework.git
# or extract a future release tarball
```

```toml
# your-app/ori.proj
[dependencies]
web = { path = "../ori-web-framework/packages/ori-web", version = "0.1.0" }
templates = { path = "../ori-web-framework/packages/ori-templates", version = "0.1.0" }
# optional:
# web_app = { path = "../ori-web-framework/packages/ori-web-app", version = "0.1.0" }
# web_auth = { path = "../ori-web-framework/packages/ori-web-auth", version = "0.1.0" }
```

### What to depend on

| Need | Packages |
|------|----------|
| Minimal HTML site | `ori-templates` + `ori-web` |
| Generators / conventions | + `ori-web-app` |
| TOTP 2FA | + `ori-web-auth` |
| SQLite sessions | + `ori-web-session-sqlite` + `ori-sqlite` |

You do **not** need every package in every app.

## Demos

| Demo | Stack | Port (default) |
|------|--------|----------------|
| **`ori-notes`** | `ori-web` + **`ori-templates`** notes app (Fly-ready) | `3460` / `$PORT` |
| **`landing-page`** | **Svelte** SPA + Ori static/API (Fly-ready) | `3461` / `$PORT` |
| `ori-web-demo` | templates + HTMX notes | `3457` |
| `ori-web-demo-auth` | TOTP 2FA | `3459` |
| `hello_server` | minimal | `3456` |
| `blog_app` | full `web_app` scaffold | `3000` |

```bash
export ORI_BIN=ori   # or path to compiler build

# Product demos (recommended for Fly)
cd demos/ori-notes && ori run main.orl
cd demos/landing-page/frontend && npm install && npm run build
cd demos/landing-page && ori run main.orl

# Earlier samples
cd demos/ori-web-demo && ori run main.orl          # :3457
cd demos/ori-web-demo-auth && ORI_USE_AOT=1 ori run main.orl  # :3459
cd demos/hello_server && ori run main.orl          # :3456
```

| Demo | Port |
|------|------|
| hello_server | 3456 |
| ori-web-demo | 3457 |
| ori-web-demo-api | 3458 |
| ori-web-demo-auth | 3459 |
| ori-web-demo-upload | 3460 |
| blog_app | 3000 |
| sec8_tests | (no server) |

## QA

```bash
./tools/qa/web_sec8.sh
./tools/qa/web_auth_smoke.sh
./tools/qa/web_session_sqlite_smoke.sh   # needs ori-sqlite + AOT
```

## OriLamp (package registry)

**OriLamp** is the product name for Ori’s public package shelf — *a lamp for
readable packages*, in the spirit of “ori” (light) and reading-first code.

Planned shape (simple static host is enough):

```text
ORI_REGISTRY=https://orilamp…   # GitHub Pages or Vercel
  packages/web/0.1.0.tar.gz
  packages/templates/0.1.0.tar.gz
  …
```

```bash
export ORI_REGISTRY=https://…   # OriLamp base URL
ori install web@0.1.0
```

Until OriLamp is online, use path/tarball/git as below.

## Install options (not only `git clone`)

| Method | How | When |
|--------|-----|------|
| **Path + tarball** | Download release asset, extract, `path = "…/packages/ori-web"` | Users with Ori installed |
| **Path + git** | `git clone` this repo (or tag), same path deps | Contributors / full demos |
| **OriLamp (registry)** | `ori publish` each package → `ori install web@0.1.0` | When `ORI_REGISTRY` points at OriLamp |
| **Git dep in ori.proj** | `{ git = "…", tag = "v0.1.0" }` | **Only if** the package is the **root** of that git repo |

This monorepo has **several** packages under `packages/`. The Ori manager can:

```toml
# version pin (needs ORI_REGISTRY with published packages)
web = "0.1.0"

# path (local clone or tarball extract)
web = { path = "../ori-web-framework/packages/ori-web", version = "0.1.0" }

# git (single-package repos) — not ideal for this multi-package monorepo root
# web = { git = "https://github.com/…/ori-web.git", tag = "v0.1.0" }
```

```bash
ori get .                 # fetch declared git/path deps into ~/.ori/packages
ori install web@0.1.0     # from ORI_REGISTRY (file:// or https)
ori publish ./packages/ori-web   # publish one package to the registry
```

So: **not only git clone** — tarball + path is the main user path; **registry** is the “npm-like” path when you configure it.

### Release tarball

```bash
./tools/package_release.sh 0.1.0
# → dist/ori-web-framework-0.1.0.tar.gz
```

GitHub Releases attach that archive (see tag `v0.1.0`).

## License

Same spirit as Ori (see package headers / upstream ori-lang).
