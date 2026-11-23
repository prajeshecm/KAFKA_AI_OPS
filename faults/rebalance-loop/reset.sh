#!/usr/bin/env bash
# Restore the last committed (good) consumer config from Git
set -euo pipefail
git checkout -- platform/apps/consumer/src/main/resources/application.properties
echo "Reset. Restart the consumer."