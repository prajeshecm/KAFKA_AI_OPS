#!/usr/bin/env bash
set -euo pipefail
git checkout -- docker-compose.yml
docker compose up -d consumer
echo "Reset."