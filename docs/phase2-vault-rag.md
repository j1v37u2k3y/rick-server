# Phase 2 — Vault as RAG

Give Rick your memory: ingest your vault notes into an Open WebUI Knowledge base so answers about your own
work are grounded in your notes.

## Prerequisites

- Phase 1 running
- Your private `rick_mcp` content repo cloned on the host at `RICK_MCP_HOME` (contains `vault/`)
- An Open WebUI API key (Settings > Account > API Keys) set as `OPENWEBUI_API_KEY` in `.env`

## Run

```bash
make ingest-vault     # reads $RICK_MCP_HOME/vault, uploads into an Open WebUI Knowledge collection
```

Attach the resulting Knowledge collection to the `rick` model (Workspace > Models), or reference it in chat
with `#`. Ask "what's on my backlog" / "what did I decide about X" — Rick answers from your notes.

Refresh after updating your notes: `git pull` in your `~/.rick_mcp` clone, then re-run `make ingest-vault`.

## Privacy

Your vault is **private** (identity, engagements, embargoed writeups). It is ingested into Open WebUI **on
your host, behind its login, on your LAN only**. Never port-forward the web UI to the internet. Vault
content is never committed to this repo.
