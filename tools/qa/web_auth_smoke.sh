#!/usr/bin/env sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/../.." && pwd)
ORI_BIN="${ORI_BIN:-ori}"

cd "$repo/packages/ori-web-auth/examples/smoke"
rm -rf "${HOME}/.ori/packages/web" "${HOME}/.ori/packages/web_auth" 2>/dev/null || true
echo "== web_auth_smoke: $ORI_BIN run main.orl =="
out=$("$ORI_BIN" run main.orl 2>&1) || {
  echo "$out" >&2
  exit 1
}
echo "$out"
echo "$out" | grep -q "WEB_AUTH SMOKE PASSED" || exit 1
echo "web_auth_smoke: OK"
