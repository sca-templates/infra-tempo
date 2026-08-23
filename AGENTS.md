# tempo — Distributed tracing backend

## What this repo is

Distributed tracing backend: applications push OpenTelemetry spans to Tempo; Grafana queries them with TraceQL. Part of the observability tier next to [infra-prometheus](https://github.com/sca-templates/infra-prometheus) (metrics) and [infra-loki](https://github.com/sca-templates/infra-loki) (logs). **Local dev stack** — production is declared in [infra-kubernetes](https://github.com/sca-templates/infra-kubernetes).

## Skills

| Skill | Use for |
| --- | --- |
| [`tempo-lifecycle`](.claude/skills/tempo-lifecycle/SKILL.md) | up/down/restart, OTLP ingest checks, TraceQL/search API, unhealthy container |

## Reference

> Reference: <https://github.com/sca-templates/sca-docs>

Ecosystem conventions and infrastructure notes live there; consult them
before documenting or touching topology/ports/networks:

- `00-ecosystem/conventions.md` — repo layout, ports, naming, commit style.
- `04-infrastructure/tempo.md` — canonical note for this component.

Keep the vault in sync when this repo changes.

## Commands

```sh
make help        # all targets
make all         # setup + up + validate
make validate    # readiness, search API, OTLP ports
```

## Conventions (strict)

- English only.
- Conventional commits (`feat(tempo): ...`, `fix(scripts): ...`, `docs(readme): ...`).
- Docs-as-code: every change through PR + review.
- Never commit `.env`, `.secrets/` or any secret material (this stack needs none locally).
- Config is the SSOT: edit `tempo/tempo.yml`, restart to apply.
- Run `make validate` before finishing changes that affect the stack.
