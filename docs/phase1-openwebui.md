# Phase 1 — Open WebUI + your model

Stand up the web GUI and point it at the persona-baked `rick` model on your host's Ollama.

## Prerequisites

- Docker + Compose on the host (`scripts/install-docker.sh`)
- Ollama running natively on the host with a persona-baked model (see `rick_mcp`'s `make rick-ollama`)
- `.env` filled in (`make env`, then edit) — at minimum `OPENWEBUI_PORT` and `WEBUI_SECRET_KEY`

## Run

```bash
make up          # docker compose up -d  (open-webui service)
make logs        # watch it come up
```

Open `http://<host>:<OPENWEBUI_PORT>` (default `:3000`), create the admin account, and select the `rick`
model. It answers in Rick's voice — the persona is baked into the model, so the GUI inherits it. No tools
or vault yet; those are Phases 2 and 3.

## Notes

- Ollama stays **native** on the host (it owns the GPUs). The container reaches it via
  `host.docker.internal` — see `OLLAMA_BASE_URL` in `.env`.
- The service is set to `restart: unless-stopped`, so it comes back on reboot.
