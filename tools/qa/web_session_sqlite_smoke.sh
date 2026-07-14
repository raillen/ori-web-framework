#!/usr/bin/env sh
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/../.." && pwd)
ORI_BIN="${ORI_BIN:-ori}"
export ORI_USE_SYSTEM_LINKER="${ORI_USE_SYSTEM_LINKER:-1}"
export ORI_USE_AOT=1

if [ -n "${ORI_SQLITE_ROOT:-}" ]; then
  SQLITE_ROOT="$ORI_SQLITE_ROOT"
elif [ -d "$repo/packages/ori-sqlite" ]; then
  SQLITE_ROOT="$repo/packages/ori-sqlite"
else
  SQLITE_ROOT="${HOME}/Documentos/Projetos/ori-sqlite"
fi
if [ ! -e "$repo/packages/ori-sqlite" ] && [ -d "$SQLITE_ROOT" ]; then
  ln -sfn "$SQLITE_ROOT" "$repo/packages/ori-sqlite"
fi
if [ ! -f "$SQLITE_ROOT/lib/x86_64-unknown-linux-gnu/libsqlite3.a" ]; then
  if [ -x "$SQLITE_ROOT/tools/build_linux.sh" ]; then
    "$SQLITE_ROOT/tools/build_linux.sh"
  else
    echo "web_session_sqlite_smoke: SKIP (no ori-sqlite at $SQLITE_ROOT)" >&2
    exit 0
  fi
fi

cd "$repo/packages/ori-web-session-sqlite/examples/smoke"
rm -rf "${HOME}/.ori/packages/web" "${HOME}/.ori/packages/web_session_sqlite" "${HOME}/.ori/packages/sqlite" 2>/dev/null || true
echo "== web_session_sqlite_smoke: $ORI_BIN run main.orl (AOT) =="
out=$("$ORI_BIN" run main.orl 2>&1) || {
  echo "$out" >&2
  exit 1
}
echo "$out"
echo "$out" | grep -q "SQLITE_SESSION SMOKE PASSED" || exit 1
echo "web_session_sqlite_smoke: OK"
