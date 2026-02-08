# PM2 Process Manager Guide

A guide to PM2 - the production process manager for Node.js applications.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Basic Usage](#basic-usage)
4. [Process Management](#process-management)
5. [Ecosystem File](#ecosystem-file)
6. [Monitoring](#monitoring)
7. [Log Management](#log-management)
8. [Cluster Mode](#cluster-mode)
9. [Deployment](#deployment)

---

## Overview

PM2 provides:
- Process management (start, stop, restart)
- Auto-restart on crash
- Load balancing (cluster mode)
- Log management
- Startup scripts
- Monitoring and metrics
- Zero-downtime deployments

---

## Installation

Run the installer:
```bash
./installers/10-pm2.sh
```

**What gets installed:**
- PM2 globally via npm
- Startup script for system boot
- Process list persistence

**Verify installation:**
```bash
pm2 --version
```

---

## Basic Usage

### Starting Applications

```bash
# Start a Node.js app
pm2 start app.js

# Start with a name
pm2 start app.js --name "my-api"

# Start with arguments
pm2 start app.js -- --port 3000

# Start a script
pm2 start ./start.sh

# Start from package.json
pm2 start npm -- start
pm2 start npm --name "my-app" -- run dev

# Start Python script
pm2 start script.py --interpreter python3

# Start any command
pm2 start "node server.js" --name api
```

### Common Options

| Option | Description |
|--------|-------------|
| `--name` | Set process name |
| `--watch` | Restart on file changes |
| `--ignore-watch` | Files to ignore when watching |
| `--max-memory-restart` | Restart if memory exceeds limit |
| `--cron` | Cron pattern for restarts |
| `--no-autorestart` | Disable auto-restart |
| `--instances` | Number of instances |
| `--env` | Environment (development, production) |

### Examples

```bash
# Watch for changes (development)
pm2 start app.js --watch --ignore-watch="node_modules logs"

# Memory limit
pm2 start app.js --max-memory-restart 200M

# Environment variables
pm2 start app.js --env production

# Multiple instances
pm2 start app.js -i 4
```

---

## Process Management

### Listing Processes

```bash
# List all processes
pm2 list
pm2 ls
pm2 status

# Detailed list
pm2 prettylist

# Show as JSON
pm2 jlist
```

### Controlling Processes

```bash
# Stop
pm2 stop app_name
pm2 stop 0           # By ID
pm2 stop all         # All processes

# Restart
pm2 restart app_name
pm2 restart all

# Reload (graceful restart)
pm2 reload app_name
pm2 reload all

# Delete (stop and remove)
pm2 delete app_name
pm2 delete all

# Reset restart count
pm2 reset app_name
```

### Process Information

```bash
# Show process details
pm2 show app_name
pm2 describe app_name
pm2 describe 0

# Environment variables
pm2 env 0
```

---

## Ecosystem File

### Creating ecosystem.config.js

```bash
# Generate template
pm2 ecosystem
```

### Basic Configuration

```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'my-api',
    script: './server.js',
    instances: 2,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'development',
      PORT: 3000
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 8080
    }
  }]
};
```

### Full Configuration Options

```javascript
module.exports = {
  apps: [{
    // Basic
    name: 'my-app',
    script: './app.js',
    args: '--port 3000',
    cwd: '/home/user/app',
    interpreter: 'node',
    interpreter_args: '--max-old-space-size=4096',

    // Instances
    instances: 'max',      // or number
    exec_mode: 'cluster',  // or 'fork'

    // Restart behavior
    autorestart: true,
    watch: ['src'],
    ignore_watch: ['node_modules', 'logs'],
    watch_delay: 1000,
    max_restarts: 10,
    min_uptime: '10s',
    max_memory_restart: '1G',
    restart_delay: 4000,
    exp_backoff_restart_delay: 100,

    // Logs
    output: './logs/out.log',
    error: './logs/error.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,

    // Environment
    env: {
      NODE_ENV: 'development'
    },
    env_production: {
      NODE_ENV: 'production'
    },

    // Advanced
    kill_timeout: 5000,
    listen_timeout: 8000,
    shutdown_with_message: false,
    wait_ready: true,

    // Cron restart
    cron_restart: '0 0 * * *',  // Daily at midnight
  }]
};
```

### Using Ecosystem File

```bash
# Start all apps
pm2 start ecosystem.config.js

# Start specific app
pm2 start ecosystem.config.js --only my-api

# Start with environment
pm2 start ecosystem.config.js --env production

# Restart
pm2 restart ecosystem.config.js

# Delete all
pm2 delete ecosystem.config.js
```

---

## Monitoring

### Built-in Monitor

```bash
# Real-time dashboard
pm2 monit
```

This shows:
- CPU and memory usage
- Logs
- Metadata
- Custom metrics

### Process Metrics

```bash
# Current metrics
pm2 show app_name

# Metrics as JSON
pm2 prettylist
```

### PM2 Plus (Optional)

```bash
# Connect to PM2 Plus dashboard
pm2 plus
```

Provides:
- Web dashboard
- Historical metrics
- Exception tracking
- Transaction tracing

---

## Log Management

### Viewing Logs

```bash
# All logs
pm2 logs

# Specific app
pm2 logs app_name

# Last N lines
pm2 logs --lines 100

# Real-time follow
pm2 logs --follow

# Only errors
pm2 logs --err

# Only output
pm2 logs --out

# JSON format
pm2 logs --json

# With timestamps
pm2 logs --timestamp
```

### Log Files Location

Default: `~/.pm2/logs/`

Files:
- `{app-name}-out.log` - stdout
- `{app-name}-error.log` - stderr

### Log Rotation

```bash
# Install log rotate module
pm2 install pm2-logrotate

# Configure
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 7
pm2 set pm2-logrotate:compress true
pm2 set pm2-logrotate:rotateInterval '0 0 * * *'
```

### Flushing Logs

```bash
# Flush all logs
pm2 flush

# Flush specific app
pm2 flush app_name

# Reopen logs (for external rotation)
pm2 reloadLogs
```

---

## Cluster Mode

### What is Cluster Mode?

- Runs multiple instances of your app
- Load balances across CPU cores
- Zero-downtime reloads
- Shared port

### Starting in Cluster Mode

```bash
# Auto-detect CPUs
pm2 start app.js -i max

# Specific number
pm2 start app.js -i 4

# Half of CPUs
pm2 start app.js -i -1
```

### Scaling

```bash
# Scale to 4 instances
pm2 scale app_name 4

# Add 2 more instances
pm2 scale app_name +2

# Remove 1 instance
pm2 scale app_name -1
```

### Graceful Reload

```bash
# Zero-downtime reload
pm2 reload app_name
pm2 reload all
```

In your app, handle the shutdown signal:
```javascript
process.on('SIGINT', function() {
  // Cleanup connections
  db.close();
  server.close(() => {
    process.exit(0);
  });
});
```

---

## Deployment

### Startup Script

```bash
# Generate startup script
pm2 startup
# Follow the printed command

# Save current process list
pm2 save

# Resurrect saved processes
pm2 resurrect
```

### Deployment Configuration

```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'my-app',
    script: 'app.js'
  }],

  deploy: {
    production: {
      user: 'deploy',
      host: 'server.com',
      ref: 'origin/main',
      repo: 'git@github.com:user/repo.git',
      path: '/var/www/app',
      'pre-deploy': 'git fetch --all',
      'post-deploy': 'npm install && pm2 reload ecosystem.config.js --env production',
      env: {
        NODE_ENV: 'production'
      }
    },
    staging: {
      user: 'deploy',
      host: 'staging.server.com',
      ref: 'origin/develop',
      repo: 'git@github.com:user/repo.git',
      path: '/var/www/app',
      'post-deploy': 'npm install && pm2 reload ecosystem.config.js --env staging'
    }
  }
};
```

### Deploy Commands

```bash
# Initial setup (first time)
pm2 deploy production setup

# Deploy
pm2 deploy production

# Deploy specific commit
pm2 deploy production commit_hash

# Revert to previous deployment
pm2 deploy production revert 1

# Execute command on server
pm2 deploy production exec "pm2 list"
```

---

## Common Patterns

### Auto-Restart on Crash

Already enabled by default. Configure limits:
```javascript
{
  max_restarts: 10,
  min_uptime: '5s',        // Consider crash if exits within 5s
  restart_delay: 4000      // Wait 4s before restart
}
```

### Memory Limit Restart

```javascript
{
  max_memory_restart: '500M'
}
```

### Scheduled Restarts

```javascript
{
  cron_restart: '0 3 * * *'  // Restart daily at 3 AM
}
```

### Graceful Shutdown

```javascript
// In your app
process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);

function gracefulShutdown() {
  console.log('Received shutdown signal');

  server.close(() => {
    console.log('HTTP server closed');

    // Close database connections
    database.close(() => {
      console.log('Database closed');
      process.exit(0);
    });
  });

  // Force exit after 10s
  setTimeout(() => {
    process.exit(1);
  }, 10000);
}
```

### Wait for Ready

```javascript
// ecosystem.config.js
{
  wait_ready: true,
  listen_timeout: 10000
}

// In your app
app.listen(port, () => {
  process.send('ready');  // Tell PM2 app is ready
});
```

---

## Quick Reference

```bash
# Starting
pm2 start app.js              # Start app
pm2 start app.js --name api   # Start with name
pm2 start app.js -i max       # Cluster mode

# Managing
pm2 list                      # List processes
pm2 stop all                  # Stop all
pm2 restart all               # Restart all
pm2 reload all                # Zero-downtime reload
pm2 delete all                # Delete all

# Monitoring
pm2 monit                     # Dashboard
pm2 logs                      # View logs
pm2 show app                  # Process details

# Persistence
pm2 save                      # Save process list
pm2 resurrect                 # Restore saved list
pm2 startup                   # Enable boot startup

# Ecosystem
pm2 start ecosystem.config.js                 # Start
pm2 start ecosystem.config.js --env production # With env
pm2 deploy production                         # Deploy
```
