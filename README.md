# Tempo

Distributed tracing backend: applications push OpenTelemetry spans to Tempo; Grafana queries them with TraceQL. Part of the observability tier next to [infra-prometheus](https://github.com/sca-templates/infra-prometheus) (metrics) and [infra-loki](https://github.com/sca-templates/infra-loki) (logs).

> **Status: local dev stack.** Production is declared in [infra-kubernetes](https://github.com/sca-templates/infra-kubernetes).

## Stack

| Container | Image | Host port | Purpose |
| --- | --- | --- | --- |
| tempo | `grafana/tempo:2.6.1` | 3200 API, 4317 OTLP gRPC, 4318 OTLP HTTP | Single-binary trace store |

Host network mode (telemetry-tier convention): binds `0.0.0.0` so both host-net and bridge siblings can push traces. No credentials — a stateless telemetry store holds nothing secret locally.

## Quick start

```sh
make all        # setup + up + validate
```

```sh
curl -s http://127.0.0.1:3200/ready          # → ready
curl -s 'http://127.0.0.1:3200/api/search?q={}'   # → JSON search result
```

Push a trace from any app via the standard OTLP endpoints (`:4317` gRPC / `:4318` HTTP); query it in [infra-grafana](https://github.com/sca-templates/infra-grafana) — datasource uid **`tempo`**, URL `http://localhost:3200`. The provisioning contract lives in [`tempo/datasource-provisioning.yaml`](tempo/datasource-provisioning.yaml).

## Commands

`make help`

| Target | Description |
| --- | --- |
| `make setup` | Create `.env` from example (no secrets needed) |
| `make all` | `setup` + `up` + `validate` |
| `make up` / `make down` | Start / stop and remove |
| `make validate` | Readiness, search API, OTLP ports |
| `make restart` / `stop` | Restart / stop without removing |
| `make logs` / `ps` / `clean` | Logs, status, cleanup (+ volume) |

## Configuration model

- [`tempo/tempo.yml`](tempo/tempo.yml) — single-binary dev config: local filesystem storage, **OTLP-only ingest**, 24h block retention.
- Standard ports declared once here: `3200`, `4317`, `4318`.
- Production uses object storage and is rendered by infra-kubernetes.

## Validation & CI

- `make validate`: container health, `/ready`, `/api/search`, OTLP ports listening.
- CI (`.github/workflows/validate.yml`): compose config, config sanity checks (OTLP-only, retention), `.env.example` completeness, markdownlint + link check.

## Troubleshooting

- **Container unhealthy**: check `docker logs tempo`; most often a bad `tempo.yml` or a leftover incompatible volume after an upgrade — `make clean && make up`.
- **Traces not appearing**: confirm the app targets `:4317/:4318` on the host and that batch size/interval isn't delaying export; search `{ service.name="<app>" }` in Grafana.
- **Disk growth**: dev retention is 24h; lower `block_retention` in `tempo.yml` if needed.

## Connections

- [infra-loki](https://github.com/sca-templates/infra-loki) — logs correlated with traces (same telemetry tier).
- [infra-prometheus](https://github.com/sca-templates/infra-prometheus) — metrics side of the triad.
- [infra-grafana](https://github.com/sca-templates/infra-grafana) — TraceQL UI; consumes this stack as datasource uid `tempo`.
- [infra-keycloak](https://github.com/sca-templates/infra-keycloak) / [infra-kong](https://github.com/sca-templates/infra-kong) — first instrumented edge path (login → gateway → services).
- [infra-kubernetes](https://github.com/sca-templates/infra-kubernetes) — declares the production backend.

## License

MIT — see [LICENSE](LICENSE).
