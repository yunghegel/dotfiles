#!/bin/bash

# Interactive VPS Setup Script
# Modular installer with installation tracking and software detection

set -e

# =============================================================================
# Configuration
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLERS_DIR="$SCRIPT_DIR/installers"
SETUP_DIR="$SCRIPT_DIR/setup"
STATE_DIR="$HOME/.config/dotfiles"
STATE_FILE="$STATE_DIR/installed.state"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m'

# =============================================================================
# Component Definitions
# =============================================================================

# Format: ID|Name|Category|Script|Detection Command
declare -a COMPONENTS=(
    "system|System Packages|System|installers/01-system.sh|command -v curl && command -v git && command -v fzf"
    "zsh|ZSH & Oh My Zsh|Shell|installers/02-zsh.sh|test -d ~/.oh-my-zsh"
    "dotfiles|Dotfiles (.functions, .aliases)|Shell|setup/12-dotfiles.sh|test -d ~/.functions && test -f ~/.aliases"
    "nodejs|Node.js & NVM|Development|installers/03-nodejs.sh|test -d ~/.nvm"
    "java|Java & SDKMAN|Development|installers/04-java.sh|test -d ~/.sdkman"
    "docker|Docker|Containers|installers/05-docker.sh|command -v docker"
    "redis|Redis|Databases|installers/06-databases.sh|command -v redis-cli"
    "postgresql|PostgreSQL|Databases|installers/06-databases.sh|command -v psql"
    "mariadb|MariaDB|Databases|installers/06-databases.sh|command -v mysql"
    "syncthing|Syncthing|Services|installers/07-syncthing.sh|command -v syncthing"
    "wireguard|WireGuard VPN|Services|installers/08-wireguard.sh|command -v wg"
    "loki|Loki (Logs)|Monitoring|installers/09-monitoring.sh|test -f /usr/local/bin/loki"
    "grafana|Grafana|Monitoring|installers/09-monitoring.sh|command -v grafana-server"
    "pm2|PM2 Process Manager|Services|installers/10-pm2.sh|command -v pm2"
    "neovim|Neovim|Editors|installers/11-nvim.sh|command -v nvim"
    "micro|Micro Editor|Editors|setup/14-micro.sh|command -v micro"
    "firefox-css|Firefox userChrome.css|Setup|setup/13-firefox.sh|find ~/.mozilla/firefox -name userChrome.css 2>/dev/null | grep -q ."
)

# Categories for grouping
declare -a CATEGORIES=(
    "System"
    "Shell"
    "Development"
    "Containers"
    "Databases"
    "Services"
    "Monitoring"
    "Editors"
    "Setup"
)

# =============================================================================
# Utility Functions
# =============================================================================

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_dim() { echo -e "${DIM}$1${NC}"; }

# Initialize state directory and file
init_state() {
    mkdir -p "$STATE_DIR"
    touch "$STATE_FILE"
}

# Check if component is marked as installed in state file
is_marked_installed() {
    local id="$1"
    grep -q "^${id}$" "$STATE_FILE" 2>/dev/null
}

# Mark component as installed
mark_installed() {
    local id="$1"
    if ! is_marked_installed "$id"; then
        echo "$id" >> "$STATE_FILE"
    fi
}

# Check if component is actually installed on system
is_detected() {
    local detection_cmd="$1"
    eval "$detection_cmd" &>/dev/null
}

# Get component field by ID
get_component_field() {
    local id="$1"
    local field="$2"  # 1=id, 2=name, 3=category, 4=script, 5=detection

    for comp in "${COMPONENTS[@]}"; do
        local comp_id=$(echo "$comp" | cut -d'|' -f1)
        if [[ "$comp_id" == "$id" ]]; then
            echo "$comp" | cut -d'|' -f"$field"
            return
        fi
    done
}

# Get all component IDs
get_all_ids() {
    for comp in "${COMPONENTS[@]}"; do
        echo "$comp" | cut -d'|' -f1
    done
}

# Get components by category
get_components_by_category() {
    local category="$1"
    for comp in "${COMPONENTS[@]}"; do
        local comp_cat=$(echo "$comp" | cut -d'|' -f3)
        if [[ "$comp_cat" == "$category" ]]; then
            echo "$comp" | cut -d'|' -f1
        fi
    done
}

# =============================================================================
# Installation Detection
# =============================================================================

# Scan system for installed components
scan_installed() {
    print_status "Scanning for installed components..."

    local detected=0
    local total=${#COMPONENTS[@]}

    for comp in "${COMPONENTS[@]}"; do
        local id=$(echo "$comp" | cut -d'|' -f1)
        local name=$(echo "$comp" | cut -d'|' -f2)
        local detection=$(echo "$comp" | cut -d'|' -f5)

        if is_detected "$detection"; then
            if ! is_marked_installed "$id"; then
                mark_installed "$id"
                print_dim "  Detected: $name"
            fi
            ((detected++)) || true
        fi
    done

    echo ""
    print_status "Found $detected/$total components already installed"
}

# =============================================================================
# Gum Installation
# =============================================================================

check_gum() {
    if ! command -v gum &>/dev/null; then
        print_warning "gum is not installed. Installing gum..."

        if command -v apt-get &>/dev/null; then
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
            echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
            sudo apt-get update && sudo apt-get install -y gum
        elif command -v brew &>/dev/null; then
            brew install gum
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y gum
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm gum
        else
            print_error "Could not install gum. Please install it manually."
            exit 1
        fi
    fi
}

# =============================================================================
# Menu Functions
# =============================================================================

show_header() {
    gum style \
        --foreground "#FF6B6B" \
        --border-foreground "#FF6B6B" \
        --border double \
        --align center \
        --width 60 \
        --margin "1 2" \
        --padding "1 4" \
        "Interactive VPS Setup" \
        "Modular Installation System"
}

show_main_menu() {
    echo "" >&2
    gum choose \
        "Install Components" \
        "View Installed" \
        "Reinstall Component" \
        "Reset Installation State" \
        "Exit"
}

# Build component list for selection, excluding installed
# Returns items one per line
build_available_list() {
    for category in "${CATEGORIES[@]}"; do
        for comp in "${COMPONENTS[@]}"; do
            local id=$(echo "$comp" | cut -d'|' -f1)
            local name=$(echo "$comp" | cut -d'|' -f2)
            local cat=$(echo "$comp" | cut -d'|' -f3)

            if [[ "$cat" == "$category" ]] && ! is_marked_installed "$id"; then
                echo "[$category] $name"
            fi
        done
    done
}

# Build full component list for reinstall
build_full_list() {
    for category in "${CATEGORIES[@]}"; do
        for comp in "${COMPONENTS[@]}"; do
            local id=$(echo "$comp" | cut -d'|' -f1)
            local name=$(echo "$comp" | cut -d'|' -f2)
            local cat=$(echo "$comp" | cut -d'|' -f3)

            if [[ "$cat" == "$category" ]]; then
                local status=""
                if is_marked_installed "$id"; then
                    status=" ✓"
                fi
                echo "[$category] $name$status"
            fi
        done
    done
}

# Get component ID from display name
get_id_from_display() {
    local display="$1"
    # Remove category prefix and status suffix
    local name=$(echo "$display" | sed 's/^\[[^]]*\] //' | sed 's/ ✓$//')

    for comp in "${COMPONENTS[@]}"; do
        local comp_name=$(echo "$comp" | cut -d'|' -f2)
        if [[ "$comp_name" == "$name" ]]; then
            echo "$comp" | cut -d'|' -f1
            return
        fi
    done
}

# =============================================================================
# Component Configuration
# =============================================================================

configure_component() {
    local id="$1"
    local config=""

    case "$id" in
        zsh)
            if gum confirm "Configure ZSH plugins?"; then
                config=$(gum choose --no-limit \
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
                    "pip" | tr '\n' ' ')
            fi
            ;;
        nodejs)
            gum style --foreground "#6BCF7F" "Select Node.js version:"
            config=$(gum choose "18" "20" "21" "22")
            ;;
        java)
            gum style --foreground "#4D96FF" "Select Java version:"
            config=$(gum choose "8" "11" "17" "21")
            ;;
        redis|postgresql|mariadb)
            gum style --foreground "#FFD93D" "Database credentials:"
            local db_user=$(gum input --placeholder "Username" --value "$USER")
            local db_pass=$(gum input --password --placeholder "Password")
            config="$db_user $db_pass $id"
            ;;
        syncthing)
            gum style --foreground "#FF8C42" "Syncthing credentials:"
            local sync_user=$(gum input --placeholder "Username" --value "$USER")
            local sync_pass=$(gum input --password --placeholder "Password")
            config="$sync_user $sync_pass"
            ;;
        neovim)
            gum style --foreground "#88C0D0" "Select Neovim configuration:"
            config=$(gum choose "minimal" "nvchad")
            ;;
    esac

    echo "$config"
}

# =============================================================================
# Installation Execution
# =============================================================================

run_installation() {
    local id="$1"
    local config="$2"

    local name=$(get_component_field "$id" 2)
    local script=$(get_component_field "$id" 4)
    local script_path="$SCRIPT_DIR/$script"

    print_status "Installing $name..."

    # Make script executable
    chmod +x "$script_path"

    # Run installation
    if [[ -n "$config" ]]; then
        "$script_path" $config
    else
        "$script_path"
    fi

    local exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        mark_installed "$id"
        print_status "✅ $name installed successfully!"
        return 0
    else
        print_error "❌ Failed to install $name"
        return 1
    fi
}

# =============================================================================
# Menu Actions
# =============================================================================

action_install() {
    clear
    show_header

    # Build available list into a temp file for gum
    local tmpfile=$(mktemp)
    build_available_list > "$tmpfile"

    if [[ ! -s "$tmpfile" ]]; then
        rm -f "$tmpfile"
        echo ""
        gum style --foreground "#4ECDC4" "All components are already installed!"
        echo ""
        gum input --placeholder "Press Enter to continue..."
        return
    fi

    echo ""
    gum style --foreground "#4ECDC4" "Select components to install:"
    gum style --foreground "#888888" "Use SPACE to select, ENTER to confirm, ESC to cancel"
    echo ""

    # Use gum choose with the temp file
    local selected
    selected=$(cat "$tmpfile" | gum choose --no-limit --height=20)
    local choose_exit=$?
    rm -f "$tmpfile"

    # Check if user cancelled or selected nothing
    if [[ $choose_exit -ne 0 ]] || [[ -z "$selected" ]]; then
        echo ""
        print_warning "No components selected. Returning to menu."
        sleep 1
        return
    fi

    # Collect configurations for selected components
    declare -A configs
    echo ""

    while IFS= read -r display; do
        [[ -z "$display" ]] && continue
        local id=$(get_id_from_display "$display")
        if [[ -n "$id" ]]; then
            configs["$id"]=$(configure_component "$id")
        fi
    done <<< "$selected"

    # Show summary
    echo ""
    gum style --foreground "#FF6B6B" "Installation Summary:"
    while IFS= read -r display; do
        [[ -z "$display" ]] && continue
        echo "  • $display"
    done <<< "$selected"
    echo ""

    if ! gum confirm "Proceed with installation?"; then
        print_warning "Installation cancelled."
        sleep 1
        return
    fi

    # Execute installations
    echo ""
    local success=0
    local failed=0

    while IFS= read -r display; do
        [[ -z "$display" ]] && continue
        local id=$(get_id_from_display "$display")
        if [[ -n "$id" ]]; then
            if run_installation "$id" "${configs[$id]}"; then
                ((success++)) || true
            else
                ((failed++)) || true
            fi
            echo ""
        fi
    done <<< "$selected"

    # Summary
    echo ""
    gum style \
        --foreground "#4ECDC4" \
        --border-foreground "#4ECDC4" \
        --border rounded \
        --padding "1 2" \
        "Installation Complete" \
        "Successful: $success | Failed: $failed" \
        "" \
        "Restart your terminal for changes to take effect"

    echo ""
    gum input --placeholder "Press Enter to continue..."
}

action_view_installed() {
    clear
    show_header
    echo ""
    gum style --foreground "#4ECDC4" "Installed Components:"
    echo ""

    local count=0
    for category in "${CATEGORIES[@]}"; do
        local has_installed=false
        local items=""

        for comp in "${COMPONENTS[@]}"; do
            local id=$(echo "$comp" | cut -d'|' -f1)
            local name=$(echo "$comp" | cut -d'|' -f2)
            local cat=$(echo "$comp" | cut -d'|' -f3)

            if [[ "$cat" == "$category" ]] && is_marked_installed "$id"; then
                items+="    ✓ $name\n"
                has_installed=true
                ((count++)) || true
            fi
        done

        if $has_installed; then
            gum style --foreground "#FFD93D" "  $category:"
            echo -e "$items"
        fi
    done

    if [[ $count -eq 0 ]]; then
        print_dim "  No components installed yet."
    fi

    echo ""
    gum style --foreground "#888888" "Total: $count components"
    echo ""

    gum input --placeholder "Press Enter to continue..."
}

action_reinstall() {
    clear
    show_header
    echo ""
    gum style --foreground "#FF8C42" "Select component to reinstall:"
    gum style --foreground "#888888" "(✓ = currently installed)"
    echo ""

    local tmpfile=$(mktemp)
    build_full_list > "$tmpfile"

    local selected
    selected=$(cat "$tmpfile" | gum choose --height=20)
    local choose_exit=$?
    rm -f "$tmpfile"

    if [[ $choose_exit -ne 0 ]] || [[ -z "$selected" ]]; then
        return
    fi

    local id=$(get_id_from_display "$selected")
    local name=$(get_component_field "$id" 2)

    echo ""
    if gum confirm "Reinstall $name?"; then
        local config=$(configure_component "$id")
        echo ""
        run_installation "$id" "$config"
        echo ""
        gum input --placeholder "Press Enter to continue..."
    fi
}

action_reset_state() {
    clear
    show_header
    echo ""
    gum style --foreground "#FF6B6B" "Warning: Reset Installation State"
    echo ""
    gum style --foreground "#888888" "This will clear the tracking of installed components."
    gum style --foreground "#888888" "Software will NOT be uninstalled."
    gum style --foreground "#888888" "The installer will re-scan on next run."
    echo ""

    if gum confirm "Reset installation state?"; then
        rm -f "$STATE_FILE"
        touch "$STATE_FILE"
        echo ""
        print_status "Installation state has been reset."
        print_status "Components will be re-detected on next run."
    else
        echo ""
        print_warning "Reset cancelled."
    fi

    echo ""
    gum input --placeholder "Press Enter to continue..."
}

# =============================================================================
# Main
# =============================================================================

main() {
    # Initialize
    init_state
    check_gum

    # Make scripts executable
    find "$INSTALLERS_DIR" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    find "$SETUP_DIR" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

    # Scan for already installed components
    scan_installed

    # Main menu loop
    while true; do
        clear
        show_header

        local choice=$(show_main_menu)

        case "$choice" in
            "Install Components")
                action_install
                ;;
            "View Installed")
                action_view_installed
                ;;
            "Reinstall Component")
                action_reinstall
                ;;
            "Reset Installation State")
                action_reset_state
                ;;
            "Exit"|"")
                echo ""
                gum style --foreground "#4ECDC4" "Goodbye! 👋"
                exit 0
                ;;
        esac
    done
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
