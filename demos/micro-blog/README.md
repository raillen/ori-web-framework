# micro-blog

Capability demo for **ori-web-framework**:

| Capability | Implementation |
|------------|----------------|
| Auth | Register / login / logout · **argon2** (`ori.crypto`) · session regenerate |
| Sessions | **SQLite** via `web_session_sqlite` (fallback: file) |
| Data | **SQLite** users + posts (prepared statements only) |
| Markdown | Safe subset renderer (HTML-escaped; no raw user HTML) |
| Editor | Simple Markdown toolbar (`public/md-editor.js`, no CDN) |
| Security | CSRF, rate limit, login lockout, CSP, audit log, ownership checks |

## Run

```bash
# from monorepo root — need ori-sqlite native libs
ln -sfn "$HOME/Documentos/Projetos/ori-sqlite" packages/ori-sqlite   # if missing
( cd packages/ori-sqlite && ./tools/build_linux.sh )               # if needed

cd demos/micro-blog
ori get .

# Prefer AOT when using ori-sqlite staticlibs (JIT needs .so cdylib):
ORI_USE_AOT=1 ori run main.orl
# or:
ori compile main.orl -o micro-blog && ./micro-blog

# http://127.0.0.1:3470/
```


Env:

| Variable | Default | Role |
|----------|---------|------|
| `PORT` / `ORI_HOST` | `3470` / `127.0.0.1` | Listen |
| `MICROBLOG_DB` | `microblog.db` | App data |
| `MICROBLOG_SESSION_DB` | `microblog_sessions.db` | Sessions |
| `ORI_ENV` | — | Set `production` + strong `ORI_WEB_SECRET` when deploying |

### Demo login (seeded on boot)

| Field | Value |
|-------|--------|
| **Username** | `test` |
| **Password** | `password123` |

Shown on the login page. Created automatically if missing (`store.ensure_demo_user`).

## Fly.io

```bash
cd demos/micro-blog
ori compile main.orl -o micro-blog   # AOT; needs sqlite static libs
# first time: create volume in the same region as fly.toml (gru)
fly volumes create microblog_data --region gru --size 1 -a ori-micro-blog
fly apps create ori-micro-blog   # if needed
fly deploy --ha=false -a ori-micro-blog
fly secrets set ORI_WEB_SECRET="$(openssl rand -hex 32)" -a ori-micro-blog
```

SQLite lives on the volume at `/data/*.db`.

## Security notes

- Passwords: `crypto.hash_password` / `verify_password` (argon2id).
- SQL: prepared binds for all user-controlled values.
- Markdown → HTML: escape first; only emit known tags; links limited to `http(s):` or `/`.
- Templates escape by default; `raw` only for server-built HTML (escaped pieces or MD renderer).
- Mutations require CSRF; session id rotated on login/register/logout.
- Post edit/delete only for `user_id` owner.

## Markdown subset

`#` / `##` / `###`, paragraphs, `-` lists, `**bold**`, `*italic*`, `` `code` ``, fenced ` ``` `, `[text](https://url)`.

## Not included (by design)

- TOTP 2FA (see `demos/ori-web-demo-auth`)
- Full CommonMark / HTML paste
- Multi-machine SQLite HA (single process + local files)
