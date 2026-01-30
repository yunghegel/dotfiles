#!/bin/bash

# 08-wireguard.sh - WireGuard VPN setup
# This script installs WireGuard and generates initial keys

set -e

echo "=== WireGuard Installation ==="

# Install WireGuard
echo "Installing WireGuard..."
sudo apt-get install -y wireguard

# Generate WireGuard keys
echo "Generating WireGuard keys..."
sudo mkdir -p /etc/wireguard
sudo wg genkey | sudo tee /etc/wireguard/privatekey | sudo wg pubkey | sudo tee /etc/wireguard/publickey >/dev/null

# Set proper permissions
sudo chmod 600 /etc/wireguard/privatekey
sudo chmod 644 /etc/wireguard/publickey

# Display public key for configuration
echo "✅ WireGuard installed successfully!"
echo "ℹ️  Your WireGuard public key:"
sudo cat /etc/wireguard/publickey
echo ""
echo "ℹ️  Private key has been saved to /etc/wireguard/privatekey"
echo "ℹ️  You'll need to create a configuration file in /etc/wireguard/ to set up your VPN."