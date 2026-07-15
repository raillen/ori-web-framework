#!/bin/sh
set -eu
mkdir -p /data
chown -R ori:ori /data 2>/dev/null || true
# drop to non-root for the app process
exec setpriv --reuid=10001 --regid=10001 --init-groups -- /app/micro-blog
