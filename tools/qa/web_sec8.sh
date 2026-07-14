#!/usr/bin/env sh
# SEC8 golden suite (no network).
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/../.." && pwd)
ORI_BIN="${ORI_BIN:-ori}"

if [ -d "$repo/demos/sec8_tests" ]; then
  cd "$repo/demos/sec8_tests"
elif [ -d "$repo/packages/ori-web/examples/sec8_tests" ]; then
  cd "$repo/packages/ori-web/examples/sec8_tests"
else
  echo "sec8_tests not found" >&2
  exit 1
fi

rm -rf "${HOME}/.ori/packages/web" 2>/dev/null || true
echo "== web_sec8: $ORI_BIN run main.orl =="
out=$("$ORI_BIN" run main.orl 2>&1) || {
  echo "$out" >&2
  echo "web_sec8: FAIL (run error)" >&2
  exit 1
}
echo "$out"
echo "$out" | grep -q "SEC8 ALL PASSED" || {
  echo "web_sec8: FAIL (missing SEC8 ALL PASSED)" >&2
  exit 1
}
echo "web_sec8: OK"
