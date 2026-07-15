# CLI — `tools/ori-web`

Unified developer entry for the framework (wrappers around `ori-web-app` generators + skeletons).

```bash
# from ori-web-framework root
./tools/ori-web help
./tools/ori-web new myapp
./tools/ori-web new notes --template=notes
./tools/ori-web new site --template=landing --ui=svelte ./apps/site
cd myapp && ../../tools/ori-web serve
./tools/ori-web generate scaffold posts   # from app root
./tools/ori-web ui list
```

## Commands

| Command | Role |
|---------|------|
| `new` | Scaffold app (`--template`, `--ui`) |
| `serve` | `ori run main.orl` with `PORT` / `ORI_HOST` |
| `generate` | controller · scaffold · model |
| `ui list` | Official optional UI presets |
| `help` | Usage |

## Templates

| Name | Stack |
|------|--------|
| `minimal` | web + templates + web_app (Rails-like tree) |
| `notes` | SSR notes (ori-templates) |
| `blog` | Home + posts list/show |
| `landing` | Marketing + contact form |

## Optional UI (`--ui`)

`none` (default) · `htmx` · `svelte` · `vue` · `solid` — see `docs/UI-PRESETS.md`.

## Not yet: migrations

```text
ori-web db migrate   # planned — docs/MIGRATIONS.md
```

Until then: apply SQL manually or boot-time `ori-sqlite` setup for demos.
