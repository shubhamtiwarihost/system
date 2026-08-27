#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

WP_DIR="$(find "${HOME}/.wp-env" -name WordPress -type d 2>/dev/null | head -1)"
if [ -z "$WP_DIR" ]; then
  echo "WordPress install directory not found; skipping Astra activation." >&2
  exit 0
fi

npx wp-playground-cli run-blueprint \
  --wordpress-install-mode install-from-existing-files \
  --mount-dir-before-install "$WP_DIR" /wordpress \
  --mount-dir "$ROOT_DIR" /wordpress/wp-content/themes/astra \
  --blueprint "$ROOT_DIR/.cursor/activate-astra.blueprint.json" \
  --verbosity quiet

echo "Astra theme activated."
