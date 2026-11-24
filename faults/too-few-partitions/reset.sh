#!/usr/bin/env bash
set -euo pipefail
git checkout -- platform/apps/producer/src/main/resources/application.properties \
                platform/apps/consumer/src/main/resources/application.properties
echo "Reset. Restart producer and consumer."
