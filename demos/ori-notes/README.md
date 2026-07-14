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

The Docker image **does not compile Ori**. You build the binary on the host,
then `fly deploy` packages it with `views/` and `public/`.

1. Install [flyctl](https://fly.io/docs/hands-on/install-flyctl/) and `fly auth login`.
2. From **this directory**, compile a **Linux x86_64** binary (name must match Dockerfile):

```bash
cd demos/ori-notes
ori compile main.orl -o ori-notes
ls -la ori-notes   # must exist and be executable (~10MB)
```

3. Deploy (do **not** list `ori-notes` in `.dockerignore` — that was a trap):

```bash
fly launch --no-deploy   # first time only
fly deploy
```

If you see `"/ori-notes": not found` in the build, the binary is missing from
the Docker context: re-run step 2 and check `.dockerignore` does not ignore it.

4. Optional production secret:

```bash
fly secrets set ORI_WEB_SECRET="$(openssl rand -hex 32)"
```

### Env

| Variable | Default | Role |
|----------|---------|------|
| `PORT` | `3460` | Listen port (Fly sets this) |
| `ORI_HOST` | `0.0.0.0` | Bind address |
| `ORI_WEB_SECRET` | (dev default) | Session signing in production — set a long secret on Fly |
