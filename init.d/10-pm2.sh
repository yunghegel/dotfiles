#!/bin/bash

# 10-pm2.sh - PM2 process manager installation
# This script installs PM2 and configures it to start on boot

set -e

echo "=== PM2 Process Manager Installation ==="

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is required for PM2. Please install Node.js first."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "Error: npm is required for PM2. Please install Node.js first."
    exit 1
fi

# Install PM2 globally
echo "Installing PM2..."
npm install -g pm2

# Set up PM2 to start on boot
echo "Configuring PM2 startup..."

# Generate startup script
PM2_STARTUP_OUTPUT=$(pm2 startup 2>/dev/null || true)

# Extract the sudo command from PM2 startup output
if echo "$PM2_STARTUP_OUTPUT" | grep -q "sudo env"; then
    STARTUP_CMD=$(echo "$PM2_STARTUP_OUTPUT" | grep "sudo env" | head -1)
    echo "Executing PM2 startup command..."
    eval "$STARTUP_CMD"
else
    echo "Warning: Could not automatically configure PM2 startup."
    echo "You may need to run 'pm2 startup' manually after installation."
fi

# Verify PM2 installation
echo "Verifying PM2 installation..."
if pm2 --version; then
    echo "✅ PM2 installed successfully!"
    echo "ℹ️  Use 'pm2 start <app>' to manage your applications"
    echo "ℹ️  Use 'pm2 save' to save current process list"
    echo "ℹ️  Use 'pm2 list' to see running processes"
else
    echo "❌ PM2 installation failed!"
    exit 1
fi