#!/usr/bin/env bash
# Ingest your vault markdown into an Open WebUI Knowledge collection so Rick can retrieve it.
# Reads config from ../.env. Run on the host (or anywhere that can reach Open WebUI + read the vault).
#
#   OPENWEBUI_API_KEY  Open WebUI > Settings > Account > API Keys  (required)
#   RICK_MCP_HOME      path to your ~/.rick_mcp clone (its vault/ is ingested)   (required)
#   OPENWEBUI_URL      Open WebUI base URL (default http://localhost:$OPENWEBUI_PORT)
#   KB_NAME            Knowledge collection name (default "Vault")
#
# Re-run after a `git pull` in your ~/.rick_mcp clone to refresh (existing collection is reused).
set -euo pipefail

cd "$(dirname "$0")/.."
# shellcheck source=/dev/null
if [ -f .env ]; then set -a; . ./.env; set +a; fi

: "${OPENWEBUI_API_KEY:?Set OPENWEBUI_API_KEY in .env (Open WebUI > Settings > Account > API Keys)}"
: "${RICK_MCP_HOME:?Set RICK_MCP_HOME in .env}"
command -v jq >/dev/null || { echo "jq is required (apt install jq)"; exit 1; }

OWUI="${OPENWEBUI_URL:-http://localhost:${OPENWEBUI_PORT:-3000}}"
VAULT="${RICK_MCP_HOME%/}/vault"
KB_NAME="${KB_NAME:-Vault}"
AUTH=(-H "Authorization: Bearer ${OPENWEBUI_API_KEY}")

[ -d "$VAULT" ] || { echo "No vault directory at $VAULT"; exit 1; }

# Find an existing collection by name, else create one.
kb_id="$(curl -fsS "${AUTH[@]}" "${OWUI}/api/v1/knowledge/list" 2>/dev/null \
  | jq -r --arg n "$KB_NAME" 'map(select(.name==$n)) | (.[0].id // empty)')"
if [ -z "$kb_id" ]; then
  kb_id="$(curl -fsS "${AUTH[@]}" -H "Content-Type: application/json" -X POST \
    "${OWUI}/api/v1/knowledge/create" \
    -d "$(jq -nc --arg n "$KB_NAME" '{name:$n, description:"Rick second brain — vault notes"}')" \
    | jq -r '.id // empty')"
  [ -n "$kb_id" ] && echo "Created Knowledge collection '$KB_NAME' ($kb_id)"
else
  echo "Reusing Knowledge collection '$KB_NAME' ($kb_id)"
fi
[ -n "$kb_id" ] || { echo "Could not get/create the Knowledge collection — check OPENWEBUI_API_KEY and API access."; exit 1; }

ok=0; fail=0
while IFS= read -r -d '' f; do
  file_id="$(curl -fsS "${AUTH[@]}" -F "file=@${f}" "${OWUI}/api/v1/files/" 2>/dev/null | jq -r '.id // empty')"
  if [ -n "$file_id" ] && curl -fsS "${AUTH[@]}" -H "Content-Type: application/json" -X POST \
      "${OWUI}/api/v1/knowledge/${kb_id}/file/add" \
      -d "$(jq -nc --arg id "$file_id" '{file_id:$id}')" >/dev/null 2>&1; then
    ok=$((ok + 1)); printf '.'
  else
    fail=$((fail + 1)); printf 'x'
  fi
done < <(find "$VAULT" -type f -name '*.md' -print0)
echo
echo "Ingested ${ok} file(s) into '${KB_NAME}' (${fail} failed)."
echo "Attach '${KB_NAME}' to the rick model: Workspace > Models > rick > Knowledge — or reference it with # in chat."
