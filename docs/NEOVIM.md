# Neovim User Guide

A comprehensive guide to using Neovim with this dotfiles configuration.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Understanding Vim Modes](#understanding-vim-modes)
3. [Essential Keybindings](#essential-keybindings)
4. [Movement and Navigation](#movement-and-navigation)
5. [Editing Text](#editing-text)
6. [Search and Replace](#search-and-replace)
7. [Working with Files](#working-with-files)
8. [Buffers, Windows, and Tabs](#buffers-windows-and-tabs)
9. [Plugin Features](#plugin-features)
10. [LSP and Autocompletion](#lsp-and-autocompletion)
11. [Git Integration](#git-integration)
12. [Customization](#customization)
13. [Troubleshooting](#troubleshooting)

---

## Getting Started

### First Launch

When you first run `nvim`, the plugin manager (Lazy.nvim) will automatically:
1. Clone itself if not present
2. Install all configured plugins
3. Download required dependencies

This may take a minute. Once complete, restart Neovim.

### Health Check

Run `:checkhealth` to verify your installation. This checks:
- Neovim version
- Plugin dependencies (ripgrep, fd, node, python)
- LSP server availability
- Clipboard support

---

## Understanding Vim Modes

Neovim is a **modal editor**. Unlike traditional editors where you type directly, Neovim has different modes for different tasks.

### The Four Main Modes

| Mode | Purpose | How to Enter | Indicator |
|------|---------|--------------|-----------|
| **Normal** | Navigate, delete, copy, run commands | `Esc` or `Ctrl+[` | No indicator (default) |
| **Insert** | Type and edit text | `i`, `a`, `o`, `I`, `A`, `O` | `-- INSERT --` |
| **Visual** | Select text | `v`, `V`, `Ctrl+v` | `-- VISUAL --` |
| **Command** | Run Ex commands | `:` | `:` at bottom |

### Mode Transitions

```
                    i, a, o
    ┌─────────────────────────────────┐
    │                                 ▼
┌───────┐         v, V, Ctrl+v    ┌────────┐
│Normal │◄────────────────────────│ Insert │
└───────┘         Esc             └────────┘
    │   ▲                             │
    │   │              Esc            │
    │   └─────────────────────────────┘
    │
    │ v, V, Ctrl+v
    ▼
┌────────┐
│ Visual │
└────────┘
```

### Quick Mode Reference

**Entering Insert Mode:**
- `i` - Insert before cursor
- `a` - Insert after cursor (append)
- `I` - Insert at beginning of line
- `A` - Insert at end of line
- `o` - Open new line below
- `O` - Open new line above

**Exiting Insert Mode:**
- `Esc` - Return to Normal mode
- `jk` - Quick escape (configured in this setup)
- `Ctrl+[` - Same as Escape

---

## Essential Keybindings

### Leader Key

The **leader key** is `Space`. Many commands start with the leader key.

Press `Space` and wait to see available options (via which-key plugin).

### Most Important Keys

| Key | Mode | Action |
|-----|------|--------|
| `Esc` | Any | Return to Normal mode |
| `:w` | Normal | Save file |
| `:q` | Normal | Quit |
| `:wq` or `ZZ` | Normal | Save and quit |
| `:q!` | Normal | Quit without saving |
| `u` | Normal | Undo |
| `Ctrl+r` | Normal | Redo |
| `.` | Normal | Repeat last change |

---

## Movement and Navigation

### Basic Movement

| Key | Movement |
|-----|----------|
| `h` | Left |
| `j` | Down |
| `k` | Up |
| `l` | Right |

### Word Movement

| Key | Movement |
|-----|----------|
| `w` | Next word (beginning) |
| `W` | Next WORD (space-separated) |
| `e` | End of word |
| `b` | Previous word |
| `B` | Previous WORD |

### Line Movement

| Key | Movement |
|-----|----------|
| `0` | Beginning of line |
| `^` | First non-blank character |
| `$` | End of line |
| `g_` | Last non-blank character |

### Screen Movement

| Key | Movement |
|-----|----------|
| `gg` | Go to first line |
| `G` | Go to last line |
| `{number}G` | Go to line number |
| `Ctrl+d` | Half page down |
| `Ctrl+u` | Half page up |
| `Ctrl+f` | Full page forward |
| `Ctrl+b` | Full page backward |
| `H` | Top of screen (High) |
| `M` | Middle of screen |
| `L` | Bottom of screen (Low) |
| `zz` | Center cursor on screen |

### Jump Movement

| Key | Movement |
|-----|----------|
| `%` | Jump to matching bracket |
| `*` | Jump to next occurrence of word under cursor |
| `#` | Jump to previous occurrence |
| `Ctrl+o` | Jump back (older position) |
| `Ctrl+i` | Jump forward (newer position) |
| `` ` ` `` | Jump to last edit position |

---

## Editing Text

### Operators

Operators are combined with motions: `{operator}{motion}`

| Operator | Action |
|----------|--------|
| `d` | Delete |
| `c` | Change (delete and enter insert mode) |
| `y` | Yank (copy) |
| `>` | Indent right |
| `<` | Indent left |
| `=` | Auto-indent |
| `gU` | Uppercase |
| `gu` | Lowercase |

### Common Combinations

| Command | Action |
|---------|--------|
| `dw` | Delete word |
| `d$` or `D` | Delete to end of line |
| `dd` | Delete entire line |
| `d3j` | Delete 3 lines down |
| `cw` | Change word |
| `cc` | Change entire line |
| `yy` | Yank (copy) line |
| `yw` | Yank word |
| `p` | Paste after cursor |
| `P` | Paste before cursor |

### Text Objects

Use with operators: `{operator}{a/i}{object}`

- `a` = "a" (includes surrounding)
- `i` = "inner" (inside only)

| Object | Description |
|--------|-------------|
| `w` | Word |
| `s` | Sentence |
| `p` | Paragraph |
| `"` | Double quotes |
| `'` | Single quotes |
| `` ` `` | Backticks |
| `(` or `)` | Parentheses |
| `[` or `]` | Square brackets |
| `{` or `}` | Curly braces |
| `<` or `>` | Angle brackets |
| `t` | HTML/XML tag |

**Examples:**
- `diw` - Delete inner word
- `ci"` - Change inside double quotes
- `da(` - Delete around parentheses (including parens)
- `yit` - Yank inside HTML tag
- `vi{` - Visually select inside curly braces

### Quick Edits

| Command | Action |
|---------|--------|
| `x` | Delete character under cursor |
| `X` | Delete character before cursor |
| `r{char}` | Replace single character |
| `R` | Enter Replace mode |
| `J` | Join lines |
| `~` | Toggle case |
| `Ctrl+a` | Increment number |
| `Ctrl+x` | Decrement number |

---

## Search and Replace

### Basic Search

| Command | Action |
|---------|--------|
| `/{pattern}` | Search forward |
| `?{pattern}` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search word under cursor (forward) |
| `#` | Search word under cursor (backward) |

### Search Options

| Pattern | Meaning |
|---------|---------|
| `\c` | Case insensitive |
| `\C` | Case sensitive |
| `\<word\>` | Whole word only |
| `\v` | "Very magic" (regex-like) |

### Search and Replace

```
:[range]s/{pattern}/{replacement}/[flags]
```

| Flag | Meaning |
|------|---------|
| `g` | Global (all occurrences on line) |
| `c` | Confirm each replacement |
| `i` | Case insensitive |
| `I` | Case sensitive |

**Examples:**
- `:%s/foo/bar/g` - Replace all "foo" with "bar" in file
- `:s/foo/bar/g` - Replace on current line only
- `:%s/foo/bar/gc` - Replace with confirmation
- `:5,10s/foo/bar/g` - Replace on lines 5-10

---

## Working with Files

### File Commands

| Command | Action |
|---------|--------|
| `:e {file}` | Edit/open file |
| `:w` | Save current file |
| `:w {file}` | Save as new file |
| `:saveas {file}` | Save as and switch to new file |
| `:r {file}` | Read file into current buffer |
| `:!{cmd}` | Run shell command |
| `:r !{cmd}` | Read command output into buffer |

### File Explorer (nvim-tree)

The file tree opens automatically on the left side.

| Key | Action |
|-----|--------|
| `Enter` | Open file/toggle folder |
| `o` | Open file |
| `v` | Open in vertical split |
| `s` | Open in horizontal split |
| `t` | Open in new tab |
| `a` | Create new file/directory |
| `d` | Delete |
| `r` | Rename |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |
| `R` | Refresh |
| `H` | Toggle hidden files |
| `q` | Close tree |

### Telescope (Fuzzy Finder)

| Keybinding | Action |
|------------|--------|
| `Ctrl+p` | Find files |
| `Ctrl+f` | Live grep (search in files) |
| `<leader>bb` | List buffers |
| `<leader>ch` | Command history |

**Inside Telescope:**
| Key | Action |
|-----|--------|
| `Ctrl+j` | Move to next item |
| `Ctrl+k` | Move to previous item |
| `Enter` | Open selected |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+x` | Open in horizontal split |
| `Esc` | Close Telescope |

---

## Buffers, Windows, and Tabs

### Buffers

A buffer is an in-memory text file. You can have many buffers open.

| Command | Action |
|---------|--------|
| `:ls` or `:buffers` | List buffers |
| `:b {n}` | Go to buffer n |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Delete (close) buffer |
| `<leader>bn` | Next buffer (bufferline) |
| `<leader>bp` | Previous buffer (bufferline) |

### Windows (Splits)

| Command | Action |
|---------|--------|
| `:split` or `:sp` | Horizontal split |
| `:vsplit` or `:vs` | Vertical split |
| `Ctrl+w h/j/k/l` | Move to window left/down/up/right |
| `Ctrl+w w` | Cycle windows |
| `Ctrl+w q` | Close window |
| `Ctrl+w o` | Close all other windows |
| `Ctrl+w =` | Equalize window sizes |
| `Ctrl+w _` | Maximize height |
| `Ctrl+w \|` | Maximize width |
| `Ctrl+w +/-` | Increase/decrease height |
| `Ctrl+w >/<` | Increase/decrease width |

### Tabs

| Command | Action |
|---------|--------|
| `:tabnew` | New tab |
| `:tabnext` or `gt` | Next tab |
| `:tabprev` or `gT` | Previous tab |
| `:tabclose` | Close tab |
| `:tabonly` | Close other tabs |

---

## Plugin Features

### Copilot (AI Completion)

| Keybinding | Action |
|------------|--------|
| `Ctrl+j` | Accept suggestion |
| `Ctrl+k` | Dismiss suggestion |

Suggestions appear as ghost text while typing.

### ToggleTerm (Terminal)

| Keybinding | Action |
|------------|--------|
| `Ctrl+\` | Toggle terminal |

### Commentary (Comments)

| Command | Action |
|---------|--------|
| `gcc` | Toggle comment on line |
| `gc{motion}` | Toggle comment with motion |
| `gcap` | Comment a paragraph |
| `gc` (visual) | Comment selection |

### Surround

Change surrounding characters:

| Command | Action |
|---------|--------|
| `cs"'` | Change surrounding `"` to `'` |
| `cs'<q>` | Change `'` to `<q>...</q>` |
| `ds"` | Delete surrounding `"` |
| `ysiw"` | Surround word with `"` |
| `yss)` | Surround line with `)` |
| `S"` (visual) | Surround selection with `"` |

### Leap (Fast Motion)

Press `s` followed by two characters to jump:
- `s{char1}{char2}` - Jump forward
- `S{char1}{char2}` - Jump backward

### Undotree

| Command | Action |
|---------|--------|
| `:UndotreeToggle` | Show undo history tree |

### Which-Key

Press `<leader>` (Space) and wait - a popup shows available keybindings.

### Markdown Preview

| Command | Action |
|---------|--------|
| `:MarkdownPreview` | Start preview in browser |
| `:MarkdownPreviewStop` | Stop preview |

---

## LSP and Autocompletion

### LSP (Language Server Protocol)

LSP provides:
- Syntax checking
- Go to definition
- Find references
- Hover documentation
- Code actions

**Configured Servers:**
- `pyright` - Python
- `ts_ls` - TypeScript/JavaScript

| Keybinding | Action |
|------------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Autocompletion (nvim-cmp)

| Key | Action |
|-----|--------|
| `Tab` | Select next item / expand snippet |
| `Shift+Tab` | Select previous item |
| `Enter` | Confirm selection |
| `Ctrl+Space` | Trigger completion |
| `Ctrl+d` | Scroll docs down |
| `Ctrl+f` | Scroll docs up |

Completion sources:
- LSP suggestions
- Snippets (LuaSnip)
- Copilot suggestions

### Treesitter

Provides advanced syntax highlighting and code understanding:
- Better syntax colors
- Smart indentation
- Code folding (with `za`, `zo`, `zc`)

---

## Git Integration

### Gitsigns

Shows git changes in the sign column (left margin):
- `+` Added line
- `~` Changed line
- `_` Deleted line

Current line blame is shown inline.

| Command | Action |
|---------|--------|
| `:Gitsigns toggle_current_line_blame` | Toggle blame |
| `:Gitsigns preview_hunk` | Preview change |
| `:Gitsigns reset_hunk` | Reset change |
| `:Gitsigns stage_hunk` | Stage change |

---

## Customization

### Configuration Location

```
~/.config/nvim/init.lua
```

### Adding Plugins

Add to the `require("lazy").setup({...})` table:

```lua
{
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- options
    })
  end,
}
```

### Adding Keymaps

```lua
vim.keymap.set("n", "<leader>key", ":Command<CR>", {
  noremap = true,
  silent = true,
  desc = "Description"
})
```

### Changing Options

```lua
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
```

### Updating Plugins

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager |
| `:Lazy sync` | Install/update/clean plugins |
| `:Lazy update` | Update plugins |
| `:Lazy clean` | Remove unused plugins |

---

## Troubleshooting

### Common Issues

**Plugins not loading:**
```vim
:Lazy
```
Press `I` to install missing plugins.

**LSP not working:**
```vim
:LspInfo
:checkhealth lsp
```

Ensure language servers are installed:
```bash
npm install -g typescript typescript-language-server pyright
```

**Clipboard not working:**
```vim
:checkhealth provider
```

Install clipboard provider:
- macOS: Works by default
- Linux: `xclip` or `xsel`
- WSL: `win32yank`

**Slow startup:**
```vim
:Lazy profile
```

### Useful Debug Commands

| Command | Purpose |
|---------|---------|
| `:checkhealth` | System health check |
| `:messages` | View message history |
| `:verbose map {key}` | See where a key is mapped |
| `:Lazy log` | Plugin update log |
| `:LspInfo` | LSP status |
| `:TSInstallInfo` | Treesitter parsers |

### Reset Configuration

To start fresh:
```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

Then reinstall using the setup script.

---

## Quick Reference Card

```
MODES           MOVEMENT         EDITING          FILES
─────           ────────         ───────          ─────
i  Insert       h j k l          d  Delete        :e   Open
Esc Normal      w b e            c  Change        :w   Save
v  Visual       gg G             y  Yank          :q   Quit
:  Command      Ctrl+d/u         p  Paste         :wq  Save+Quit
                0 ^ $            u  Undo
                                 .  Repeat

SEARCH          WINDOWS          TELESCOPE        LEADER (Space)
──────          ───────          ─────────        ──────────────
/pattern        Ctrl+w s split   Ctrl+p files     bb  Buffers
n/N next/prev   Ctrl+w v vsplit  Ctrl+f grep      bn  Next buf
*  word fwd     Ctrl+w hjkl      Ctrl+j/k nav     bp  Prev buf
#  word back    Ctrl+w q close   Enter open       ch  Cmd history

COMPLETION      COMMENTS         TERMINAL
──────────      ────────         ────────
Tab    Next     gcc  Line        Ctrl+\  Toggle
S-Tab  Prev     gc   Motion
Enter  Accept   gcap Paragraph
Ctrl+Space Trigger
```
