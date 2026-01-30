
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

ZSH_THEME="custom"


plugins=(
git
zsh-completions
zsh-autosuggestions
zsh-syntax-highlighting
nvm
sdk
node
gradle
npm
iterm2
scd
node
common-aliases
bun
docker
web-search
fzf
tmux
aliases
autoenv
autojump
nmap
pm2
npm
thefuck
procs
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source /Users/jamie/.rvm/scripts/rvm
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
if [ -d ~/.functions ]; then
    for file in ~/.functions/*.func; do
        if [[ -f $file ]]; then
            source "$file"
        fi
    done
fi
source $HOME/.env
source $HOME/.aliases
source $HOME/.paths
export EDITOR=code
export PYTHONPATH="/Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages:$PYTHONPATH"
export PATH="/Users/jamie/.bun/bin:$PATH"
source "$HOME/.sdkman/bin/sdkman-init.sh"
eval "$(/opt/homebrew/bin/brew shellenv)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"


