# ori-web-framework

HTML-first web stack for **[Ori](https://github.com/raillen/ori-lang)**  
(templates · HTTP library · App generators · optional 2FA / SQLite sessions).

| | |
|--|--|
| **Repo** | https://github.com/raillen/ori-web-framework |
| **Language** | Ori ≥ **0.3.5+** (runtime with argon2, TOTP, net timeouts for full demos) |
| **Status** | Feature freeze v1 — see [`FREEZE-WEB.md`](FREEZE-WEB.md) |

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

```bash
export ORI_BIN=ori   # or path to compiler build
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

## Distribution (later)

- **This Git monorepo** = develop / version the framework.  
- **Tarball** (optional CI): zip of `packages/*` + README for users who already have Ori.  
- **ori-lang** may keep a copy or submodule for integration; **canonical framework source is this repo**.

## License

Same spirit as Ori (see package headers / upstream ori-lang).
