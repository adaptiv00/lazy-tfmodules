#!/usr/bin/env bash

echo " -- Checking docker"
if [ -n "$(command -v docker)" ]; then
  echo " -- Docker already there, skipping..."
else
  echo " -- Docker not found, installing version $VERSION..."
  sudo -E curl -sSL https://get.docker.com/ | sh
fi

echo " -- Configuring..."

sudo usermod -aG docker $APP_USER
sudo usermod -aG docker $SSH_USER

# Docker daemon
sudo mkdir -p /etc/docker
sudo mv /tmp/daemon.json /etc/docker/daemon.json

# Docker service
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo mv /tmp/docker.conf /etc/systemd/system/docker.service.d/docker.conf

# Bounce
sudo systemctl daemon-reload
sudo service docker restart

echo " -- Docker setup done."

