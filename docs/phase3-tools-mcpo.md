# Phase 3 — `rick_*` tools via mcpo

Give Rick his hands: expose the `rick_mcp` tools to the model as OpenAPI endpoints via
[`mcpo`](https://github.com/open-webui/mcpo), so Rick can call them from chat.

## Prerequisites

- Phase 1 running
- Your `rick_mcp` content at `RICK_MCP_HOME` (identity/soul, so tools are personalized)
- `MCPO_API_KEY` set in `.env`

## Run

```bash
make up            # brings up the rick-tools service alongside open-webui
```

Then in Open WebUI: **Settings > Tools > add** an OpenAPI server at `http://rick-tools:<MCPO_PORT>` (key =
`MCPO_API_KEY`). Rick can now call the `rick_*` tools mid-conversation.

## Scope

This wires the **read-only / generator** tools (CVE lookup, cheatsheets, recon guidance, attack chains,
hardening, …). The **stateful** tools (engagement / kill-chain / tracker) write to `~/.rick_mcp` — running
them here would create a *second* state store separate from your workstation. Keep stateful engagement
tracking on one machine to avoid split-brain state.
