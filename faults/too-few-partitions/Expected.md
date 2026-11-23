# Too few partitions

Root cause: topic orders-1p has 1 partition, so only 1 of the 3 consumer
threads in orders-consumer gets work; throughput is capped at one thread.

Evidence:
- All lag sits on a single partition
- --members shows 3 members, 2 with 0 partitions
- Consumer is healthy: no errors, no rebalances

Fix: raise app.topic-partitions (e.g. 1 -> 3); KafkaAdmin adds partitions on restart.
Caveat: adding partitions changes which partition each key maps to, so ordering
for keys in flight can break briefly. Partitions can never be removed.