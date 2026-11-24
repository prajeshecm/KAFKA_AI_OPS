# Rebalance loop

Root cause: batch processing time (10 records x 2 s = 20 s) exceeds
max.poll.interval.ms (10 s), so the consumer is repeatedly removed from the group.

Evidence:
- Lag climbs while the consumer process is up
- Consumer IDs change between describe runs
- Committed offsets barely move
- Logs: poll timeout expired / commit failed / rejoining group

Fix: raise max.poll.interval.ms, or lower max-poll-records or processing time.
