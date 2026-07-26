#!/usr/bin/env bash
# Install Docker Engine + Compose plugin on Ubuntu/Debian and add the current user to
# the docker group. Safe to re-run. Run on the host that will run the stack.
set -euo pipefail

user="$(id -un)"

if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  echo "Docker + Compose already present: $(docker --version)"
  exit 0
fi

echo "Installing Docker via get.docker.com ..."
curl -fsSL https://get.docker.com | sh

echo "Adding ${user} to the docker group ..."
sudo usermod -aG docker "${user}"
sudo systemctl enable --now docker

echo "Installed: $(sudo docker --version) / $(sudo docker compose version)"
echo "Log out and back in (or run 'newgrp docker') for group membership to take effect."
