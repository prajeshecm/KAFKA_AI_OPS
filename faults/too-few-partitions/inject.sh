#!/usr/bin/env bash
# Fault: too few partitions.
# Move traffic to a new 1-partition topic and slow processing slightly.
# One consumer thread does all the work; the other two sit idle.
set -euo pipefail
PRODUCER="platform/apps/producer/src/main/resources/application.properties"
CONSUMER="platform/apps/consumer/src/main/resources/application.properties"

# set_prop FILE KEY VALUE: replace the value, or add the line if missing
set_prop() {
  if grep -q "^$2=" "$1"; then
    sed -i.bak "s|^$2=.*|$2=$3|" "$1"
  else
    echo "$2=$3" >> "$1"
  fi
  rm -f "$1.bak"
}

set_prop "$PRODUCER" app.topic orders-1p
set_prop "$PRODUCER" app.topic-partitions 1   # the bad value the agent should fix
set_prop "$CONSUMER" app.topic orders-1p
set_prop "$CONSUMER" app.processing-delay-ms 100   # 10 msgs/s per thread

echo "Too-few-partitions injected. Restart producer and consumer, then send orders."
