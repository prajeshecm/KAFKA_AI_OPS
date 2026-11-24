#!/usr/bin/env bash
# Fault: rebalance loop.
# Each batch takes longer than max.poll.interval.ms,
# so Kafka keeps removing the consumer from the group.
set -euo pipefail
PROPS="platform/apps/consumer/src/main/resources/application.properties"

# Set key=value in the file; add the line if it isn't there yet
set_prop() {
  if grep -q "^$1=" "$PROPS"; then
    sed -i.bak "s|^$1=.*|$1=$2|" "$PROPS"   # -i.bak works on macOS and Linux
  else
    echo "$1=$2" >> "$PROPS"
  fi
}

set_prop app.processing-delay-ms 2000                                # 2 s per record
set_prop spring.kafka.consumer.max-poll-records 10                   # 10 records per batch = 20 s of work
set_prop spring.kafka.consumer.properties.max.poll.interval.ms 10000 # but only 10 s allowed
rm -f "$PROPS.bak"

echo "Rebalance loop injected. Restart the consumer, then send orders."
