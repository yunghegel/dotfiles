# reload-shell.plugin.zsh
# Reloads the shell context with Ctrl+R
# Overrides the default reverse history search binding

_reload_shell() {
  echo ""
  echo "  reloading shell..."

  local configs=(
    "$ZDOTDIR/.zshenv"
    "$ZDOTDIR/.zprofile"
    "$ZDOTDIR/.zshrc"
    "$ZDOTDIR/.zlogin"
  )

  # Fall back to $HOME if ZDOTDIR is not set
  if [[ -z "$ZDOTDIR" ]]; then
    configs=(
      "$HOME/.zshenv"
      "$HOME/.zprofile"
      "$HOME/.zshrc"
      "$HOME/.zlogin"
    )
  fi

  for config in "${configs[@]}"; do
    if [[ -f "$config" ]]; then
      source "$config"
    fi
  done

  zle reset-prompt
}

zle -N _reload_shell
bindkey '^R' _reload_shell
