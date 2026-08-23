#!/usr/bin/env bash
#
# validate.sh — Verify Tempo is healthy and serving queries: readiness
# endpoint, TraceQL search API and the OTLP receiver ports listening.
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../compose.yml"
PROJECT_NAME=tempo

PASS=0
FAIL=0

ok()   { echo "[OK]   $1"; PASS=$((PASS+1)); }
fail() { echo "[FAIL] $1"; FAIL=$((FAIL+1)); }

# ── 1. Container healthy ──────────────────────────────────────────────────────
STATE="$(docker compose -f "${COMPOSE_FILE}" -p "${PROJECT_NAME}" ps --format '{{.Name}} {{.Health}}' 2>/dev/null | awk '$1=="tempo"{print $2}')"
if [[ "${STATE}" == "healthy" ]]; then
    ok "Container tempo is healthy"
else
    fail "Container tempo health='${STATE:-missing}' (expected healthy)"
fi

# ── 2. Readiness endpoint ─────────────────────────────────────────────────────
BODY="$(curl -s "http://127.0.0.1:3200/ready" || true)"
if [[ "${BODY}" == "ready" ]]; then
    ok "Readiness endpoint :3200/ready reports ready"
else
    fail ":3200/ready returned '${BODY}' (expected 'ready')"
fi

# ── 3. Search API answers (TraceQL over HTTP) ─────────────────────────────────
HTTP_CODE="$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:3200/api/search?q={}" || true)"
if [[ "${HTTP_CODE}" == "200" ]]; then
    ok "Search API :3200/api/search responds"
else
    fail ":3200/api/search returned '${HTTP_CODE}' (expected 200)"
fi

# ── 4. OTLP receivers listening ───────────────────────────────────────────────
for port in 4317 4318; do
    if nc -z 127.0.0.1 "${port}" 2>/dev/null; then
        ok "OTLP receiver listening on :${port}"
    else
        fail "OTLP receiver :${port} not reachable"
    fi
done

echo ""
echo "=== Validation complete: ${PASS} passed, ${FAIL} failed ==="
exit "${FAIL}"
