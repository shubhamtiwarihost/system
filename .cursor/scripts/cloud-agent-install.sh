#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

THEME_VERSION="$(grep -m1 '^Version:' style.css | awk '{print $2}')"
THEME_SLUG="astra"
THEME_ZIP_URL="https://downloads.wordpress.org/theme/${THEME_SLUG}.${THEME_VERSION}.zip"

if [ ! -d "inc" ]; then
  echo "Theme source is incomplete; fetching Astra ${THEME_VERSION} from WordPress.org..."
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT

  curl -fsSL "$THEME_ZIP_URL" -o "$TMP_DIR/theme.zip"
  unzip -q "$TMP_DIR/theme.zip" -d "$TMP_DIR"

  # Overlay upstream files without overwriting tracked workspace changes.
  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$TMP_DIR/${THEME_SLUG}/" ./ --ignore-existing
  else
    cp -rn "$TMP_DIR/${THEME_SLUG}/." . 2>/dev/null || true
  fi

  echo "Theme files restored from upstream release."
fi

npm ci

echo "Install complete."
