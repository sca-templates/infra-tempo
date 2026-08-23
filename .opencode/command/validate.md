---
description: Run the full Tempo validation suite (readiness, search API, OTLP ports).
agent: build
---

# Validate

Run `make validate` from the repo root and report the result.
`validate.sh` checks container health, the `/ready` endpoint, the TraceQL
search API and that both OTLP receivers are listening. If a check fails,
isolate it with the individual curls in the `tempo-lifecycle` skill and fix
it, then re-run.
