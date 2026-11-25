# Kafka AI Ops Copilot

An AI operations copilot for Apache Kafka. It watches a real Kafka cluster, notices problems, and (in later milestones) investigates and fixes them safely with a human approving every change.

![CI](https://github.com/prajeshecm/KAFKA_AI_OPS/actions/workflows/ci.yml/badge.svg)

## Status: MVP 0 complete — "it notices"

MVP 0 is the foundation the agents will run on: a local Kafka platform with real apps, real metrics, real alerts, and three reproducible faults.

## What's in the stack

| Part | What it does | Port |
| --- | --- | --- |
| Kafka 4.0 (KRaft, no ZooKeeper) | Message broker | 9092 |
| Producer (Spring Boot, Java 21) | POST /orders?count=N sends orders | 8081 |
| Consumer (Spring Boot, Java 21) | Group orders-consumer, runs in Docker with a 512 MB limit | 8082 |
| kafka-exporter | Exposes consumer lag and topic metrics | 9308 |
| Prometheus | Scrapes metrics, evaluates the ConsumerLagHigh rule | 9090 |
| Alertmanager | Groups and routes alerts to a webhook | 9093 |
| Grafana | Dashboards stored as code | 3000 |

## Quick start

Prerequisites: Docker Desktop, Java 21, Git.

    git clone https://github.com/prajeshecm/KAFKA_AI_OPS.git
    cd KAFKA_AI_OPS
    docker compose up -d        # start Kafka, apps and observability
    curl -X POST "localhost:8081/orders?count=500"   # send some traffic

Open Grafana at localhost:3000 and watch consumer lag.

## Demo: break it on purpose

Each fault lives in faults/<name>/ with inject.sh, reset.sh and EXPECTED.md.

| Fault | What you see | Signal |
| --- | --- | --- |
| Rebalance loop | Consumer keeps leaving and rejoining the group | Lag climbs, rebalance logs |
| Too few partitions | One partition caps throughput, extra consumers sit idle | Lag on orders-1p |
| Memory limit | Container crash loop | Exit 137, OOMKilled=true |

    ./faults/memory-limit/inject.sh   # break it
    # watch: ConsumerLagHigh fires in Prometheus, then reaches Alertmanager
    ./faults/memory-limit/reset.sh    # restore

## Engineering practices

- Pre-commit with 14 hooks: YAML and JSON checks, hadolint, shellcheck, promtool, amtool, gitleaks for secrets, google-java-format.
- GitHub Actions CI: pre-commit lint plus Maven verify for each app (matrix), least-privilege permissions, concurrency cancel.
- Branch protection on main: pull requests only, three required checks, no force pushes.
- Dependabot keeps Actions, Docker images and Maven dependencies current.

## Roadmap

| MVP | Goal |
| --- | --- |
| 0 | Notices: platform, metrics, alerts, faults (done) |
| 1 | Investigates read-only: one agent, MCP tools, consumer lag |
| 2 | Remembers and cites: hybrid RAG over runbooks and past incidents |
| 3 | Fixes safely: code checks, critic, human approval bound to the diff |
| 4 | Chat: Slack ChatOps |
| 5 | Trustworthy: policy engine, kill switch, shadow mode |
| 6 | Upgrades: rolling Kafka upgrade across three brokers |
| 7 | Voice: Twilio calls |
| 8 | Application agent and an AWS EC2 demo with Terraform |
