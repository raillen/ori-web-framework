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

The Docker image **does not compile Ori**. Build the binary on the host, then deploy.

### Health-check timeouts (fixed config)

If deploy fails with `timeout reached waiting for health checks`:

1. App must listen on **`0.0.0.0:$PORT`** (this demo does; Fly sets `PORT=8080`).
2. **`/healthz`** must return 200 quickly — registered first in `main`.
3. Use the current `fly.toml`: **512MB RAM**, **grace_period 60s**, check timeout 5s.
4. Prefer **one machine**: `fly deploy --ha=false` then `fly scale count 1`.
5. Confirm binary runs locally: `PORT=18080 ORI_HOST=127.0.0.1 ./ori-notes` + `curl localhost:18080/healthz`.

### Deploy steps

```bash
cd demos/ori-notes
# recommended helper (compile + local health smoke + deploy):
./scripts/fly-deploy.sh

# or manually:
ori compile main.orl -o ori-notes
fly deploy --ha=false
fly secrets set ORI_WEB_SECRET="$(openssl rand -hex 32)"
fly logs
```

If you see `"/ori-notes": not found` in Docker build: binary missing from context
(`.dockerignore` must **not** exclude `ori-notes`).

### `GLIBC_2.39 not found` (process exits code 1)

Your host linked the binary against a **newer glibc** than `debian:bookworm`.
This demo’s Dockerfile uses **`ubuntu:24.04`** so GLIBC matches typical Ubuntu 24 hosts.

```text
# Fly log symptom:
/app/ori-notes: version `GLIBC_2.39' not found (required by /app/ori-notes)
# Proxy then: PR04 could not find a good candidate…  (no healthy machine)
```

Redeploy after pulling the Ubuntu base image.

### Env

| Variable | Default | Role |
|----------|---------|------|
| `PORT` | `3460` | Listen port (Fly sets this) |
| `ORI_HOST` | `0.0.0.0` | Bind address |
| `ORI_WEB_SECRET` | (dev default) | Session signing in production — set a long secret on Fly |
