# ZSH Shell Guide

A guide to the ZSH shell configuration, Oh My Zsh framework, and custom themes.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Plugins](#plugins)
4. [Themes](#themes)
5. [Configuration](#configuration)
6. [Tips and Tricks](#tips-and-tricks)

---

## Overview

ZSH (Z Shell) is an extended Bourne shell with many improvements:
- Better tab completion
- Spelling correction
- Shared command history
- Themeable prompts
- Plugin ecosystem via Oh My Zsh

---

## Installation

Run the installer:
```bash
./installers/02-zsh.sh [plugins...]
```

**What gets installed:**
- ZSH shell
- Oh My Zsh framework
- Selected plugins
- Custom theme

---

## Plugins

### Default Plugins

| Plugin | Description |
|--------|-------------|
| `git` | Git aliases and functions |
| `zsh-syntax-highlighting` | Syntax coloring as you type |
| `zsh-autosuggestions` | Fish-like history suggestions |
| `zsh-completions` | Extended completion definitions |

### Optional Plugins

| Plugin | Description |
|--------|-------------|
| `zsh-history-substring-search` | Search history with arrow keys |
| `fast-syntax-highlighting` | Faster syntax highlighting |
| `nvm` | Node Version Manager integration |
| `sdk` | SDKMAN integration |
| `docker` | Docker completions and aliases |
| `command-not-found` | Suggest package installations |
| `sudo` | Press Esc twice to add sudo |
| `pip` | Python pip completions |

### Plugin Usage Examples

**git plugin aliases:**
```bash
gst          # git status
gco          # git checkout
gcm          # git checkout main
gp           # git push
gl           # git pull
gd           # git diff
ga           # git add
gcmsg        # git commit -m
glog         # git log --oneline --graph
```

**sudo plugin:**
- Press `Esc` twice to prefix current command with `sudo`

**autosuggestions:**
- Type and see gray suggestions from history
- Press `→` (right arrow) to accept
- Press `Ctrl+→` to accept word by word

---

## Themes

### Custom Theme (custom.zsh-theme)

```
 ~/development/project (main) jamie@host                    14:30:25
$
```

**Features:**
- Blue OS icon
- Orange directory path
- Green Git branch in parentheses
- Right-side: username@host and timestamp
- Lock icon for read-only directories

### Oracle Theme (theme.zsh-theme)

Similar layout with Oracle branding (red icon).

### Installing a Theme

Themes are copied to `~/.oh-my-zsh/custom/themes/`.

Edit `~/.zshrc` to change theme:
```bash
ZSH_THEME="custom"
```

### Theme Components

| Component | Description |
|-----------|-------------|
| `%~` | Current directory (~ for home) |
| `%n` | Username |
| `%m` | Hostname |
| `%T` | Time (24-hour) |
| `%D{%H:%M:%S}` | Time with seconds |
| `$(git_prompt_info)` | Git branch and status |

---

## Configuration

### Key Files

| File | Purpose |
|------|---------|
| `~/.zshrc` | Main configuration |
| `~/.zprofile` | Login shell config |
| `~/.zshenv` | Environment variables |
| `~/.oh-my-zsh/` | Oh My Zsh installation |

### Common .zshrc Settings

```bash
# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY          # Share between sessions
setopt HIST_IGNORE_DUPS       # No duplicate entries
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space

# Directory navigation
setopt AUTO_CD                # cd without typing cd
setopt AUTO_PUSHD             # Push directories to stack
setopt PUSHD_IGNORE_DUPS      # No duplicates in stack

# Completion
setopt COMPLETE_IN_WORD       # Complete from cursor position
setopt ALWAYS_TO_END          # Move cursor to end after complete

# Correction
setopt CORRECT                # Correct command spelling
setopt CORRECT_ALL            # Correct all arguments
```

### Adding Custom Paths

Edit `~/.paths` (created by dotfiles installer):
```bash
/opt/custom/bin
$HOME/scripts
```

These are automatically added to PATH.

---

## Tips and Tricks

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+A` | Move to beginning of line |
| `Ctrl+E` | Move to end of line |
| `Ctrl+U` | Clear line before cursor |
| `Ctrl+K` | Clear line after cursor |
| `Ctrl+W` | Delete word before cursor |
| `Alt+B` | Move back one word |
| `Alt+F` | Move forward one word |
| `Tab` | Autocomplete |
| `Tab Tab` | Show all completions |

### Directory Navigation

```bash
# Quick directory changes
cd -              # Previous directory
cd ~              # Home directory
cd ..             # Parent directory
cd ../..          # Two levels up

# Directory stack
pushd /path       # Push and change
popd              # Pop and change back
dirs -v           # Show stack with numbers
cd ~2             # Jump to stack entry 2

# With AUTO_CD enabled
..                # Same as cd ..
~/projects        # Same as cd ~/projects
```

### Globbing (Pattern Matching)

```bash
# Basic patterns
*.txt             # All .txt files
**/*.js           # Recursive .js files
file?.txt         # file1.txt, fileA.txt, etc.

# Advanced (extended glob)
ls *(.)           # Files only
ls *(/)           # Directories only
ls *(@)           # Symlinks only
ls *(m-7)         # Modified in last 7 days
ls *(Lk+100)      # Larger than 100KB
ls *(om[1,5])     # 5 most recent
```

### History Expansion

```bash
!!                # Last command
!$                # Last argument of last command
!*                # All arguments of last command
!-2               # Command before last
!grep             # Last command starting with grep
^old^new          # Replace 'old' with 'new' in last command
```

### Useful Aliases to Add

```bash
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Listing
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Git shortcuts
alias gs='git status'
alias gc='git commit'
alias gp='git push'
```

---

## Troubleshooting

### Slow Startup

Check startup time:
```bash
time zsh -i -c exit
```

Profile your config:
```bash
zsh -xv 2>&1 | ts -i "%.s" > zsh_startup.log
```

Common fixes:
- Lazy-load NVM/SDKMAN
- Reduce number of plugins
- Use `fast-syntax-highlighting` instead of `zsh-syntax-highlighting`

### Plugin Not Working

1. Check if installed:
   ```bash
   ls ~/.oh-my-zsh/custom/plugins/
   ```

2. Verify in `.zshrc`:
   ```bash
   plugins=(git zsh-autosuggestions ...)
   ```

3. Reload config:
   ```bash
   source ~/.zshrc
   ```

### Theme Not Appearing

1. Check theme exists:
   ```bash
   ls ~/.oh-my-zsh/custom/themes/
   ```

2. Verify ZSH_THEME in `.zshrc`

3. Ensure terminal supports colors:
   ```bash
   echo $TERM
   # Should be xterm-256color or similar
   ```
