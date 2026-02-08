# Micro Editor Guide

A guide to the Micro text editor - a modern, intuitive terminal-based editor.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Basic Usage](#basic-usage)
4. [Keybindings](#keybindings)
5. [Commands](#commands)
6. [Plugins](#plugins)
7. [Configuration](#configuration)
8. [Tips and Tricks](#tips-and-tricks)

---

## Overview

Micro is a modern terminal text editor that aims to be:
- **Easy to use** - Familiar keybindings (Ctrl+S, Ctrl+C, etc.)
- **Intuitive** - Works like you'd expect from a graphical editor
- **Powerful** - Syntax highlighting, plugin system, LSP support
- **Portable** - Single binary, no dependencies

Think of it as nano with superpowers, or a terminal version of Sublime Text.

---

## Installation

Run the setup script:
```bash
./setup/14-micro.sh
```

**What gets installed:**
- Micro editor binary
- Custom plugins (quoter, detectindent, lsp, filemanager, fzf, bounce)
- Monokai-dark color scheme
- Default configuration

**Manual installation:**
```bash
# macOS
brew install micro

# Linux
curl https://getmic.ro | bash
```

---

## Basic Usage

### Opening Files

```bash
# Open file
micro filename.txt

# Open multiple files
micro file1.txt file2.txt

# Open at specific line
micro +25 filename.txt

# Create new file
micro newfile.txt

# Read from stdin
cat file.txt | micro
```

### First Steps

When you open Micro, you'll see:
- The file content in the main area
- A status bar at the bottom with filename, cursor position, etc.
- Familiar keyboard shortcuts work as expected

---

## Keybindings

### File Operations

| Keybinding | Action |
|------------|--------|
| `Ctrl+S` | Save |
| `Ctrl+O` | Open file |
| `Ctrl+Q` | Quit |
| `Ctrl+Shift+S` | Save as |

### Editing

| Keybinding | Action |
|------------|--------|
| `Ctrl+Z` | Undo |
| `Ctrl+Y` | Redo |
| `Ctrl+C` | Copy |
| `Ctrl+X` | Cut |
| `Ctrl+V` | Paste |
| `Ctrl+D` | Duplicate line |
| `Ctrl+K` | Delete line |
| `Tab` | Indent |
| `Shift+Tab` | Unindent |
| `Ctrl+/` | Toggle comment |

### Selection

| Keybinding | Action |
|------------|--------|
| `Shift+Arrow` | Extend selection |
| `Ctrl+A` | Select all |
| `Ctrl+Shift+Arrow` | Select word |
| `Alt+Shift+Up/Down` | Multi-cursor |

### Navigation

| Keybinding | Action |
|------------|--------|
| `Ctrl+G` | Go to line |
| `Ctrl+F` | Find |
| `Ctrl+N` | Find next |
| `Ctrl+P` | Find previous |
| `Ctrl+H` | Find and replace |
| `Ctrl+Home` | Go to start |
| `Ctrl+End` | Go to end |
| `Ctrl+Left/Right` | Move by word |
| `Home` | Start of line |
| `End` | End of line |
| `PageUp/Down` | Scroll page |

### Buffers and Splits

| Keybinding | Action |
|------------|--------|
| `Ctrl+E` | Command bar |
| `Ctrl+W` | Next buffer |
| `Ctrl+Shift+W` | Previous buffer |
| `Ctrl+T` | New tab |
| `Alt+,` | Previous tab |
| `Alt+.` | Next tab |

### View

| Keybinding | Action |
|------------|--------|
| `Ctrl+R` | Toggle ruler |
| `Ctrl+L` | Toggle line numbers |

---

## Commands

Press `Ctrl+E` to open the command bar. Type commands and press Enter.

### File Commands

| Command | Description |
|---------|-------------|
| `save` | Save current buffer |
| `save filename` | Save as filename |
| `open filename` | Open file |
| `quit` | Close current buffer |
| `quit!` | Force quit without saving |
| `quitall` | Quit all buffers |

### Editing Commands

| Command | Description |
|---------|-------------|
| `replace "old" "new"` | Replace in selection |
| `replaceall "old" "new"` | Replace all in file |
| `goto 25` | Go to line 25 |
| `goto 25:10` | Go to line 25, column 10 |

### View Commands

| Command | Description |
|---------|-------------|
| `vsplit filename` | Vertical split |
| `hsplit filename` | Horizontal split |
| `tab filename` | Open in new tab |
| `tabswitch 2` | Switch to tab 2 |

### Settings Commands

| Command | Description |
|---------|-------------|
| `set tabsize 4` | Set tab size |
| `set colorscheme monokai-dark` | Change color scheme |
| `set syntax on` | Enable syntax highlighting |
| `showkey` | Show keybinding for action |
| `help` | Open help |

### Plugin Commands

| Command | Description |
|---------|-------------|
| `plugin list` | List installed plugins |
| `plugin install name` | Install plugin |
| `plugin remove name` | Remove plugin |
| `plugin update` | Update all plugins |

---

## Plugins

### Installed Plugins

This configuration includes these plugins:

**quoter** - Smart quote insertion
- Auto-pairs quotes and brackets
- Type closing quote to skip over it

**detectindent** - Auto-detect indentation
- Automatically matches file's indent style
- Detects tabs vs spaces

**lsp** - Language Server Protocol
- Code completion
- Go to definition
- Hover documentation
- Diagnostics

**filemanager** - File tree sidebar
- Browse files without leaving editor
- Create, rename, delete files

**fzf** - Fuzzy file finder
- Quick file opening with fuzzy search

**bounce** - Bracket matching
- Jump between matching brackets

**monokai-dark** / **gotham-colors** - Color schemes

### Using the File Manager

| Keybinding | Action |
|------------|--------|
| `Ctrl+E` then `tree` | Toggle file tree |
| `Enter` | Open file/toggle folder |
| `n` | New file |
| `N` | New directory |
| `d` | Delete |
| `r` | Rename |

### Using FZF

```
Ctrl+E then: fzf
```
This opens fuzzy finder to quickly open files.

### Using LSP

The LSP plugin provides IDE-like features:

| Feature | How to Use |
|---------|------------|
| Completion | Type and suggestions appear |
| Go to Definition | `Ctrl+E` then `lsp goto` |
| Hover | `Ctrl+E` then `lsp hover` |
| Format | `Ctrl+E` then `lsp format` |

---

## Configuration

### Configuration Files

| File | Purpose |
|------|---------|
| `~/.config/micro/settings.json` | Editor settings |
| `~/.config/micro/bindings.json` | Custom keybindings |
| `~/.config/micro/colorschemes/` | Custom color schemes |
| `~/.config/micro/plug/` | Installed plugins |

### Default Settings

```json
{
    "colorscheme": "monokai-dark",
    "tabsize": 4,
    "tabstospaces": true,
    "autoindent": true,
    "syntax": true,
    "saveundo": true,
    "scrollbar": true,
    "rmtrailingws": true
}
```

### Common Settings

| Setting | Values | Description |
|---------|--------|-------------|
| `tabsize` | number | Spaces per tab |
| `tabstospaces` | bool | Convert tabs to spaces |
| `autoindent` | bool | Auto-indent new lines |
| `syntax` | bool | Syntax highlighting |
| `colorscheme` | string | Color scheme name |
| `ruler` | bool | Show column ruler |
| `savecursor` | bool | Remember cursor position |
| `scrollbar` | bool | Show scrollbar |
| `softwrap` | bool | Wrap long lines |
| `wordwrap` | bool | Wrap at word boundaries |
| `cursorline` | bool | Highlight current line |
| `rmtrailingws` | bool | Remove trailing whitespace |
| `autoclose` | bool | Auto-close brackets |
| `linter` | bool | Enable linting |
| `autosave` | number | Auto-save interval (seconds) |

### Custom Keybindings

Create `~/.config/micro/bindings.json`:

```json
{
    "Ctrl-Shift-c": "Copy",
    "Ctrl-Shift-v": "Paste",
    "Alt-q": "Quit",
    "F2": "Save",
    "F5": "command:run"
}
```

### File-Type Specific Settings

In `settings.json`:

```json
{
    "*.md": {
        "softwrap": true,
        "wordwrap": true
    },
    "*.py": {
        "tabsize": 4,
        "tabstospaces": true
    },
    "Makefile": {
        "tabstospaces": false
    }
}
```

---

## Tips and Tricks

### Multi-Cursor Editing

1. Hold `Alt+Shift` and press `Up` or `Down` to add cursors
2. Type to edit all locations at once
3. Press `Escape` to return to single cursor

### Column Selection

1. Hold `Shift` and use arrow keys to select
2. Use `Ctrl+Shift+Arrow` for word selection

### Quick File Switching

1. Open multiple files: `micro file1.txt file2.txt`
2. Use `Ctrl+W` to switch between them
3. Or use tabs with `Ctrl+T` and `Alt+,`/`Alt+.`

### Running Shell Commands

```
Ctrl+E then: run command
```

Or:
```
Ctrl+E then: !ls -la
```

### Recording Macros

Not built-in, but you can use the command bar to repeat commands.

### Comparison with Other Editors

| Feature | Micro | Nano | Vim |
|---------|-------|------|-----|
| Learning curve | Easy | Easy | Hard |
| Familiar shortcuts | Yes | Partial | No |
| Plugin system | Yes | No | Yes |
| Mouse support | Yes | Limited | Yes |
| LSP support | Yes | No | Yes (plugins) |
| Syntax highlighting | Yes | Yes | Yes |

### Why Micro Over Nano?

- Better syntax highlighting
- Plugin ecosystem
- Mouse support
- Multi-cursor
- Split windows
- Modern features (LSP)

### Why Micro Over Vim?

- No learning curve
- Standard keybindings
- Intuitive immediately
- Still powerful

---

## Troubleshooting

### Colors Not Working

```bash
# Check terminal colors
echo $TERM
# Should be xterm-256color or similar

# Set in your shell config
export TERM=xterm-256color
```

### Plugin Not Working

```bash
# List plugins
micro
Ctrl+E: plugin list

# Reinstall plugin
Ctrl+E: plugin remove pluginname
Ctrl+E: plugin install pluginname
```

### LSP Not Working

1. Ensure language server is installed:
   ```bash
   # For TypeScript
   npm install -g typescript-language-server

   # For Python
   pip install python-lsp-server
   ```

2. Check LSP status:
   ```
   Ctrl+E: lsp
   ```

### Key Conflicts in tmux

If keybindings conflict with tmux, modify either:
- Micro's `bindings.json`
- tmux's prefix key

### Reset to Defaults

```bash
rm -rf ~/.config/micro
# Micro will recreate defaults on next launch
```
