# Firefox Customization Guide

A guide to Firefox userChrome.css customization for a minimal, modern interface.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Enabling userChrome.css](#enabling-userchromecss)
4. [What Gets Changed](#what-gets-changed)
5. [Customization](#customization)
6. [Troubleshooting](#troubleshooting)

---

## Overview

This configuration provides:
- **Minimal interface** - Hidden unnecessary elements
- **Compact layout** - More screen space for content
- **Clean aesthetics** - Transparent elements, subtle borders
- **Dark mode support** - Proper colors in dark themes

The customization uses Firefox's `userChrome.css` system to modify the browser's UI appearance.

---

## Installation

Run the setup script:
```bash
./setup/13-firefox.sh
```

**What gets installed:**
- `userChrome.css` - Main stylesheet
- `compact.css` - Compact layout rules
- `framework.css` - Comprehensive styling framework

Files are copied to your Firefox profile's `chrome/` directory.

**Supported locations:**
- Linux: `~/.mozilla/firefox/*.default*/chrome/`
- macOS: `~/Library/Application Support/Firefox/Profiles/*.default*/chrome/`
- Snap: `~/snap/firefox/common/.mozilla/firefox/*.default*/chrome/`

---

## Enabling userChrome.css

Firefox doesn't load userChrome.css by default. You must enable it:

### Step 1: Open about:config

1. Type `about:config` in the address bar
2. Press Enter
3. Click "Accept the Risk and Continue"

### Step 2: Enable the Setting

1. Search for: `toolkit.legacyUserProfileCustomizations.stylesheets`
2. Click the toggle button to set it to `true`

### Step 3: Restart Firefox

Close and reopen Firefox for changes to take effect.

---

## What Gets Changed

### Hidden Elements

| Element | Status |
|---------|--------|
| Title bar buttons | Hidden |
| Back/Forward buttons | Hidden |
| Page action buttons | Hidden |
| Menu button (hamburger) | Hidden |
| Toolbar borders | Removed |

### Modified Elements

| Element | Change |
|---------|--------|
| Navigation bar | Transparent, compact |
| Tabs toolbar | Left margin 20vw |
| URL bar | Transparent, borderless |
| Toolbox border | Removed |

### Layout Changes

```
Before:
┌────────────────────────────────────────────┐
│ [←][→][↻] [________________] [☆][≡]       │
│ [Tab 1] [Tab 2] [Tab 3] [+]                │
├────────────────────────────────────────────┤
│                                            │
│              Page Content                  │
│                                            │
└────────────────────────────────────────────┘

After:
┌────────────────────────────────────────────┐
│            [Tab 1] [Tab 2] [Tab 3]         │
│                                            │
│              Page Content                  │
│                                            │
└────────────────────────────────────────────┘
```

---

## Customization

### File Structure

```
~/.mozilla/firefox/PROFILE/chrome/
├── userChrome.css      # Main entry point
├── compact.css         # Compact layout rules
└── framework.css       # Comprehensive styling
```

### userChrome.css

```css
@import url("compact.css");
@import url("framework.css");

/* GitHub icon fix for dark mode */
#page-action-buttons > #pocket-button > .urlbar-icon {
    filter: invert(1);
}
```

### compact.css Key Rules

```css
/* Hide title bar buttons */
.titlebar-buttonbox { display: none !important; }

/* Remove toolbox border */
#navigator-toolbox { border-bottom: none !important; }

/* Compact tabs */
#TabsToolbar { margin-left: 20vw !important; }

/* Transparent nav bar */
#nav-bar {
    background: transparent !important;
    margin-right: 80vw;
    margin-top: -36px;
}

/* Hide navigation buttons */
#back-button,
#forward-button { display: none !important; }

/* Transparent URL bar */
#urlbar-background {
    background: transparent !important;
    border: none !important;
}
```

### Common Customizations

**Show back/forward buttons:**
```css
/* Remove or comment out in compact.css */
/* #back-button, #forward-button { display: none !important; } */
```

**Show menu button:**
```css
/* Remove or comment out */
/* #PanelUI-button { display: none !important; } */
```

**Adjust tab bar position:**
```css
#TabsToolbar {
    margin-left: 10vw !important;  /* Change from 20vw */
}
```

**Different nav bar width:**
```css
#nav-bar {
    margin-right: 70vw;  /* Change from 80vw */
}
```

**Add slight transparency:**
```css
#navigator-toolbox {
    opacity: 0.95;
}
```

### Color Customization

```css
/* Custom tab colors */
.tabbrowser-tab[selected] {
    background-color: #2a2a2a !important;
}

/* URL bar text color */
#urlbar-input {
    color: #ffffff !important;
}

/* Custom accent color */
:root {
    --toolbar-bgcolor: #1a1a1a !important;
    --lwt-accent-color: #ff6b6b !important;
}
```

---

## Advanced Customization

### CSS Variables

Firefox exposes many CSS variables:

```css
:root {
    /* Colors */
    --toolbar-bgcolor: #...;
    --toolbar-color: #...;
    --lwt-accent-color: #...;
    --urlbar-box-bgcolor: #...;

    /* Spacing */
    --tab-min-height: 36px;
    --toolbarbutton-inner-padding: 8px;
}
```

### Finding Element IDs

1. Open Firefox
2. Press `Ctrl+Shift+Alt+I` (Browser Toolbox)
3. Accept the connection
4. Use Inspector to find element IDs

### Useful Selectors

| Selector | Element |
|----------|---------|
| `#navigator-toolbox` | Top toolbar container |
| `#nav-bar` | Navigation bar |
| `#TabsToolbar` | Tabs bar |
| `#urlbar` | URL bar |
| `#urlbar-input` | URL text input |
| `#back-button` | Back button |
| `#forward-button` | Forward button |
| `.tabbrowser-tab` | Individual tab |
| `.tabbrowser-tab[selected]` | Active tab |
| `#PanelUI-button` | Menu button |
| `#sidebar-box` | Sidebar container |

### Per-Website Styling

For per-site styling, use the Stylus extension instead.

---

## Troubleshooting

### Changes Not Appearing

1. **Verify setting is enabled:**
   - `about:config` > `toolkit.legacyUserProfileCustomizations.stylesheets` = `true`

2. **Restart Firefox completely:**
   - Close all windows
   - Wait a few seconds
   - Reopen

3. **Check file location:**
   ```bash
   # Find your profile
   ls ~/.mozilla/firefox/

   # Verify chrome folder exists
   ls ~/.mozilla/firefox/*.default*/chrome/
   ```

4. **Check for syntax errors:**
   - Open Browser Toolbox (`Ctrl+Shift+Alt+I`)
   - Look for CSS errors in console

### Finding Your Profile

1. Type `about:profiles` in address bar
2. Look for "Root Directory" under your profile
3. This is where `/chrome/` should be

Or via terminal:
```bash
# Linux
ls ~/.mozilla/firefox/*.default*

# macOS
ls ~/Library/Application\ Support/Firefox/Profiles/*.default*
```

### Conflicting Extensions

Some extensions modify the UI and may conflict:
- Tree Style Tab
- Sidebery
- Custom CSS themes

Disable extensions temporarily to test.

### Broken After Firefox Update

Firefox updates can change element IDs or structure:

1. Check if old selectors still exist
2. Use Browser Toolbox to find new selectors
3. Update your CSS accordingly

### Resetting to Default

```bash
# Remove custom CSS
rm -rf ~/.mozilla/firefox/*.default*/chrome/

# Restart Firefox
```

Or disable the setting:
- `about:config` > `toolkit.legacyUserProfileCustomizations.stylesheets` = `false`

---

## Resources

### Documentation

- [Firefox CSS Documentation](https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/CSS)
- [UserChrome.css Guide](https://www.userchrome.org/)

### Communities

- r/FirefoxCSS (Reddit)
- Firefox CSS Discord

### Tools

- **Browser Toolbox** - `Ctrl+Shift+Alt+I` to inspect Firefox UI
- **Stylus Extension** - For per-website CSS

---

## Quick Reference

### File Location
```
~/.mozilla/firefox/PROFILE/chrome/userChrome.css
```

### Enable Setting
```
about:config > toolkit.legacyUserProfileCustomizations.stylesheets = true
```

### Reload Changes
Restart Firefox (close all windows and reopen)

### Browser Toolbox
`Ctrl+Shift+Alt+I` (for inspecting Firefox UI elements)
