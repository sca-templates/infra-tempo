---
name: tempo-lifecycle
description: Start, stop and troubleshoot the Tempo tracing backend. Use when the user asks to make up/down/stop/restart, check OTLP ingest or TraceQL queries, or fix an unhealthy Tempo container.
---

# Tempo lifecycle

- `make up` — start Tempo
- `make all` — `setup` + `up` + `validate`
- `make validate` — readiness, search API, OTLP ports
- `make down` — stop and remove containers
- `make stop` / `make restart` — stop without removing / down + up
- `make ps` — container status
- `make logs` — follow logs
- `make clean` — `down -v` + remove `.env`

## Health checks

- `curl http://127.0.0.1:3200/ready` — must print `ready`
- `curl -s 'http://127.0.0.1:3200/api/search?q={}'` — search API alive
- `nc -z 127.0.0.1 4317 && nc -z 127.0.0.1 4318` — OTLP receivers listening
- `make ps` — container must be `healthy`

## Troubleshooting

- Unhealthy after upgrade: incompatible local blocks volume — `make clean &&
  make up` (dev data is disposable).
- Traces not showing in Grafana: verify the datasource uid is `tempo` and URL
  `http://localhost:3200`; then check the app exports to `:4317/:4318`.
- Disk filling: dev retention is 24h (`block_retention` in tempo/tempo.yml).
- Config edits not applying: restart the container — config loads at start.
