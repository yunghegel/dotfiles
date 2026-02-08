#!/bin/bash

# 14-micro.sh - Micro editor plugins installation
# This script installs micro editor and sets up plugins

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Micro Editor Installation ==="

# Install micro editor
install_micro() {
    if command -v micro &> /dev/null; then
        echo "Micro editor is already installed."
        micro --version
        return 0
    fi

    echo "Installing Micro editor..."

    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y micro
    elif command -v brew &> /dev/null; then
        brew install micro
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y micro
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm micro
    else
        # Fallback: use official install script
        echo "Using official install script..."
        curl https://getmic.ro | bash
        sudo mv micro /usr/local/bin/
    fi
}

# Copy plugins from dotfiles
copy_plugins() {
    echo "Setting up Micro plugins..."

    local micro_config_dir="$HOME/.config/micro"
    local micro_plugins_dir="$micro_config_dir/plug"

    # Create config directory
    mkdir -p "$micro_plugins_dir"

    # Check if dotfiles has micro plugins
    if [ -d "$DOTFILES_DIR/micro" ]; then
        echo "Copying plugins from dotfiles..."

        # Copy each plugin directory
        for plugin_dir in "$DOTFILES_DIR/micro"/*; do
            if [ -d "$plugin_dir" ]; then
                local plugin_name=$(basename "$plugin_dir")

                # Skip .DS_Store and other hidden files
                if [[ "$plugin_name" == .* ]]; then
                    continue
                fi

                echo "  Installing plugin: $plugin_name"

                # Remove existing plugin if present
                rm -rf "$micro_plugins_dir/$plugin_name"

                # Copy plugin
                cp -r "$plugin_dir" "$micro_plugins_dir/"
            fi
        done

        echo "✓ Plugins copied from dotfiles"
    else
        echo "No micro plugins found in dotfiles. Installing recommended plugins..."
        install_recommended_plugins
    fi
}

# Install recommended plugins via micro plugin manager
install_recommended_plugins() {
    local plugins=(
        "filemanager"
        "fzf"
        "lsp"
        "bounce"
        "quoter"
        "detectindent"
    )

    for plugin in "${plugins[@]}"; do
        echo "  Installing: $plugin"
        micro -plugin install "$plugin" 2>/dev/null || true
    done
}

# Create default settings if not exists
setup_settings() {
    local settings_file="$HOME/.config/micro/settings.json"

    if [ ! -f "$settings_file" ]; then
        echo "Creating default micro settings..."
        mkdir -p "$(dirname "$settings_file")"
        cat > "$settings_file" << 'EOF'
{
    "colorscheme": "monokai-dark",
    "tabsize": 4,
    "tabstospaces": true,
    "autoindent": true,
    "syntax": true,
    "saveundo": true,
    "scrollbar": true,
    "rmtrailingws": true,
    "lsp": true
}
EOF
        echo "✓ Default settings created"
    fi
}

# Main execution
install_micro
copy_plugins
setup_settings

echo ""
echo "✅ Micro editor installation completed!"
echo ""
echo "Installed plugins:"
ls -1 "$HOME/.config/micro/plug" 2>/dev/null || echo "  (none)"
