#!/bin/bash

# 12-dotfiles.sh - Copy shell configuration files to home directory
# This script copies .functions, .aliases, and other dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Dotfiles Installation ==="

# Backup existing file/directory
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        echo "Backing up $target to $backup"
        mv "$target" "$backup"
    fi
}

# Copy .functions directory
copy_functions() {
    echo "Copying .functions directory..."

    if [ -d "$DOTFILES_DIR/.functions" ]; then
        backup_if_exists "$HOME/.functions"
        cp -r "$DOTFILES_DIR/.functions" "$HOME/.functions"

        # Remove .DS_Store files if present
        find "$HOME/.functions" -name ".DS_Store" -delete 2>/dev/null || true

        echo "✓ .functions copied to $HOME/.functions"
    else
        echo "Warning: .functions directory not found in dotfiles."
    fi
}

# Copy .aliases file
copy_aliases() {
    echo "Copying .aliases file..."

    if [ -f "$DOTFILES_DIR/.aliases" ]; then
        backup_if_exists "$HOME/.aliases"
        cp "$DOTFILES_DIR/.aliases" "$HOME/.aliases"
        echo "✓ .aliases copied to $HOME/.aliases"
    else
        echo "Warning: .aliases file not found in dotfiles."
    fi
}

# Copy additional config files if they exist
copy_additional_configs() {
    # Copy .env template if it exists (without sensitive data)
    if [ -f "$DOTFILES_DIR/.env.template" ]; then
        if [ ! -f "$HOME/.env" ]; then
            cp "$DOTFILES_DIR/.env.template" "$HOME/.env"
            echo "✓ .env template copied (please configure with your values)"
        fi
    fi

    # Create empty .paths file if it doesn't exist
    if [ ! -f "$HOME/.paths" ]; then
        touch "$HOME/.paths"
        echo "✓ Created empty .paths file"
    fi
}

# Main execution
copy_functions
copy_aliases
copy_additional_configs

echo ""
echo "✅ Dotfiles installation completed!"
echo "ℹ️  Your shell configuration files are now in place."
