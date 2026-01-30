#!/bin/bash

# 02-zsh.sh - ZSH and Oh My Zsh installation with plugin selection
# This script installs ZSH, Oh My Zsh, and selected plugins

set -e

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

# Update .zshrc with selected plugins
echo "Updating .zshrc with selected plugins..."
if [ -f ~/.zshrc ]; then
    # Create backup
    cp ~/.zshrc ~/.zshrc.backup
    
    # Replace plugins line
    plugin_string=$(echo "$selected_plugins" | tr ' ' '\n' | sort -u | tr '\n' ' ' | sed 's/ $//')
    sed -i "s/plugins=(git)/plugins=($plugin_string)/" ~/.zshrc
else
    echo "Warning: .zshrc not found. You may need to configure plugins manually."
fi

echo "✅ ZSH and Oh My Zsh installation completed!"
echo "ℹ️  Please restart your terminal or run 'zsh' to use the new shell."