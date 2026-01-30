# color definitions
local col_win="%F{33}"          # blue
local col_linux="%F{208}"       # orange
local col_dir="%F{110}"         # orange (directory text)
local col_userhost="%F{120}"    # light green
local col_time="%F{144}"        # pastel yellow
local col_git="%F{150}"         # pastel green
local col_lock="%F{196}"        # red for the lock icon
local col_reset="%f"


function prompt_dir_icon() {
    echo "%B%{$col_linux%}%{$col_reset%}%b"
}

# Function to check directory permissions and display a lock icon
function prompt_lock_icon() {
  if [[ ! -w . ]]; then
    echo "%{$col_lock%}%{$col_reset%}" # Unicode lock icon
  fi
}

# git status helper
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

# left prompt: bold OS_ICON + lock_icon + bold dir + user:host
PROMPT='$(prompt_dir_icon) $(prompt_lock_icon) %B%{$col_dir%}%~%{$col_reset%}%b [%{$col_userhost%}%n:%m%{$col_reset%}] $ '

# right prompt: [time gitbranch]
RPROMPT='[%{$col_time%}%*%{$col_reset%} $(prompt_git_status)]'