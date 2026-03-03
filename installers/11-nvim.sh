#!/bin/bash

# 11-nvim.sh - Neovim installation and configuration
# This script installs Neovim and sets up a lightweight configuration

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

    echo "Downloading Neovim AppImage..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim

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
    elif command -v brew &> /dev/null; then
        brew install ripgrep fd node 2>/dev/null || true
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y ripgrep fd-find python3-pip nodejs npm 2>/dev/null || true
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm ripgrep fd python-pip nodejs npm 2>/dev/null || true
    fi

    # Install pynvim for Python support
    if command -v pip3 &> /dev/null; then
        pip3 install --user pynvim 2>/dev/null || true
    fi

    # Install neovim npm package for Node support
    if command -v npm &> /dev/null; then
        npm install -g neovim 2>/dev/null || true
    fi

    # Install language servers for LSP
    if command -v npm &> /dev/null; then
        echo "Installing language servers..."
        npm install -g typescript typescript-language-server 2>/dev/null || true
        npm install -g pyright 2>/dev/null || true
    fi
}

# Setup lightweight configuration
setup_config() {
    echo "Setting up lightweight Neovim configuration..."

    local nvim_config_dir="$HOME/.config/nvim"

    # Backup existing config if present
    if [ -d "$nvim_config_dir" ] || [ -f "$nvim_config_dir/init.lua" ]; then
        echo "Backing up existing Neovim config..."
        mv "$nvim_config_dir" "$nvim_config_dir.backup.$(date +%Y%m%d%H%M%S)"
    fi

    # Create config directory and copy init.lua + colors
    mkdir -p "$nvim_config_dir"

    if [ -f "$DOTFILES_DIR/nvim/init.lua" ]; then
        echo "Copying init.lua configuration..."
        cp "$DOTFILES_DIR/nvim/init.lua" "$nvim_config_dir/init.lua"

        if [ -d "$DOTFILES_DIR/nvim/colors" ]; then
            cp -r "$DOTFILES_DIR/nvim/colors" "$nvim_config_dir"
            echo "Config copied to $nvim_config_dir/"
        else
            echo "Warning: nvim/colors directory not found."
            echo "Config copied to $nvim_config_dir/init.lua"
        fi
    else
        echo "Error: nvim/init.lua not found in dotfiles."
        exit 1
    fi
}

# Main execution
install_neovim
install_dependencies
setup_config

echo ""
echo "Neovim installation completed!"
echo ""
echo "Next steps:"
echo "  1. Run 'nvim' to launch Neovim"
echo "  2. Wait for plugins to install automatically on first launch"
echo "  3. Run ':checkhealth' to verify everything is working"
