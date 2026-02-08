#!/bin/bash

# 01-system.sh - System update and base package installation
# This script updates the system and installs essential packages

set -e

echo "=== System Update and Base Packages ==="

# Update system packages
echo "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install essential package
echo "Installing essential packages..."
sudo apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    fzf \
    build-essential \
    cmake \
    openssh-server \
    tmux \

echo "✅ System update and base installed successfully!"
