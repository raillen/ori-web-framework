# Landing page (Svelte + Ori)

Marketing-style demo:

| Layer | Tech |
|-------|------|
| UI | **Svelte 5** + Vite (`frontend/`) |
| Server | **`ori-web`** — static `public/` + `/api/*` |
| Deploy | Fly.io (`Dockerfile` + `fly.toml`) |

Not using `ori-templates` here (see `demos/ori-notes` for that). This shows a modern SPA served by Ori.

## Local development

### Option A — full stack (recommended)

```bash
# terminal 1 — build once, then run Ori
cd demos/landing-page/frontend
npm install
npm run build

cd ..
ori run main.orl
# → http://127.0.0.1:3461/
```

### Option B — Vite HMR + Ori API

```bash
# terminal 1
cd demos/landing-page && ORI_HOST=127.0.0.1 ori run main.orl

# terminal 2
cd demos/landing-page/frontend && npm install && npm run dev
# → http://127.0.0.1:5173/  (proxies /api → :3461)
```

## API (Ori)

| Route | Role |
|-------|------|
| `GET /api/health` · `GET /healthz` | Health |
| `GET /api/csrf` | CSRF token (cookie session) |
| `POST /api/contact` | Form (urlencoded + `X-CSRF-Token`) |
| `GET /api/stats` | In-process message counter |

## Deploy on Fly.io

```bash
cd demos/landing-page/frontend && npm ci && npm run build
cd ..
ori compile main.orl -o landing-page   # Linux binary for Fly
fly launch --no-deploy                 # first time
fly deploy
```

Set a production session secret:

```bash
fly secrets set ORI_WEB_SECRET="$(openssl rand -hex 32)"
```

## Env

| Variable | Default | Role |
|----------|---------|------|
| `PORT` | `3461` | Listen port (Fly sets `8080`) |
| `ORI_HOST` | `0.0.0.0` | Bind address |
| `ORI_WEB_SECRET` | dev default | Session signing |
