# rick-server

Self-host your own **Rick** — an offensive-security AI companion with your voice, your notes, and your
tools — on your own hardware, reachable from any device on your network. No cloud, no laptop-in-the-loop.

`rick-server` is the deployment companion to [`rick_mcp`](https://github.com/j1v37u2k3y/rick). Where
`rick_mcp` is the MCP server (the identity + tools), `rick-server` stands up the whole self-hosted stack
around it:

- **Ollama** (native, GPU) serving your persona-baked model
- **Open WebUI** — a chat GUI reachable from any browser on your LAN
- **Your vault** as a retrieval-augmented knowledge base (RAG)
- **The `rick_*` tools** exposed to the model over MCP → OpenAPI (`mcpo`)

> The persona is baked into the Ollama model by `rick_mcp` (`make rick-ollama`). `rick-server` gives it a
> home, a face, and its memory.

## Architecture

```
   Any browser on your LAN
            |
     Open WebUI  (:3000)
      |            |                 |
   rick model   vault RAG        rick_* tools
   (Ollama)   (Knowledge base)   (rick-tools: mcpo)
      |            |                 |
   ------------ your host --------------
     Docker Compose; Ollama native on the GPUs
```

## Requirements

- A Linux host running **Ollama** with a persona-baked model (see `rick_mcp`'s `make rick-ollama`)
- **Docker + Compose** — `scripts/install-docker.sh` installs it on Ubuntu/Debian
- (Optional, but it's what makes Rick *yours*) your private `rick_mcp` content repo cloned to `~/.rick_mcp`
  on the host — identity, soul, and vault

## Quick start

```bash
git clone https://github.com/j1v37u2k3y/rick-server.git
cd rick-server
make env            # cp .env.example .env
$EDITOR .env        # set ports, secrets, RICK_MCP_HOME
make up             # docker compose up -d
```

Open `http://<host>:3000`, create your admin account, pick the `rick` model, and talk to Rick.

## Configuration

All config lives in `.env` (never committed). See `.env.example` for the full list.

| Var | What |
|---|---|
| `OPENWEBUI_PORT` | Port for the web UI (default `3000`) |
| `OLLAMA_BASE_URL` | Where the host's Ollama listens (default `http://host.docker.internal:11434`) |
| `RICK_MCP_HOME` | Path to your private `~/.rick_mcp` clone (identity / soul / vault) |
| `MCPO_API_KEY` | Auth key for the tools (`mcpo`) service |

## Phases

Built and documented in three additive phases:

1. **[Open WebUI + model](docs/phase1-openwebui.md)** — the GUI talking to your Ollama model
2. **[Vault as RAG](docs/phase2-vault-rag.md)** — Rick answers grounded in your notes
3. **[Tools via mcpo](docs/phase3-tools-mcpo.md)** — the `rick_*` tools callable from chat

## Security

- **LAN only.** Do not port-forward the web UI to the internet. Open WebUI has its own login — keep it on
  your local network.
- **Nothing private in git.** Real values live in `.env` (gitignored). Your vault content, identity, and
  secrets stay on your host. Pre-commit and CI run `detect-private-key` and `gitleaks`.

## No Docker?

A native `uv` + `systemd` path lives under [`scripts/native/`](scripts/native/) as a fallback.

## License

MIT — see [LICENSE](LICENSE).
