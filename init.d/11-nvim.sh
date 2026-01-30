#!/bin/bash

# 11-nvim.sh - Neovim installation and configuration
# This script installs Neovim and sets up the custom configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Neovim Installation ==="

# Install Neovim
install_neovim() {
    if command -v nvim &> /dev/null; then
        echo "Neovim is already installed."
        nvim --version | head -1
        return 0
    fi

    echo "Installing Neovim..."

    # Try to install latest stable via PPA (Ubuntu/Debian)
    if command -v apt-get &> /dev/null; then
        sudo add-apt-repository -y ppa:neovim-ppa/stable 2>/dev/null || true
        sudo apt-get update
        sudo apt-get install -y neovim
    elif command -v brew &> /dev/null; then
        brew install neovim
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y neovim
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm neovim
    else
        # Fallback: download appimage
        echo "Downloading Neovim AppImage..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv nvim.appimage /usr/local/bin/nvim
    fi
}

# Install dependencies for plugins
install_dependencies() {
    echo "Installing Neovim dependencies..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y \
            ripgrep \
            fd-find \
            python3-pip \
            python3-venv \
            nodejs \
            npm 2>/dev/null || true
    fi

    # Install pynvim for Python support
    if command -v pip3 &> /dev/null; then
        pip3 install --user pynvim 2>/dev/null || true
    fi

    # Install neovim npm package for Node support
    if command -v npm &> /dev/null; then
        npm install -g neovim 2>/dev/null || true
    fi
}

# Setup Neovim configuration
setup_config() {
    echo "Setting up Neovim configuration..."

    local nvim_config_dir="$HOME/.config/nvim"
    local nvchad_dir="$HOME/.local/share/nvchad"

    # Backup existing config if present
    if [ -d "$nvim_config_dir" ]; then
        echo "Backing up existing Neovim config..."
        mv "$nvim_config_dir" "$nvim_config_dir.backup.$(date +%Y%m%d%H%M%S)"
    fi

    # Create config directory
    mkdir -p "$HOME/.config"

    # Copy nvim config
    if [ -d "$DOTFILES_DIR/nvim-config/nvim" ]; then
        echo "Copying Neovim configuration..."
        cp -r "$DOTFILES_DIR/nvim-config/nvim" "$nvim_config_dir"
    else
        echo "Warning: nvim-config/nvim directory not found in dotfiles."
        echo "Creating basic config directory..."
        mkdir -p "$nvim_config_dir"
    fi

    # Copy NvChad base if present
    if [ -d "$DOTFILES_DIR/nvim-config/nvchad" ]; then
        echo "Copying NvChad base..."
        mkdir -p "$nvchad_dir"
        cp -r "$DOTFILES_DIR/nvim-config/nvchad"/* "$nvchad_dir/"
    fi
}

# Main execution
install_neovim
install_dependencies
setup_config

echo "✅ Neovim installation completed!"
echo "ℹ️  Run 'nvim' and wait for plugins to install on first launch."
