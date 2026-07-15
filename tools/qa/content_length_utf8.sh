#!/usr/bin/env sh
# P0: Content-Length must use UTF-8 byte length, not Unicode scalar count.
# Serves a static file with multi-byte characters and compares wire size to disk.
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/../.." && pwd)
ORI_BIN="${ORI_BIN:-ori}"
PORT="${CONTENT_LENGTH_TEST_PORT:-18765}"
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"; kill "$SRV_PID" 2>/dev/null || true' EXIT

mkdir -p "$WORKDIR/public"
# Multi-byte UTF-8 payload so Content-Length (bytes) ≠ scalar count.
python3 -c "
from pathlib import Path
p = Path(r'$WORKDIR') / 'public' / 'sample.js'
text = '/* — · → … ◎ multi-byte */\n' + ('x' * 100) + '\n'
p.write_text(text, encoding='utf-8')
print(p.stat().st_size)
" > "$WORKDIR/size.txt"
DISK=$(cat "$WORKDIR/size.txt")

cat > "$WORKDIR/main.orl" <<'ORL'
module app.main
import web = web
import ori.io = io
import ori.os = os
import ori.convert = conv

health(_req: web.Request) -> web.ActionResult
    return ok(web.text(200, "ok"))
end

main()
    var a: web.App = web.app()
    web.static(a, "/", "public")
    web.get(a, "/healthz", health)
    const port: int = conv.parse_int_or(os.env_or("PORT", "18765"), 18765)
    match web.serve("127.0.0.1", port, a)
    case ok(_):
    case err(e):
        io.println(e)
    end
end
ORL

cat > "$WORKDIR/ori.proj" <<EOF
manifest = 1
name = "content_length_utf8_smoke"
version = "0.1.0"
kind = "app"
entry = "main.orl"
[source]
root_namespace = "app"
[dependencies]
web = { path = "$repo/packages/ori-web", version = "0.1.0" }
EOF

cd "$WORKDIR"
rm -rf "${HOME}/.ori/packages/web" 2>/dev/null || true
echo "== content_length_utf8: start server PORT=$PORT =="
PORT="$PORT" ORI_HOST=127.0.0.1 "$ORI_BIN" run main.orl >/tmp/cl-utf8-srv.log 2>&1 &
SRV_PID=$!
i=0
while [ "$i" -lt 40 ]; do
  if curl -sf "http://127.0.0.1:$PORT/healthz" >/dev/null 2>&1; then
    break
  fi
  i=$((i + 1))
  sleep 0.25
done
if ! curl -sf "http://127.0.0.1:$PORT/healthz" >/dev/null 2>&1; then
  echo "content_length_utf8: FAIL (server did not start)" >&2
  cat /tmp/cl-utf8-srv.log >&2 || true
  exit 1
fi

WIRE=$(curl -sS "http://127.0.0.1:$PORT/sample.js" | wc -c | tr -d ' ')
HDR=$(curl -sSI "http://127.0.0.1:$PORT/sample.js" | tr -d '\r' | awk -F': ' 'tolower($1)=="content-length"{print $2; exit}')
echo "disk=$DISK wire=$WIRE content-length=$HDR"

if [ "$WIRE" != "$DISK" ]; then
  echo "content_length_utf8: FAIL (wire body size != disk)" >&2
  exit 1
fi
if [ -n "$HDR" ] && [ "$HDR" != "$DISK" ]; then
  echo "content_length_utf8: FAIL (Content-Length header != disk bytes)" >&2
  exit 1
fi

# scalar count must be strictly less than bytes for our multi-byte payload
SCALARS=$(python3 -c "print(len(open('$WORKDIR/public/sample.js',encoding='utf-8').read()))")
if [ "$SCALARS" -ge "$DISK" ]; then
  echo "content_length_utf8: FAIL (test payload has no multi-byte chars? scalars=$SCALARS disk=$DISK)" >&2
  exit 1
fi
if [ -n "$HDR" ] && [ "$HDR" = "$SCALARS" ]; then
  echo "content_length_utf8: FAIL (Content-Length equals scalar count — old bug)" >&2
  exit 1
fi

echo "content_length_utf8: OK"
