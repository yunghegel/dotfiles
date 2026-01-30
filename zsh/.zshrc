# ZSH Configuration
# Portable configuration for VPS/development environments

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="custom"

# Plugins - core plugins for development
plugins=(
    git
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    fzf
    tmux
    command-not-found
    sudo
)

# Conditionally add plugins if their tools are installed
command -v nvm &>/dev/null && plugins+=(nvm)
command -v sdk &>/dev/null && plugins+=(sdk)
command -v npm &>/dev/null && plugins+=(npm)
command -v pm2 &>/dev/null && plugins+=(pm2)

# Completions setup
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load custom functions
if [ -d ~/.functions ]; then
    for file in ~/.functions/*.func; do
        [ -f "$file" ] && source "$file"
    done
fi

# Load aliases
[ -f ~/.aliases ] && source ~/.aliases

# Load environment variables
[ -f ~/.env ] && source ~/.env

# Load custom paths
[ -f ~/.paths ] && source ~/.paths

# Editor preference: nvim > vim > nano
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
    alias vim=nvim
elif command -v vim &>/dev/null; then
    export EDITOR=vim
else
    export EDITOR=nano
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# SDKMAN (Java/Kotlin/Gradle)
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Homebrew (macOS)
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
