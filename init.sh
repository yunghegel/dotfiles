#!/bin/bash

# Interactive VPS Setup Script
# This script uses gum for interactive component selection and installation

set -e

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_DIR="$SCRIPT_DIR/init.d"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if gum is installed
check_gum() {
    if ! command -v gum &> /dev/null; then
        print_warning "gum is not installed. Installing gum..."
        
        # Install gum based on the system
        if command -v apt-get &> /dev/null; then
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt-get update && sudo apt-get install -y gum
        elif command -v brew &> /dev/null; then
            brew install gum
        else
            print_error "Could not install gum. Please install it manually."
            exit 1
        fi
    fi
}

# Make scripts executable
make_scripts_executable() {
    print_status "Making scripts executable..."
    find "$INIT_DIR" -name "*.sh" -exec chmod +x {} \;
}

# Component selection functions
select_components() {
    gum style \
        --foreground "#FF6B6B" \
        --border-foreground "#FF6B6B" \
        --border double \
        --align center \
        --width 60 \
        --margin "1 2" \
        --padding "2 4" \
        "🚀 Interactive VPS Setup" \
        "Select the components you want to install"

    local components
    components=$(gum choose --no-limit \
        "System Update & Base Packages" \
        "ZSH & Oh My Zsh" \
        "Dotfiles (.functions, .aliases)" \
        "Neovim" \
        "Micro Editor" \
        "Firefox userChrome.css" \
        "Node.js & NVM" \
        "Java & SDKMAN" \
        "Docker" \
        "Databases (Redis, PostgreSQL, MariaDB)" \
        "Syncthing (File Sync)" \
        "WireGuard (VPN)" \
        "Monitoring (Loki & Grafana)" \
        "PM2 (Process Manager)")

    echo "$components"
}

# ZSH plugin selection
select_zsh_plugins() {
    gum style --foreground "#4ECDC4" "Select ZSH plugins to install:"
    
    local plugins
    plugins=$(gum choose --no-limit \
        "git" \
        "zsh-syntax-highlighting" \
        "zsh-autosuggestions" \
        "zsh-completions" \
        "zsh-history-substring-search" \
        "fast-syntax-highlighting" \
        "nvm" \
        "sdk" \
        "docker" \
        "command-not-found" \
        "sudo" \
        "pip")
    
    echo "$plugins"
}

# Database selection
select_databases() {
    gum style --foreground "#FFD93D" "Select databases to install:"
    
    local databases
    databases=$(gum choose --no-limit \
        "redis" \
        "postgresql" \
        "mariadb")
    
    echo "$databases"
}

# Node.js version selection
select_node_version() {
    gum style --foreground "#6BCF7F" "Select Node.js version:"
    
    gum choose \
        "18" \
        "20" \
        "21" \
        "22"
}

# Java version selection
select_java_version() {
    gum style --foreground "#4D96FF" "Select Java version:"
    
    gum choose \
        "8" \
        "11" \
        "17" \
        "21"
}

# Get database credentials
get_database_credentials() {
    gum style --foreground "#FFD93D" "Enter database credentials:"
    
    local db_user
    local db_pass
    
    db_user=$(gum input --placeholder "Database username" --value "$USER")
    db_pass=$(gum input --password --placeholder "Database password")
    
    echo "$db_user $db_pass"
}

# Get Syncthing credentials
get_syncthing_credentials() {
    gum style --foreground "#FF8C42" "Enter Syncthing credentials:"
    
    local sync_user
    local sync_pass
    
    sync_user=$(gum input --placeholder "Syncthing username" --value "$USER")
    sync_pass=$(gum input --password --placeholder "Syncthing password")
    
    echo "$sync_user $sync_pass"
}

# Execute component installations
run_component() {
    local component="$1"
    shift
    local args="$@"
    
    case "$component" in
        "System Update & Base Packages")
            print_status "Running system update..."
            "$INIT_DIR/01-system.sh"
            ;;
        "ZSH & Oh My Zsh")
            print_status "Installing ZSH with selected plugins..."
            "$INIT_DIR/02-zsh.sh" $args
            ;;
        "Node.js & NVM")
            print_status "Installing Node.js version $args..."
            "$INIT_DIR/03-nodejs.sh" $args
            ;;
        "Java & SDKMAN")
            print_status "Installing Java version $args..."
            "$INIT_DIR/04-java.sh" $args
            ;;
        "Docker")
            print_status "Installing Docker..."
            "$INIT_DIR/05-docker.sh"
            ;;
        "Databases (Redis, PostgreSQL, MariaDB)")
            print_status "Installing selected databases..."
            "$INIT_DIR/06-databases.sh" $args
            ;;
        "Syncthing (File Sync)")
            print_status "Installing Syncthing..."
            "$INIT_DIR/07-syncthing.sh" $args
            ;;
        "WireGuard (VPN)")
            print_status "Installing WireGuard..."
            "$INIT_DIR/08-wireguard.sh"
            ;;
        "Monitoring (Loki & Grafana)")
            print_status "Installing monitoring stack..."
            "$INIT_DIR/09-monitoring.sh"
            ;;
        "PM2 (Process Manager)")
            print_status "Installing PM2..."
            "$INIT_DIR/10-pm2.sh"
            ;;
        "Neovim")
            print_status "Installing Neovim..."
            "$INIT_DIR/11-nvim.sh"
            ;;
        "Dotfiles (.functions, .aliases)")
            print_status "Installing dotfiles..."
            "$INIT_DIR/12-dotfiles.sh"
            ;;
        "Firefox userChrome.css")
            print_status "Installing Firefox userChrome.css..."
            "$INIT_DIR/13-firefox.sh"
            ;;
        "Micro Editor")
            print_status "Installing Micro editor..."
            "$INIT_DIR/14-micro.sh"
            ;;
        *)
            print_warning "Unknown component: $component"
            ;;
    esac
}

# Main execution
main() {
    # Check requirements
    check_gum
    make_scripts_executable
    
    # Component selection
    local selected_components
    selected_components=$(select_components)
    
    if [ -z "$selected_components" ]; then
        print_warning "No components selected. Exiting."
        exit 0
    fi
    
    # Store component-specific configurations
    local zsh_plugins=""
    local node_version=""
    local java_version=""
    local databases=""
    local db_credentials=""
    local sync_credentials=""
    
    # Get configuration for selected components
    while IFS= read -r component; do
        case "$component" in
            "ZSH & Oh My Zsh")
                if gum confirm "Configure ZSH plugins?"; then
                    zsh_plugins=$(select_zsh_plugins)
                fi
                ;;
            "Node.js & NVM")
                node_version=$(select_node_version)
                ;;
            "Java & SDKMAN")
                java_version=$(select_java_version)
                ;;
            "Databases (Redis, PostgreSQL, MariaDB)")
                databases=$(select_databases)
                if [ -n "$databases" ]; then
                    db_credentials=$(get_database_credentials)
                fi
                ;;
            "Syncthing (File Sync)")
                sync_credentials=$(get_syncthing_credentials)
                ;;
        esac
    done <<< "$selected_components"
    
    # Confirmation
    gum style --foreground "#FF6B6B" "Installation Summary:"
    echo "$selected_components" | while IFS= read -r component; do
        echo "  ✓ $component"
    done
    
    if ! gum confirm "Proceed with installation?"; then
        print_warning "Installation cancelled."
        exit 0
    fi
    
    # Execute installations
    print_status "Starting component installations..."
    
    while IFS= read -r component; do
        case "$component" in
            "ZSH & Oh My Zsh")
                run_component "$component" "$zsh_plugins"
                ;;
            "Node.js & NVM")
                run_component "$component" "$node_version"
                ;;
            "Java & SDKMAN")
                run_component "$component" "$java_version"
                ;;
            "Databases (Redis, PostgreSQL, MariaDB)")
                run_component "$component" "$db_credentials" "$databases"
                ;;
            "Syncthing (File Sync)")
                run_component "$component" "$sync_credentials"
                ;;
            *)
                run_component "$component"
                ;;
        esac
        
        if [ $? -eq 0 ]; then
            print_status "✅ $component installed successfully!"
        else
            print_error "❌ Failed to install $component"
        fi
    done <<< "$selected_components"
    
    # Final message
    gum style \
        --foreground "#4ECDC4" \
        --border-foreground "#4ECDC4" \
        --border double \
        --align center \
        --width 60 \
        --margin "1 2" \
        --padding "2 4" \
        "🎉 Installation Complete!" \
        "Your VPS setup is ready!" \
        "" \
        "Please restart your terminal or re-login" \
        "to ensure all changes take effect."
}

# Run main function
main "$@"
