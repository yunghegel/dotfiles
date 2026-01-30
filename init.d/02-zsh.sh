#!/bin/bash

# 02-zsh.sh - ZSH and Oh My Zsh installation with plugin selection
# This script installs ZSH, Oh My Zsh, and selected plugins

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== ZSH and Oh My Zsh Installation ==="

# Function to install ZSH plugins
install_zsh_plugin() {
    local plugin_name="$1"
    local plugin_repo="$2"
    local plugins_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins"

    if [ ! -d "${plugins_dir}/${plugin_name}" ]; then
        echo "Installing ${plugin_name}..."
        git clone "${plugin_repo}" "${plugins_dir}/${plugin_name}"
    else
        echo "${plugin_name} is already installed."
    fi
}

# Install ZSH
echo "Installing ZSH..."
sudo apt-get install -y zsh

# Set ZSH as default shell
echo "Setting ZSH as default shell..."
chsh -s "$(which zsh)"

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Set ZSH_CUSTOM directory
export ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Parse selected plugins (passed as arguments)
selected_plugins="$@"
if [ -z "$selected_plugins" ]; then
    selected_plugins="git zsh-syntax-highlighting zsh-autosuggestions zsh-completions"
fi

echo "Installing selected plugins: $selected_plugins"

# Install each selected plugin
for plugin in $selected_plugins; do
    case $plugin in
        "zsh-syntax-highlighting")
            install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
            ;;
        "zsh-autosuggestions")
            install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
            ;;
        "zsh-completions")
            install_zsh_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions.git"
            ;;
        "zsh-history-substring-search")
            install_zsh_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search.git"
            ;;
        "fast-syntax-highlighting")
            install_zsh_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
            ;;
        *)
            echo "Plugin $plugin is built-in or not recognized, skipping custom installation."
            ;;
    esac
done

# Install custom theme
install_custom_theme() {
    local themes_dir="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes"

    if [ -f "$DOTFILES_DIR/zsh/custom.zsh-theme" ]; then
        echo "Installing custom ZSH theme..."
        mkdir -p "$themes_dir"
        cp "$DOTFILES_DIR/zsh/custom.zsh-theme" "$themes_dir/custom.zsh-theme"
        echo "✓ Custom theme installed"
    else
        echo "Warning: custom.zsh-theme not found in dotfiles."
    fi
}

# Install custom .zshrc
install_zshrc() {
    echo "Installing .zshrc..."

    # Backup existing .zshrc
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
        echo "Backed up existing .zshrc"
    fi

    # Copy .zshrc from dotfiles
    if [ -f "$DOTFILES_DIR/zsh/.zshrc" ]; then
        cp "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
        echo "✓ .zshrc installed from dotfiles"
    else
        echo "Creating new .zshrc with selected plugins..."
        # Create new .zshrc with selected plugins
        plugin_string=$(echo "$selected_plugins" | tr ' ' '\n' | sort -u | tr '\n' ' ' | sed 's/ $//')
        cat > ~/.zshrc << EOF
# ZSH Configuration
export PATH=\$HOME/bin:\$HOME/.local/bin:/usr/local/bin:\$PATH

# Oh My Zsh
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="custom"

# Plugins
plugins=($plugin_string)

# Completions
fpath+=\${ZSH_CUSTOM:-\${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

# Load Oh My Zsh
source \$ZSH/oh-my-zsh.sh

# Load custom functions
if [ -d ~/.functions ]; then
    for file in ~/.functions/*.func; do
        [ -f "\$file" ] && source "\$file"
    done
fi

# Load aliases
[ -f ~/.aliases ] && source ~/.aliases

# Load environment variables
[ -f ~/.env ] && source ~/.env

# Load custom paths
[ -f ~/.paths ] && source ~/.paths

# Editor
export EDITOR=\${EDITOR:-nvim}
EOF
        echo "✓ New .zshrc created"
    fi
}

# Install theme and .zshrc
install_custom_theme
install_zshrc

echo "✅ ZSH and Oh My Zsh installation completed!"
echo "ℹ️  Please restart your terminal or run 'zsh' to use the new shell."