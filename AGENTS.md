# ori-web-framework — agent / contributor rules

Precedence: **this file** > global Grok skills for work in this repo.

## Required skills / contracts

| Skill / doc | Role |
|-------------|------|
| **clean-code** | Modular APIs, verb+domain names, Rule of Three, no utils dump |
| **living-docs** | Update README + `docs/` with behavior changes |
| `docs/CLEAN-CODE.md` | Style for framework + scaffolds |
| `docs/CLI.md` | `tools/ori-web` surface |
| `docs/UI-PRESETS.md` | Optional JS stacks |
| `docs/MIGRATIONS.md` | Future only — do not pretend migrate exists |

## Code rules

- Identifiers and code comments: **English**.
- Packages stay decoupled: no `web` → `web_app` cycle; templates owned carefully.
- Generators/skeletons must stay **readable teaching material**.
- Prefer path deps in monorepo; registry pins rewritten on OriLamp sync.

## Do not

- Add Node as a runtime dependency of `ori-web` / `ori-templates`.
- Force Svelte/Vue/Solid/HTMX in core.
- Implement full ORM here without a dedicated design.

## Demos / Fly

- `demos/ori-notes`: SSR templates product demo.
- `demos/landing-page`: Svelte + Ori API.
- Deploy: compile host binary, never ignore it in `.dockerignore`.
