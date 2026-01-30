#!/bin/bash

# 07-syncthing.sh - Syncthing file synchronization setup
# This script installs and configures Syncthing

set -e

echo "=== Syncthing Installation ==="

# Get credentials from environment or parameters
SYNC_USER="${1:-$USER}"
SYNC_PASS="${2:-}"

if [ -z "$SYNC_PASS" ]; then
    echo "Error: Syncthing password is required"
    echo "Usage: $0 [username] [password]"
    exit 1
fi

# Install Syncthing
echo "Installing Syncthing..."
sudo apt-get install -y syncthing

# Create systemd service for Syncthing
echo "Creating Syncthing systemd service..."
cat << EOF | sudo tee /etc/systemd/system/syncthing@.service >/dev/null
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization for %I
Documentation=man:syncthing(1)
After=network.target

[Service]
User=%i
ExecStart=/usr/bin/syncthing -no-browser -home="/home/%i/.config/syncthing"
Restart=on-failure
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Syncthing service
echo "Enabling and starting Syncthing service..."
sudo systemctl daemon-reload
sudo systemctl enable syncthing@$SYNC_USER
sudo systemctl start syncthing@$SYNC_USER

# Wait for Syncthing to initialize
echo "Waiting for Syncthing to initialize..."
sleep 10

# Configure Syncthing
echo "Configuring Syncthing..."
syncthing cli config gui set-address 0.0.0.0:3060
syncthing cli config gui set-user "$SYNC_USER"
syncthing cli config gui set-password "$SYNC_PASS"

# Restart Syncthing to apply configuration
echo "Restarting Syncthing to apply configuration..."
sudo systemctl restart syncthing@$SYNC_USER

echo "✅ Syncthing installed and configured!"
echo "ℹ️  Syncthing Web UI available at: http://localhost:3060"
echo "   Username: $SYNC_USER"
echo "   Password: [hidden]"