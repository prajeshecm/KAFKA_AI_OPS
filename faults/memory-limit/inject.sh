#!/usr/bin/env bash
# Fault: container memory limit too small for the JVM.
# The heap claims 90% of a 160 MB limit at startup (AlwaysPreTouch),
# leaving no room for metaspace, threads and buffers, so the kernel kills it.
set -euo pipefail
COMPOSE="docker-compose.yml"

sed -i.bak \
  -e 's|^\([[:space:]]*mem_limit:\).*# fault:consumer-mem$|\1 160m        # fault:consumer-mem|' \
  -e 's|^\([[:space:]]*memswap_limit:\).*# fault:consumer-mem$|\1 160m    # fault:consumer-mem|' \
  -e 's|^\([[:space:]]*JAVA_TOOL_OPTIONS:\).*# fault:consumer-heap$|\1 "-XX:MaxRAMPercentage=90 -XX:InitialRAMPercentage=90 -XX:+AlwaysPreTouch"   # fault:consumer-heap|' \
  "$COMPOSE"
rm -f "$COMPOSE.bak"

docker compose config -q        # stop here if the YAML is broken
docker compose up -d consumer   # recreate the container with the new limits
echo "Memory-limit fault injected."
