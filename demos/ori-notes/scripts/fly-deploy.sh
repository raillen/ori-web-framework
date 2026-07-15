#!/usr/bin/env bash
# Compile + deploy ori-notes to Fly with sanity checks.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v fly >/dev/null 2>&1 && ! command -v flyctl >/dev/null 2>&1; then
  echo "error: install flyctl and ensure 'fly' is on PATH" >&2
  exit 1
fi
FLY="$(command -v fly || command -v flyctl)"

ORI_BIN="${ORI_BIN:-ori}"
echo "== compile Linux binary =="
"$ORI_BIN" compile main.orl -o ori-notes
test -x ./ori-notes
echo "binary: $(file ori-notes | head -1)"

echo "== local smoke PORT=18080 =="
ORI_HOST=127.0.0.1 PORT=18080 ./ori-notes >/tmp/ori-notes-fly-smoke.log 2>&1 &
PID=$!
cleanup() { kill "$PID" 2>/dev/null || true; }
trap cleanup EXIT
for i in $(seq 1 30); do
  if curl -sf "http://127.0.0.1:18080/healthz" | grep -q ok; then
    echo "healthz ok"
    break
  fi
  sleep 0.2
done
curl -sf "http://127.0.0.1:18080/healthz" | grep -q ok
cleanup
trap - EXIT

echo "== fly deploy (1 machine recommended) =="
"$FLY" deploy -a ori-notes --ha=false
echo "tip: fly secrets set ORI_WEB_SECRET=\$(openssl rand -hex 32) -a ori-notes"
echo "tip: fly scale count 1 -a ori-notes"
echo "tip: fly logs -a ori-notes"
