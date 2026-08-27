#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

export WP_ENV_PORT="${WP_ENV_PORT:-8888}"

is_wordpress_ready() {
  local status
  status="$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:${WP_ENV_PORT}/" || true)"
  [[ "$status" == "200" || "$status" == "302" ]]
}

if is_wordpress_ready; then
  echo "WordPress environment already running at http://localhost:${WP_ENV_PORT}/"
  exit 0
fi

npx wp-env start --runtime=playground

# Ensure Astra is active (wp-env Playground does not auto-activate mapped themes).
./.cursor/scripts/activate-astra.sh || true

for _ in $(seq 1 60); do
  if is_wordpress_ready; then
    echo "WordPress is ready at http://localhost:${WP_ENV_PORT}/"
    exit 0
  fi
  sleep 2
done

echo "WordPress did not become ready in time." >&2
exit 1
