#!/usr/bin/env sh
# P0: ori check on key demos + optional AOT hello/notes compile.
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/../.." && pwd)
ORI_BIN="${ORI_BIN:-ori}"
fail=0

check_demo() {
  name=$1
  dir="$repo/demos/$name"
  if [ ! -d "$dir" ]; then
    echo "demo_smoke: skip missing $name"
    return 0
  fi
  echo "== demo_smoke: check $name =="
  (
    cd "$dir"
    rm -rf "${HOME}/.ori/packages/web" "${HOME}/.ori/packages/templates" 2>/dev/null || true
    if ! "$ORI_BIN" check main.orl; then
      echo "demo_smoke: FAIL check $name" >&2
      exit 1
    fi
  ) || fail=1
}

check_demo hello_server
check_demo ori-notes
check_demo sec8_tests
check_demo micro-blog
check_demo landing-page

# Lightweight AOT compile for notes (no long server)
if [ -d "$repo/demos/ori-notes" ]; then
  echo "== demo_smoke: compile ori-notes =="
  (
    cd "$repo/demos/ori-notes"
    rm -f /tmp/ori-notes-ci-bin
    if ! "$ORI_BIN" compile main.orl -o /tmp/ori-notes-ci-bin; then
      echo "demo_smoke: FAIL compile ori-notes" >&2
      exit 1
    fi
    test -x /tmp/ori-notes-ci-bin
    rm -f /tmp/ori-notes-ci-bin
  ) || fail=1
fi

if [ "$fail" -ne 0 ]; then
  echo "demo_smoke: FAIL" >&2
  exit 1
fi
echo "demo_smoke: OK"
