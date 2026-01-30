#!/bin/bash

# 13-firefox.sh - Firefox userChrome.css installation
# This script sets up custom Firefox UI styling

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Firefox userChrome.css Installation ==="

# Find Firefox profile directory
find_firefox_profile() {
    local firefox_dir=""

    # Check common Firefox profile locations
    if [ -d "$HOME/.mozilla/firefox" ]; then
        # Linux
        firefox_dir="$HOME/.mozilla/firefox"
    elif [ -d "$HOME/Library/Application Support/Firefox/Profiles" ]; then
        # macOS
        firefox_dir="$HOME/Library/Application Support/Firefox/Profiles"
    elif [ -d "$HOME/snap/firefox/common/.mozilla/firefox" ]; then
        # Linux Snap
        firefox_dir="$HOME/snap/firefox/common/.mozilla/firefox"
    fi

    if [ -z "$firefox_dir" ]; then
        echo ""
        return 1
    fi

    # Find the default profile (usually ends with .default or .default-release)
    local profile_dir=""

    # Try profiles.ini to find default profile
    if [ -f "$firefox_dir/profiles.ini" ]; then
        local default_profile=$(grep -A 10 '^\[Install' "$firefox_dir/profiles.ini" 2>/dev/null | grep "Default=" | head -1 | cut -d= -f2)
        if [ -n "$default_profile" ] && [ -d "$firefox_dir/$default_profile" ]; then
            profile_dir="$firefox_dir/$default_profile"
        fi
    fi

    # Fallback: find directory with .default in name
    if [ -z "$profile_dir" ]; then
        profile_dir=$(find "$firefox_dir" -maxdepth 1 -type d -name "*.default*" 2>/dev/null | head -1)
    fi

    echo "$profile_dir"
}

# Install userChrome.css
install_userchrome() {
    local profile_dir="$1"

    if [ -z "$profile_dir" ]; then
        echo "Error: Could not find Firefox profile directory."
        echo "Please ensure Firefox has been run at least once."
        return 1
    fi

    echo "Found Firefox profile: $profile_dir"

    # Create chrome directory if it doesn't exist
    local chrome_dir="$profile_dir/chrome"
    mkdir -p "$chrome_dir"

    # Copy userChrome.css
    if [ -f "$DOTFILES_DIR/userChrome.css" ]; then
        cp "$DOTFILES_DIR/userChrome.css" "$chrome_dir/userChrome.css"
        echo "✓ Copied userChrome.css"
    else
        echo "Warning: userChrome.css not found in dotfiles."
    fi

    # Copy css directory contents
    if [ -d "$DOTFILES_DIR/css" ]; then
        mkdir -p "$chrome_dir/css"
        cp -r "$DOTFILES_DIR/css"/* "$chrome_dir/css/"
        echo "✓ Copied css directory"
    else
        echo "Warning: css directory not found in dotfiles."
    fi

    echo ""
    echo "✅ Firefox userChrome.css installed!"
    echo ""
    echo "⚠️  IMPORTANT: To enable userChrome.css in Firefox:"
    echo "   1. Open Firefox and go to about:config"
    echo "   2. Search for: toolkit.legacyUserProfileCustomizations.stylesheets"
    echo "   3. Set it to: true"
    echo "   4. Restart Firefox"
}

# Main execution
profile=$(find_firefox_profile)

if [ -n "$profile" ]; then
    install_userchrome "$profile"
else
    echo "Firefox profile not found."
    echo ""
    echo "If Firefox is installed, please run it at least once to create a profile,"
    echo "then run this script again."
    echo ""
    echo "Alternatively, you can manually copy the files:"
    echo "  1. Find your Firefox profile directory"
    echo "  2. Create a 'chrome' folder inside it"
    echo "  3. Copy userChrome.css and css/ folder into chrome/"
fi
