# Contributing to infra-tempo

> Distributed tracing backend — OTLP ingest only, TraceQL queries from Grafana. Docs-as-code: all changes land through a PR with review.

## Ground rules

- **English only** — notes, commits, and PR descriptions are written in English.
- **No secrets in the repo** — this stack needs none locally; `.env` is gitignored anyway. Never commit tokens or passwords.
- **Docs-as-code** — every change goes through a pull request and is reviewed.

## Repository layout

```text
compose.yml                          Tempo single binary (host network)
tempo/tempo.yml                      Dev config: OTLP receivers, local storage, retention
tempo/datasource-provisioning.yaml   Grafana datasource contract (reference copy)
Makefile                             help | setup | up | all | validate | down | stop | restart | logs | ps | clean
scripts/validate.sh                  Readiness + search API + OTLP ports
.env.example                         Non-secret defaults
.github/                             CI, PR template, dependabot, markdown link-check config
```

## Changing the backend

1. Edit `tempo/tempo.yml` — ports and behavior live here once.
2. `make restart` to apply.
3. Run `make validate`.
4. Update the README "Configuration model" section if invariants change; production config lives in `infra-kubernetes`.

## Contribution flow

1. Branch off `main`: `git checkout -b feat/<topic>`.
2. Create or edit the files following the conventions above.
3. Run the checks (see Tooling).
4. Open a PR and fill the checklist from the template.

## Definition of done

- [ ] Content is in English.
- [ ] Config invariants hold (OTLP-only ingest, local dev backend, retention set, datasource uid `tempo`).
- [ ] No secrets or tokens are committed (`.env` stays gitignored).
- [ ] `bash -n scripts/*.sh` and `shellcheck scripts/*.sh` pass.
- [ ] `docker compose -f compose.yml config --quiet` passes.
- [ ] `make validate` passes locally.
- [ ] `markdownlint` and link check pass (CI runs them too).
- [ ] `README.md` is updated when the stack, ports or commands change.

## Tooling

```sh
# Validate (needs the stack running)
make validate

# Lint markdown
npx --yes markdownlint-cli2 README.md AGENTS.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md .github/CONTRIBUTING.md docs/**/*.md .claude/skills/**/SKILL.md .opencode/command/*.md

# Check links in a single file (config lives in .github/)
npx --yes markdown-link-check -c .github/markdown-link-check.json <file>
```

## License

This repository is licensed under the MIT License (see [LICENSE](LICENSE)).
