# Official UI presets (optional)

The core stack is **HTML-first** (`ori-web` + `ori-templates`).  
These presets **never** become required dependencies of `ori-web`.

## Preferred defaults

| Preset | Best with | Role |
|--------|-----------|------|
| **htmx** | templates | Progressive enhancement |
| **svelte** | static `public/` + API | Official SPA path (also demos/landing-page) |
| **vue** | same | Official SPA path |
| **solid** | same | Official SPA path |
| **none** | templates only | Zero Node |

Any other frontend (React, vanilla, …) works: build into `public/`, mount with `web.static`.

## Create an app with a preset

```bash
./tools/ori-web new app --ui=htmx
./tools/ori-web new app --template=landing --ui=svelte
```

SPA presets copy files into `frontend/`:

```bash
cd frontend && npm install && npm run build   # → public/
ori run main.orl
```

## CSP

- SSR/htmx demos may allow `https://unpkg.com` for htmx CDN.
- Production SPAs: serve JS from `'self'` only after Vite build.

## Design rule

```text
Core runtime: no Node
Scaffold: may generate frontend/
Docs: show preferred stacks first, document escape hatch second
```
