# Ori Notes

Demo product: a small notes app rendered with **`ori-templates`** + **`ori-web`**.

- Server HTML (`.orix` layouts / partials)
- CSRF + memory sessions + flash
- Create / list / delete (in-memory; restarts clear data)
- Health: `GET /healthz`
- Fly-ready: binds `ORI_HOST` (default `0.0.0.0`) and `PORT` / `ORI_PORT` (default `3460`)

## Run locally

```bash
cd demos/ori-notes
ori run main.orl
# → http://127.0.0.1:3460/  (set PORT=3460 if needed; host is 0.0.0.0)
```

Or:

```bash
ORI_HOST=127.0.0.1 PORT=3460 ori run main.orl
```

## Deploy on Fly.io

1. Install [flyctl](https://fly.io/docs/hands-on/install-flyctl/) and `fly auth login`.
2. From this directory, build a **Linux** binary (on Linux host or CI):

```bash
ori compile main.orl -o ori-notes
```

3. Create / deploy:

```bash
fly launch --no-deploy   # first time: accept fly.toml, app name
fly deploy
```

`fly.toml` and `Dockerfile` expect the binary named `ori-notes` plus `views/` and `public/` copied into the image.

### Env

| Variable | Default | Role |
|----------|---------|------|
| `PORT` | `3460` | Listen port (Fly sets this) |
| `ORI_HOST` | `0.0.0.0` | Bind address |
| `ORI_WEB_SECRET` | (dev default) | Session signing in production — set a long secret on Fly |
