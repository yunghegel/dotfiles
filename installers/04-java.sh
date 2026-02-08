#!/bin/bash

# 04-java.sh - SDKMAN and Java installation with version selection
# This script installs SDKMAN and a selected version of OpenJDK

set -e

echo "=== SDKMAN and Java Installation ==="

# Get Java version (default to 17 if not provided)
JAVA_VERSION="${1:-17}"

echo "Installing SDKMAN and OpenJDK version $JAVA_VERSION..."

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    echo "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
else
    echo "SDKMAN is already installed."
fi

# Source SDKMAN for this script session
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Add SDKMAN to shell configuration files
add_sdkman_to_shell_config() {
    local config_file="$1"
    
    if [ -f "$config_file" ] && ! grep -q 'source "$HOME/.sdkman/bin/sdkman-init.sh"' "$config_file"; then
        echo "Adding SDKMAN configuration to $config_file..."
        cat >> "$config_file" << 'EOF'

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF
    fi
}

# Add to common shell configuration files
add_sdkman_to_shell_config "$HOME/.bashrc"
add_sdkman_to_shell_config "$HOME/.zshrc"
add_sdkman_to_shell_config "$HOME/.profile"

# Function to find the best available OpenJDK version
find_openjdk_version() {
    local version="$1"
    
    # List available Java versions and find a matching OpenJDK version
    sdk list java | grep -i "tem\|temurin\|eclipse" | grep "^[[:space:]]*$version" | head -1 | awk '{print $NF}' || {
        # Fallback: try to find any version matching the major version number
        sdk list java | grep "^[[:space:]]*$version" | head -1 | awk '{print $NF}' || {
            echo "17.0.10-tem" # Ultimate fallback
        }
    }
}

# Find and install the appropriate OpenJDK version
echo "Looking for OpenJDK version $JAVA_VERSION..."
JAVA_IDENTIFIER=$(find_openjdk_version "$JAVA_VERSION")

if [ -z "$JAVA_IDENTIFIER" ]; then
    echo "Could not find OpenJDK version $JAVA_VERSION. Using default 17.0.10-tem"
    JAVA_IDENTIFIER="17.0.10-tem"
fi

echo "Installing Java: $JAVA_IDENTIFIER"
sdk install java "$JAVA_IDENTIFIER"

# Set as default
sdk default java "$JAVA_IDENTIFIER"

# Verify installation
echo "Java version: $(java -version 2>&1 | head -1)"
echo "JAVA_HOME: $JAVA_HOME"

echo "✅ SDKMAN and Java $JAVA_VERSION installed successfully!"
echo "ℹ️  Please restart your terminal or source your shell configuration to use SDKMAN."