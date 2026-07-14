#!/usr/bin/env sh
# Build ori-web-framework release tarball (libraries only).
# Usage: ./tools/package_release.sh [version]
# Example: ./tools/package_release.sh 0.1.0
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo=$(CDPATH= cd -- "$script_dir/.." && pwd)
version="${1:-}"
if [ -z "$version" ]; then
  if git -C "$repo" describe --tags --exact-match 2>/dev/null; then
    version=$(git -C "$repo" describe --tags --exact-match | sed 's/^v//')
  else
    version="0.1.0"
  fi
fi
version="${version#v}"

out_dir="${ORI_WEB_DIST:-$repo/dist}"
name="ori-web-framework-${version}"
stage="$out_dir/$name"
archive="$out_dir/${name}.tar.gz"

rm -rf "$stage"
mkdir -p "$stage/packages"

# Libraries only (not demos/tools build artifacts)
for p in ori-templates ori-web ori-web-app ori-web-auth ori-web-session-sqlite; do
  if [ -d "$repo/packages/$p" ]; then
    mkdir -p "$stage/packages/$p"
    rsync -a \
      --exclude '.sessions' \
      --exclude 'var' \
      --exclude 'audit.log' \
      --exclude '*.db' \
      "$repo/packages/$p/" "$stage/packages/$p/"
  fi
done

cp "$repo/README.md" "$stage/"
cp "$repo/FREEZE-WEB.md" "$stage/" 2>/dev/null || true
cp "$repo/CHANGELOG.md" "$stage/" 2>/dev/null || true
cp "$repo/ori-sqlite.README.md" "$stage/" 2>/dev/null || true
if [ -d "$repo/docs" ]; then
  rsync -a "$repo/docs/" "$stage/docs/"
fi

# Install hint
cat > "$stage/INSTALL.md" <<EOF
# Install ori-web-framework ${version}

## Prerequisites

- Ori language on PATH (recommended ≥ 0.3.5 with crypto + net timeouts)
- Optional SQLite sessions: see \`ori-sqlite.README.md\`

## Option A — path deps (this tarball)

\`\`\`bash
tar xzf ori-web-framework-${version}.tar.gz
cd your-app
\`\`\`

\`\`\`toml
# ori.proj
[dependencies]
web = { path = "../ori-web-framework-${version}/packages/ori-web", version = "0.1.0" }
templates = { path = "../ori-web-framework-${version}/packages/ori-templates", version = "0.1.0" }
\`\`\`

## Option B — git monorepo + path

\`\`\`bash
git clone --branch v${version} https://github.com/raillen/ori-web-framework.git
\`\`\`

Then path-depend \`…/ori-web-framework/packages/ori-web\` as above.

## Option C — Ori package manager (registry)

When packages are published to your registry:

\`\`\`bash
export ORI_REGISTRY=https://…   # or file:///path/to/registry
ori install web@0.1.0
ori install templates@0.1.0
\`\`\`

\`\`\`toml
[dependencies]
web = "0.1.0"
templates = "0.1.0"
\`\`\`

Git pin of a *single* package requires that package at the git root (or publish).
This monorepo is multi-package; use path, tarball, or registry per package.
EOF

mkdir -p "$out_dir"
tar -C "$out_dir" -czf "$archive" "$name"
echo "wrote $archive"
ls -lh "$archive"
# checksum
if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "$archive" | tee "$archive.sha256"
fi
