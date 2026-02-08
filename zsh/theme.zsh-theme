local col_brand="%F{33}"        # blue for Oracle icon and user/host
local col_oracle="%F{196}"       # red for Oracle icon
local col_dir="%F{110}"         # orange (directory text)
local col_time="%F{144}"        # pastel yellow
local col_git="%F{150}"         # pastel green
local col_lock="%F{196}"        # red for the lock icon
local col_reset="%f"

# --- Icons and Functions ---

# Oracle-branded icon
function prompt_dir_icon() {
    echo "%B%{$col_oracle%}%{$col_reset%}%b"
}

# Display a lock icon if the current directory is not writable
function prompt_lock_icon() {
  if [[ ! -w . ]]; then
    echo "%{$col_lock%}%{$col_reset%}" # Unicode lock icon
  fi
}

# Git status helper
function prompt_git_status() {
  local branch dirty
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
    dirty=$(git status --porcelain 2>/dev/null)
    if [[ -n $dirty ]]; then
      echo "%{$col_git%}$branch*%{$col_reset%}"
    else
      echo "%{$col_git%}$branch%{$col_reset%}"
    fi
  fi
}

# --- Prompt Structure ---

# Left prompt: bold OS_ICON + lock_icon + bold dir + user:host
PROMPT='$(prompt_dir_icon) $(prompt_lock_icon) %B%{$col_dir%}%~%{$col_reset%}%b [%{$col_brand%}%n:%m%{$col_reset%}] $ '

# Right prompt: [time git_branch]
RPROMPT='[%{$col_time%}%*%{$col_reset%} $(prompt_git_status)]'%