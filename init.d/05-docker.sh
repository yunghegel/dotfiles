#!/bin/bash

# 05-docker.sh - Docker installation
# This script installs Docker and configures user permissions

set -e

echo "=== Docker Installation ==="

# Add Docker's official GPG key
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo "Setting up Docker repository..."
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Update package index
echo "Updating package index..."
sudo apt-get update

# Install Docker Engine
echo "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add current user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

# Enable and start Docker service
echo "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Verify installation
echo "Verifying Docker installation..."
if sudo docker --version; then
    echo "✅ Docker installed successfully!"
    echo "ℹ️  Please log out and back in for the group change to take effect."
    echo "ℹ️  After relogging, you can run Docker commands without sudo."
else
    echo "❌ Docker installation failed!"
    exit 1
fi