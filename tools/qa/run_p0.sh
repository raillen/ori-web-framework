#!/usr/bin/env sh
# Run Lantern P0 quality gate locally (mirrors CI).
set -eu
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
export ORI_BIN="${ORI_BIN:-ori}"

"$script_dir/web_sec8.sh"
"$script_dir/content_length_utf8.sh"
"$script_dir/demo_smoke.sh"

echo "run_p0: ALL OK"
