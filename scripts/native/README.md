# Native (no-Docker) fallback

For hosts without Docker. Runs Open WebUI via [`uv`](https://github.com/astral-sh/uv) (pinned Python 3.11)
and `mcpo` via `uvx`, kept alive with `systemd --user` units (see `../../systemd/`).

The **primary, supported** path is Docker Compose (repo root `README.md`). These native scripts are a
convenience for Docker-less hosts and are validated separately.

- `00-install-openwebui.sh` — install `uv`, `uv tool install --python 3.11 open-webui`, run on `$OPENWEBUI_PORT`
- `20-install-mcpo.sh` — clone `rick_mcp`, venv, run `mcpo` wrapping it

> Scripts land here as the native path is filled in. Prefer Docker Compose unless you can't use it.
