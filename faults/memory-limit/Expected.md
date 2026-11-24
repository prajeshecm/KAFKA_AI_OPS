# Container memory limit too small

Root cause: consumer mem_limit is 160m and MaxRAMPercentage=90, so heap plus
non-heap memory (metaspace, thread stacks, code cache, direct buffers) exceeds
the limit and the kernel OOM-kills the JVM.

Evidence:
- Container exit code 137, docker inspect shows OOMKilled=true
- Restart count keeps rising (crash loop)
- Logs stop abruptly, with no Java OutOfMemoryError
- Lag climbs; consumer IDs change after each restart

Fix: raise mem_limit (e.g. 512m) and keep MaxRAMPercentage around 70-75.
