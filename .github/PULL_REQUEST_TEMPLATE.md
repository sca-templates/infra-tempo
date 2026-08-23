# Pull Request

## Summary

<!-- One or two lines: what this PR changes and why. -->

## Changes

<!-- List the notes/files touched. -->

## Checklist

- [ ] I have read [CONTRIBUTING.md](CONTRIBUTING.md).
- [ ] Content is in English.
- [ ] Config invariants hold (OTLP-only ingest, local dev backend, retention set, datasource uid `tempo`).
- [ ] No secrets or tokens are committed (`.env` stays gitignored).
- [ ] `make validate` passes locally.
- [ ] `bash -n scripts/*.sh` and `shellcheck scripts/*.sh` pass.
- [ ] `npx --yes markdownlint-cli2 README.md AGENTS.md CLAUDE.md .github/PULL_REQUEST_TEMPLATE.md .github/CONTRIBUTING.md docs/**/*.md .claude/skills/**/SKILL.md .opencode/command/*.md` passes.
- [ ] `README.md` is updated when the stack, ports or commands change.
