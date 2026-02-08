# Shell Functions Reference

A comprehensive guide to all custom shell functions included in this dotfiles configuration.

## Table of Contents

1. [Overview](#overview)
2. [File and Directory Operations](#file-and-directory-operations)
3. [System Information](#system-information)
4. [Development Utilities](#development-utilities)
5. [Network and Web](#network-and-web)
6. [Text and Data Processing](#text-and-data-processing)
7. [Navigation with FZF](#navigation-with-fzf)
8. [AI Integration](#ai-integration)
9. [Miscellaneous](#miscellaneous)

---

## Overview

Functions are stored in `~/.functions/` as `.func` files. They are automatically loaded by `load_functions.sh` when your shell starts.

### Loading Functions

Functions are sourced automatically. To reload after changes:
```bash
source ~/.functions/load_functions.sh
```

---

## File and Directory Operations

### mkcd - Make and Change Directory

Create a directory and immediately cd into it.

```bash
mkcd project/subdir
# Creates project/subdir and changes into it
```

### backup - Timestamped Backups

Create a backup copy with timestamp.

```bash
backup important-file.txt
# Creates important-file.txt.backup.20240208143022

backup /path/to/directory
# Creates directory.backup.20240208143022
```

### extract / unz - Smart Archive Extraction

Automatically detect and extract various archive formats.

```bash
extract archive.tar.gz
extract file.zip
extract package.7z

# Supported formats:
# .tar.gz, .tgz, .tar.bz2, .tbz2, .tar.xz
# .zip, .rar, .7z, .gz, .bz2, .xz
```

### write_file - Write Content to File

Write content to a file, creating directories if needed.

```bash
write_file "Hello World" path/to/file.txt
```

### rename_files - Batch Rename

Rename multiple files with patterns.

```bash
rename_files "*.jpeg" ".jpeg" ".jpg"
# Renames all .jpeg files to .jpg
```

### trash - Safe Delete

Move files to trash instead of permanent deletion.

```bash
trash unwanted-file.txt
# Moves to ~/.Trash/ or system trash
```

---

## System Information

### sysinfo / system_summary - System Overview

Display comprehensive system information.

```bash
sysinfo
# Output:
# OS: macOS 14.0
# Kernel: Darwin 23.0.0
# CPU: Apple M1 Pro
# Memory: 16GB (8GB used)
# Uptime: 5 days, 3 hours
```

### lsports - List Open Ports

Show all listening ports and their processes.

```bash
lsports
# Output:
# PORT    PID     PROCESS
# 3000    12345   node
# 5432    6789    postgres
# 8080    11111   java
```

### dusage - Disk Usage Analysis

Analyze disk usage with various options.

```bash
dusage              # Top 10 largest items in current dir
dusage 20           # Top 20 largest items
dusage -d 2         # Analyze 2 levels deep
dusage /path        # Analyze specific path
```

### cleanup - System Cleanup

Clean up temporary files and caches.

```bash
cleanup
# Removes:
# - Temporary files
# - Cache directories
# - Old logs
# - .DS_Store files (macOS)
```

---

## Development Utilities

### serve - Quick HTTP Server

Start a simple HTTP server in current directory.

```bash
serve
# Serving on http://localhost:8000

serve 3000
# Serving on http://localhost:3000
```

### json - Pretty Print JSON

Format and colorize JSON output.

```bash
json file.json
# Pretty prints file.json

cat data.json | json
# Pretty prints from stdin

curl api.example.com | json
# Pretty prints API response
```

### makescript - Create Executable Script

Create a new script file with proper structure.

```bash
makescript myscript
# Creates executable script with shebang

makescript myscript.py
# Creates Python script
```

### killport - Kill Process on Port

Kill whatever process is using a specific port.

```bash
killport 3000
# Kills process using port 3000
```

### quickserver - Quick Development Server

Start various types of development servers.

```bash
quickserver           # Python HTTP server on 8000
quickserver php       # PHP built-in server
quickserver node      # Node.js http-server
```

### git-cleanup - Clean Git Branches

Remove merged and stale branches.

```bash
git-cleanup
# Removes branches already merged to main
# Prompts before deleting
```

### gclone - Quick Git Clone

Clone and cd into repository.

```bash
gclone https://github.com/user/repo
# Clones and changes into repo directory

gclone user/repo
# Clones from GitHub shorthand
```

### mk-kts - Kotlin Script Setup

Create a Kotlin script with proper setup.

```bash
mk-kts script-name
# Creates script-name.kts with headers
```

---

## Network and Web

### weather - Weather Forecast

Get weather for a location.

```bash
weather
# Weather for current location (IP-based)

weather "New York"
# Weather for New York

weather Tokyo
# Weather for Tokyo
```

### crypto - Cryptocurrency Prices

Look up cryptocurrency prices.

```bash
crypto bitcoin
# Current Bitcoin price in USD

crypto ethereum eur
# Ethereum price in EUR

crypto btc,eth,sol
# Multiple coins
```

### qr - Generate QR Codes

Generate QR codes in terminal.

```bash
qr "https://example.com"
# Displays QR code for URL

qr "WiFi:S:MyNetwork;T:WPA;P:password;;"
# WiFi QR code
```

### url_encode / url_decode - URL Encoding

Encode and decode URLs.

```bash
url_encode "hello world"
# hello%20world

url_decode "hello%20world"
# hello world
```

---

## Text and Data Processing

### define - Manage Environment Variables

Manage variables in your .env file.

```bash
define API_KEY "secret123"
# Adds API_KEY=secret123 to .env

define API_KEY
# Shows current value of API_KEY

define --list
# Lists all defined variables
```

### append - Append to Files

Append content to a file.

```bash
append "new line" file.txt
# Adds "new line" to end of file.txt

echo "content" | append file.txt
# Append from stdin
```

### searchhist - Search Command History

Search through shell command history.

```bash
searchhist docker
# Shows all commands containing 'docker'

searchhist "git commit"
# Shows all git commit commands
```

### hist-top - Most Used Commands

Show your most frequently used commands.

```bash
hist-top
# Top 10 most used commands

hist-top 20
# Top 20 most used commands
```

### previewmd - Markdown Preview

Preview markdown files in terminal.

```bash
previewmd README.md
# Renders markdown with formatting
```

---

## Navigation with FZF

These functions provide fuzzy-finding navigation using FZF.

### Ctrl+T - File Search

Press `Ctrl+T` to fuzzy search files and insert selection.

```bash
vim <Ctrl+T>
# Opens FZF, selected file is inserted
# vim path/to/selected/file.txt
```

### Ctrl+R - History Search

Press `Ctrl+R` for fuzzy command history search.

```bash
<Ctrl+R>
# Fuzzy search through command history
# Select to insert command
```

### Alt+C - Directory Navigation

Press `Alt+C` to fuzzy search and cd to directory.

```bash
<Alt+C>
# Fuzzy search directories
# Changes to selected directory
```

### f - FZF Directory Finder

Quick directory finder with cd.

```bash
f
# Opens FZF for directory selection
# Changes to selected directory
```

### FZF Completion

Tab completion enhanced with FZF:

```bash
ssh **<Tab>       # FZF through SSH hosts
kill **<Tab>      # FZF through processes
export **<Tab>    # FZF through environment variables
cd **<Tab>        # FZF through directories
```

---

## AI Integration

### Gemini AI Functions

Integration with Google's Gemini AI models.

**Available Models:**
| Alias | Model |
|-------|-------|
| `flash-lite` | gemini-2.5-flash-lite-preview-02-05 |
| `pro` | gemini-2.5-pro-exp-03-25 |
| `flash` | gemini-2.5-flash-preview-04-17 |

**Usage:**

```bash
# Quick query
flash-lite "Explain Docker in simple terms"

# Interactive mode
pro
# Opens interactive chat session

# Pipe content
cat code.py | flash "Review this code"

# With specific model
flash "Write a bash script to..."
```

**Configuration:**

Set default model in `~/.env`:
```bash
GEMINI_MODEL=gemini-2.5-pro
```

Set custom system prompt:
```bash
AI_SYSTEM_PROMPT="You are a helpful coding assistant"
```

---

## Miscellaneous

### password - Generate Passwords

Generate random secure passwords.

```bash
password
# Generates 16-character password

password 32
# Generates 32-character password

password 24 -s
# 24-char password with special characters
```

### stopwatch - Simple Stopwatch

Start a terminal stopwatch.

```bash
stopwatch
# Starts counting
# Press Ctrl+C to stop
```

### countdown - Countdown Timer

Set a countdown timer.

```bash
countdown 5m
# 5 minute countdown

countdown 1h30m
# 1 hour 30 minute countdown

countdown 90s
# 90 second countdown
```

### timer - Simple Timer

Quick timer with notification.

```bash
timer 5
# Waits 5 seconds, then notifies
```

### take - Create and Enter Directory

Like mkcd, create directory and cd into it.

```bash
take new-project
# mkdir -p new-project && cd new-project
```

### exists - Check Command Exists

Check if a command is available.

```bash
exists docker && echo "Docker installed"
exists nonexistent || echo "Not found"
```

### cht.sh - Cheatsheet Lookup

Look up command cheatsheets.

```bash
cht.sh curl
# Shows curl examples and usage

cht.sh python/requests
# Python requests library examples

cht.sh git~rebase
# Git rebase help
```

### path-show - Display PATH

Show PATH entries one per line.

```bash
path-show
# /usr/local/bin
# /usr/bin
# /bin
# ...
```

### path-add - Add to PATH

Add directory to PATH.

```bash
path-add /opt/custom/bin
# Adds to PATH for current session

path-add /opt/custom/bin --persist
# Also adds to ~/.paths for future sessions
```

---

## Creating Custom Functions

### File Location

Add new functions to `~/.functions/` with `.func` extension.

### Function Template

```bash
# ~/.functions/myfunction.func

# Description of what this function does
myfunction() {
    local arg1="${1:-default}"

    if [[ -z "$arg1" ]]; then
        echo "Usage: myfunction <argument>"
        return 1
    fi

    # Function logic here
    echo "Doing something with $arg1"
}
```

### Best Practices

1. Use `local` for variables to avoid pollution
2. Provide usage help with `-h` or `--help`
3. Return appropriate exit codes
4. Add comments describing purpose
5. Handle missing arguments gracefully
