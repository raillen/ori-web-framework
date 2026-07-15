# P0 residuals (Lantern)

Tracked after 2026-07-15 P0 pass.

| Item | Status | Notes |
|------|--------|--------|
| Content-Length UTF-8 bytes | **Fixed + tested** | `web` `format_response`; `tools/qa/content_length_utf8.sh` |
| Demo `ori check` smoke | **Gated** | `tools/qa/demo_smoke.sh` + CI |
| SEC8 | **Existing** | `tools/qa/web_sec8.sh` |
| JIT + `ori-sqlite` `.so` | **Partial** | `.so` built by `ori-sqlite/tools/build_linux.sh`; `ori run` may still SIGSEGV after load — prefer AOT for production demos until fixed |
| CI Ori install on GHA | **Fragile** | Workflow expects `ori` on runner; pin a release binary when available |
| Brand | **Done** | Product **Lantern** + tagline in README / BRAND.md |

## JIT sqlite residual

Symptoms: process loads `libori_sqlite_shim.so` + `libsqlite3.so` then exits (often code 139) with empty stderr.

Workaround:

```bash
ORI_USE_AOT=1 ori run main.orl
# or ori compile && ./binary
```

Next investigation: double-load of `native_libs`, rpath, or Cranelift symbol resolve after `dlopen`.
