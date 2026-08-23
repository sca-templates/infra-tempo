SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help

COMPOSE_FILE := compose.yml
COMPOSE_PROJECT_NAME := tempo
COMPOSE := docker compose -f $(COMPOSE_FILE) -p $(COMPOSE_PROJECT_NAME)

.PHONY: help
help:
	@echo 'tempo — Distributed tracing backend (OTLP ingest, TraceQL queries)'
	@echo ''
	@echo '  make up            Start Tempo (OTLP :4317/:4318, API :3200)'
	@echo '  make all           setup + up + validate'
	@echo '  make validate      Verify readiness and search API'
	@echo '  make down          Stop and remove'
	@echo '  make restart       down + up'
	@echo '  make stop          Stop without removing'
	@echo '  make logs          Live logs'
	@echo '  make ps            Container status'
	@echo '  make clean         down + remove volume + remove .env'

.PHONY: setup
setup:
	@if [[ ! -f .env ]]; then cp .env.example .env; echo '[OK] .env created from example'; else echo '[OK] .env already present'; fi

.PHONY: up
up:
	@echo '=== Starting Tempo ==='
	$(COMPOSE) up -d

.PHONY: validate
validate:
	@echo '=== Validating Tempo ==='
	scripts/validate.sh

.PHONY: all
all: setup up validate
	@echo ''
	@echo '============================================'
	@echo '  Tempo ready:'
	@echo '  OTLP gRPC: 127.0.0.1:4317   OTLP HTTP: 127.0.0.1:4318'
	@echo '  TraceQL:   http://127.0.0.1:3200  (Grafana datasource uid: tempo)'
	@echo '============================================'

.PHONY: down
down:
	@echo '=== Stopping stack ==='
	$(COMPOSE) down

.PHONY: restart
restart: down up

.PHONY: stop
stop:
	$(COMPOSE) stop

.PHONY: logs
logs:
	$(COMPOSE) logs -f

.PHONY: ps
ps:
	$(COMPOSE) ps

.PHONY: clean
clean:
	@echo '=== Cleaning up ==='
	-$(COMPOSE) down -v 2>/dev/null || true
	rm -f .env
	@echo 'Done.'
