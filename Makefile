# rick-server — self-host your own Rick.
.PHONY: help env up down restart logs ps lint ingest-vault
.DEFAULT_GOAL := help

ENV_FILE ?= .env

help: ## Show available targets
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'

env: ## Create .env from .env.example if it does not exist
	@test -f $(ENV_FILE) || { cp .env.example $(ENV_FILE); echo "Created $(ENV_FILE) — edit it before 'make up'."; }

up: ## Start the stack (detached)
	docker compose up -d

down: ## Stop the stack
	docker compose down

restart: ## Restart the stack
	docker compose restart

logs: ## Follow service logs
	docker compose logs -f

ps: ## Show service status
	docker compose ps

ingest-vault: ## Ingest the vault into Open WebUI (reads RICK_MCP_HOME)
	./scripts/ingest-vault.sh

lint: ## Run all pre-commit hooks
	pre-commit run --all-files
