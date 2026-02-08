# Syncthing Guide

A guide to Syncthing - continuous file synchronization between devices.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Web Interface](#web-interface)
4. [Adding Devices](#adding-devices)
5. [Sharing Folders](#sharing-folders)
6. [Configuration](#configuration)
7. [Security](#security)
8. [Troubleshooting](#troubleshooting)

---

## Overview

Syncthing provides:
- **Continuous sync** - Files sync automatically when changed
- **Peer-to-peer** - No central server, devices connect directly
- **Secure** - End-to-end encryption
- **Open source** - No cloud dependency
- **Cross-platform** - Linux, macOS, Windows, Android

**Use cases:**
- Sync documents across computers
- Backup important files
- Share files with others
- Replace cloud storage (Dropbox, Google Drive)

---

## Installation

Run the installer:
```bash
./installers/07-syncthing.sh <username> <password>
```

**What gets installed:**
- Syncthing binary
- Systemd service
- Web UI configured on port 3060
- User authentication

**Access the Web UI:**
```
http://localhost:3060
```

---

## Web Interface

### Dashboard

The main dashboard shows:
- **This Device** - Your device ID and status
- **Folders** - Synced folders and their status
- **Remote Devices** - Connected devices

### Status Icons

| Icon | Meaning |
|------|---------|
| Green checkmark | Up to date |
| Blue arrows | Syncing |
| Orange warning | Out of sync |
| Red X | Disconnected |
| Gray | Paused |

### Navigation

| Section | Purpose |
|---------|---------|
| **Actions** | Add folder, device, settings |
| **Folders** | Manage synced folders |
| **Remote Devices** | Manage connected devices |
| **This Device** | View local status |

---

## Adding Devices

### Getting Your Device ID

1. Open Web UI
2. Click **Actions** > **Show ID**
3. Copy the device ID (long alphanumeric string)
4. Share this ID with others to connect

### Adding a Remote Device

1. Get the remote device's ID
2. Click **Add Remote Device**
3. Enter the Device ID
4. Set a friendly name
5. Select folders to share (optional)
6. Click **Save**

### Accepting Device Requests

When another device adds you:
1. A notification appears: "New Device"
2. Click to review
3. Set device name
4. Select folders to share
5. Click **Add Device**

### Device Options

| Option | Description |
|--------|-------------|
| **Device Name** | Friendly name |
| **Addresses** | How to connect (dynamic or specific IP) |
| **Compression** | Data compression level |
| **Introducer** | Share other devices automatically |
| **Auto Accept** | Automatically accept shared folders |

---

## Sharing Folders

### Adding a New Folder

1. Click **Add Folder**
2. Configure:
   - **Folder Label**: Display name
   - **Folder ID**: Unique identifier (auto-generated)
   - **Folder Path**: Local directory path
3. Select devices to share with
4. Click **Save**

### Folder Types

| Type | Description |
|------|-------------|
| **Send & Receive** | Full sync, changes go both ways |
| **Send Only** | Push changes out, ignore incoming |
| **Receive Only** | Accept changes, don't push local changes |

### Folder Options

**General:**
- Folder Label
- Folder ID
- Folder Path

**Sharing:**
- Select which devices can access

**File Versioning:**
- Keep old versions of changed files

**Ignore Patterns:**
- Files/folders to exclude from sync

**Advanced:**
- File pull order
- Scan interval
- Permissions

### Ignore Patterns

Create `.stignore` in folder root:

```
// Comments start with //

// Ignore specific files
desktop.ini
Thumbs.db
.DS_Store

// Ignore patterns
*.tmp
*.log
~*

// Ignore directories
/node_modules
/.git
/build

// Negate (include despite previous rules)
!/important.log

// Ignore by regex
(?d).git
```

---

## Configuration

### File Locations

| Platform | Config Location |
|----------|-----------------|
| Linux | `~/.config/syncthing/` |
| macOS | `~/Library/Application Support/Syncthing/` |
| Windows | `%APPDATA%\Syncthing\` |

### Key Files

| File | Purpose |
|------|---------|
| `config.xml` | Main configuration |
| `cert.pem` | TLS certificate |
| `key.pem` | TLS private key |
| `https-cert.pem` | Web UI certificate |
| `https-key.pem` | Web UI private key |

### Service Management

```bash
# Status
sudo systemctl status syncthing@$USER

# Start/Stop/Restart
sudo systemctl start syncthing@$USER
sudo systemctl stop syncthing@$USER
sudo systemctl restart syncthing@$USER

# Enable on boot
sudo systemctl enable syncthing@$USER

# View logs
journalctl -u syncthing@$USER -f
```

### GUI Settings

**Actions** > **Settings**

| Tab | Options |
|-----|---------|
| **General** | Device name, default folder path |
| **GUI** | Listen address, theme, auth |
| **Connections** | Relay, rate limits, protocols |
| **Advanced** | Scanning, database tuning |

### Command Line

```bash
# Show config
syncthing cli config

# Generate device ID
syncthing generate

# Validate config
syncthing --paths

# Run in foreground
syncthing serve
```

---

## Security

### Encryption

- **In Transit**: TLS 1.3 between devices
- **At Rest**: Optional folder encryption
- **Device Verification**: Devices identified by unique ID

### Authentication

Web UI authentication configured during install:
- Username and password required
- HTTPS recommended for remote access

### Firewall Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 22000 | TCP/UDP | Sync Protocol |
| 21027 | UDP | Local Discovery |
| 8384 | TCP | Web UI (default) |
| 3060 | TCP | Web UI (our config) |

### Best Practices

1. **Strong GUI password** - Especially if exposed to network
2. **Use HTTPS** for remote Web UI access
3. **Verify device IDs** before accepting
4. **Review shared folders** carefully
5. **Enable file versioning** for important data
6. **Regular backups** - Syncthing is sync, not backup

### Untrusted Folders

Share with untrusted devices using encryption:
```
Folder > Edit > Encryption Password
```

The untrusted device stores encrypted data it cannot read.

---

## Troubleshooting

### Connection Issues

**Devices not connecting:**

1. Check both devices are online
2. Verify device IDs are correct
3. Check firewall allows port 22000
4. Try adding explicit addresses:
   ```
   tcp://192.168.1.100:22000
   ```

**NAT traversal:**
- Syncthing uses relays when direct connection fails
- Check relay status in Web UI
- Consider port forwarding for better performance

### Sync Issues

**Files not syncing:**

1. Check folder status in Web UI
2. Look for conflict files (`*.sync-conflict-*`)
3. Check ignore patterns
4. Verify permissions on files/folders

**Out of sync:**
1. Click on the folder
2. Check "Failed Items"
3. Address individual file issues

### Performance

**Slow sync:**
- Enable compression for slow networks
- Limit concurrent scans
- Increase scan interval for large folders
- Use direct connection instead of relay

**High CPU usage:**
- Increase rescan interval
- Exclude large/frequently changing files
- Use `.stignore` for build directories

### Common Errors

**"Folder marker missing":**
- The `.stfolder` file was deleted
- Recreate or rescan the folder

**"Permission denied":**
- Check file/folder permissions
- Ensure Syncthing user can access path

**"Folder path does not exist":**
- Create the directory
- Or update folder path in settings

### Logs

```bash
# View logs
journalctl -u syncthing@$USER -f

# Or in ~/.config/syncthing/
tail -f ~/.config/syncthing/syncthing.log
```

### Reset Configuration

```bash
# Stop service
sudo systemctl stop syncthing@$USER

# Backup and remove config
mv ~/.config/syncthing ~/.config/syncthing.backup

# Restart - will create new config
sudo systemctl start syncthing@$USER
```

---

## Quick Reference

### URLs

| URL | Purpose |
|-----|---------|
| http://localhost:3060 | Web UI |
| https://localhost:3060 | Web UI (HTTPS) |

### Status Commands

```bash
# Service status
sudo systemctl status syncthing@$USER

# Process status
pgrep -a syncthing

# Open ports
ss -tlnp | grep syncthing
```

### Config Location

```
~/.config/syncthing/config.xml
```

### Ignore File

Create in folder root:
```
/path/to/folder/.stignore
```
