# Node.js and Java Development Guide

A guide to NVM (Node Version Manager) and SDKMAN for managing Node.js and Java installations.

## Table of Contents

1. [Node.js with NVM](#nodejs-with-nvm)
2. [Java with SDKMAN](#java-with-sdkman)

---

# Node.js with NVM

## Overview

NVM (Node Version Manager) allows you to:
- Install multiple Node.js versions
- Switch between versions easily
- Set per-project Node.js versions
- Avoid permission issues with global packages

## Installation

Run the installer:
```bash
./installers/03-nodejs.sh [version]
```

**Examples:**
```bash
./installers/03-nodejs.sh      # Installs Node.js 20 (default)
./installers/03-nodejs.sh 18   # Installs Node.js 18
./installers/03-nodejs.sh 22   # Installs Node.js 22
```

**Manual installation:**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.bashrc  # or ~/.zshrc
```

## Basic Usage

### Listing Versions

```bash
# List installed versions
nvm ls

# List available versions
nvm ls-remote

# List LTS versions only
nvm ls-remote --lts
```

### Installing Node.js

```bash
# Install latest version
nvm install node

# Install latest LTS
nvm install --lts

# Install specific version
nvm install 20
nvm install 18.19.0
nvm install 16.20.2

# Install and use
nvm install 20 && nvm use 20
```

### Switching Versions

```bash
# Use installed version
nvm use 20
nvm use 18
nvm use node     # Latest
nvm use --lts    # Latest LTS

# Use for current shell only
nvm use 20

# Set default for new shells
nvm alias default 20
```

### Managing Versions

```bash
# Show current version
nvm current
node --version
npm --version

# Uninstall version
nvm uninstall 16

# Reinstall packages from another version
nvm install 20 --reinstall-packages-from=18
```

## Project-Specific Versions

### Using .nvmrc

Create `.nvmrc` in your project root:
```bash
echo "20" > .nvmrc
# or
echo "lts/*" > .nvmrc
# or
echo "18.19.0" > .nvmrc
```

Then use:
```bash
nvm use
# Reads version from .nvmrc
```

### Auto-Switching (ZSH)

Add to `~/.zshrc`:
```bash
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
```

## NPM and Packages

### Global Packages

```bash
# Install globally
npm install -g package-name

# List global packages
npm list -g --depth=0

# Location of global packages
npm root -g

# Update all global packages
npm update -g
```

### Common Global Packages

```bash
npm install -g typescript
npm install -g ts-node
npm install -g nodemon
npm install -g pm2
npm install -g eslint
npm install -g prettier
npm install -g http-server
npm install -g serve
```

### Migrating Packages

When installing a new Node.js version:
```bash
nvm install 22 --reinstall-packages-from=20
```

Or manually:
```bash
# Export list from old version
nvm use 20
npm list -g --depth=0 > packages.txt

# Install in new version
nvm use 22
# Install packages from list
```

## Troubleshooting

### NVM Command Not Found

```bash
# Add to shell config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### Slow Shell Startup

Use lazy loading:
```bash
# Add to ~/.zshrc instead of normal init
nvm() {
  unset -f nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
```

### Permission Errors

NVM installs to `~/.nvm`, avoiding sudo. If issues:
```bash
# Fix permissions
sudo chown -R $(whoami) ~/.nvm
```

---

# Java with SDKMAN

## Overview

SDKMAN provides:
- Multiple Java versions (JDK, JRE)
- Various JDK distributions (Temurin, GraalVM, etc.)
- Other JVM tools (Gradle, Maven, Kotlin, etc.)
- Easy version switching

## Installation

Run the installer:
```bash
./installers/04-java.sh [version]
```

**Examples:**
```bash
./installers/04-java.sh      # Installs Java 17 (default)
./installers/04-java.sh 21   # Installs Java 21
./installers/04-java.sh 11   # Installs Java 11
```

**Manual installation:**
```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

## Basic Usage

### Listing Versions

```bash
# List all available Java versions
sdk list java

# List installed versions
sdk list java | grep installed

# List other SDKs
sdk list gradle
sdk list maven
sdk list kotlin
```

### Installing Java

```bash
# Install latest stable
sdk install java

# Install specific version
sdk install java 21.0.2-tem      # Temurin 21
sdk install java 17.0.10-tem     # Temurin 17
sdk install java 11.0.22-tem     # Temurin 11

# Install from different vendors
sdk install java 21.0.2-graalce  # GraalVM CE
sdk install java 21.0.2-zulu     # Azul Zulu
sdk install java 21.0.2-amzn     # Amazon Corretto
sdk install java 21.0.2-oracle   # Oracle
```

### Switching Versions

```bash
# Use version in current shell
sdk use java 21.0.2-tem

# Set default version
sdk default java 21.0.2-tem

# Show current version
sdk current java
java --version
```

### Managing Versions

```bash
# Uninstall version
sdk uninstall java 11.0.22-tem

# Update SDKMAN itself
sdk selfupdate

# Upgrade SDK candidate
sdk upgrade java

# Flush caches
sdk flush
```

## JDK Distributions

| Distribution | Identifier | Description |
|--------------|------------|-------------|
| Eclipse Temurin | `-tem` | Recommended, HotSpot VM |
| GraalVM CE | `-graalce` | High performance, polyglot |
| Amazon Corretto | `-amzn` | AWS-optimized |
| Azul Zulu | `-zulu` | Wide platform support |
| Oracle | `-oracle` | Official Oracle JDK |
| Microsoft | `-ms` | Azure-optimized |
| Liberica | `-librca` | Full JDK with JavaFX |
| SAP Machine | `-sapmchn` | SAP-optimized |

### Choosing a Distribution

- **General use**: Temurin (`-tem`)
- **Performance**: GraalVM (`-graalce`)
- **AWS deployment**: Corretto (`-amzn`)
- **Azure deployment**: Microsoft (`-ms`)
- **JavaFX apps**: Liberica Full (`-librca`)

## Project-Specific Versions

### Using .sdkmanrc

Create `.sdkmanrc` in project root:
```
java=17.0.10-tem
gradle=8.5
maven=3.9.6
```

Enable auto-switching:
```bash
sdk env install    # Install versions from .sdkmanrc
sdk env            # Switch to project versions
sdk env clear      # Return to defaults
```

Auto-switch on directory change:
```bash
# Add to ~/.sdkman/etc/config
sdkman_auto_env=true
```

## Other SDKs

### Build Tools

```bash
# Gradle
sdk install gradle
sdk install gradle 8.5

# Maven
sdk install maven
sdk install maven 3.9.6

# Ant
sdk install ant
```

### Languages

```bash
# Kotlin
sdk install kotlin

# Scala
sdk install scala

# Groovy
sdk install groovy
```

### Frameworks and Tools

```bash
# Spring Boot CLI
sdk install springboot

# Micronaut
sdk install micronaut

# Quarkus
sdk install quarkus
```

### Listing All SDKs

```bash
sdk list
```

## Environment Configuration

### JAVA_HOME

SDKMAN automatically sets `JAVA_HOME`:
```bash
echo $JAVA_HOME
# /home/user/.sdkman/candidates/java/current
```

The `current` symlink points to your default version.

### Shell Configuration

Add to `~/.bashrc` or `~/.zshrc`:
```bash
# SDKMAN initialization
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
```

## Troubleshooting

### SDK Command Not Found

```bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
```

### JAVA_HOME Not Set

```bash
# Verify current version
sdk current java

# Re-set default
sdk default java 17.0.10-tem
```

### Version Not Found

```bash
# Update candidate list
sdk update

# Check available versions
sdk list java
```

### Offline Mode

```bash
# Enable offline mode
sdk offline enable

# Disable offline mode
sdk offline disable
```

---

## Quick Reference

### NVM Commands

| Command | Description |
|---------|-------------|
| `nvm install 20` | Install Node.js 20 |
| `nvm use 20` | Switch to Node.js 20 |
| `nvm alias default 20` | Set default version |
| `nvm ls` | List installed versions |
| `nvm ls-remote --lts` | List available LTS |
| `nvm current` | Show current version |

### SDKMAN Commands

| Command | Description |
|---------|-------------|
| `sdk install java` | Install latest Java |
| `sdk install java 21.0.2-tem` | Install specific version |
| `sdk use java 17.0.10-tem` | Use version in shell |
| `sdk default java 17.0.10-tem` | Set default version |
| `sdk list java` | List available versions |
| `sdk current java` | Show current version |
| `sdk env` | Use project's .sdkmanrc |
