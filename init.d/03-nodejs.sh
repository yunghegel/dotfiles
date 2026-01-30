#!/bin/bash

# 03-nodejs.sh - NVM and Node.js installation with version selection
# This script installs NVM and a selected version of Node.js

set -e

echo "=== NVM and Node.js Installation ==="

# Get Node.js version (default to 20 if not provided)
NODE_VERSION="${1:-20}"

echo "Installing NVM and Node.js version $NODE_VERSION..."

# Install NVM
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "Installing NVM..."
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    # Fetch the latest tags and checkout the latest version
    git fetch --tags
    git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    cd - > /dev/null
else
    echo "NVM is already installed."
fi

# Source NVM for this script session
. "$NVM_DIR/nvm.sh"

# Add NVM to shell configuration files
add_nvm_to_shell_config() {
    local config_file="$1"
    
    if [ -f "$config_file" ] && ! grep -q 'export NVM_DIR="$HOME/.nvm"' "$config_file"; then
        echo "Adding NVM configuration to $config_file..."
        cat >> "$config_file" << 'EOF'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    fi
}

# Add to common shell configuration files
add_nvm_to_shell_config "$HOME/.bashrc"
add_nvm_to_shell_config "$HOME/.zshrc"
add_nvm_to_shell_config "$HOME/.profile"

# Install specified Node.js version
echo "Installing Node.js version $NODE_VERSION..."
nvm install "$NODE_VERSION"
nvm alias default "$NODE_VERSION"
nvm use default

# Verify installation
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

echo "✅ NVM and Node.js $NODE_VERSION installed successfully!"
echo "ℹ️  Please restart your terminal or source your shell configuration to use NVM."