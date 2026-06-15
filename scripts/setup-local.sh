#!/usr/bin/env bash
set -euo pipefail

DOMAIN="hestia.local"
HOSTS_MARKER="# Hestia dashboard"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! grep -q "$DOMAIN" /etc/hosts; then
  echo "Adding $DOMAIN to /etc/hosts (requires sudo)..."
  sudo tee -a /etc/hosts > /dev/null <<EOF

$HOSTS_MARKER
::1 $DOMAIN
127.0.0.1 $DOMAIN
EOF
  echo "Added $DOMAIN"
else
  echo "$DOMAIN already present in /etc/hosts"
fi

cd "$REPO_DIR"
docker compose up -d --build

echo
echo "Hestia is running at: http://${DOMAIN}:8080"
echo
echo "Auto-start: this container uses restart: unless-stopped."
echo "Also enable Docker Desktop → Settings → General →"
echo "\"Start Docker Desktop when you sign in to your computer\"."
