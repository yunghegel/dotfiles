# Docker Guide

A comprehensive guide to Docker installation and usage.

## Table of Contents

1. [Installation](#installation)
2. [Core Concepts](#core-concepts)
3. [Essential Commands](#essential-commands)
4. [Working with Images](#working-with-images)
5. [Working with Containers](#working-with-containers)
6. [Docker Compose](#docker-compose)
7. [Networking](#networking)
8. [Volumes and Data](#volumes-and-data)
9. [Best Practices](#best-practices)

---

## Installation

Run the installer:
```bash
./installers/05-docker.sh
```

**What gets installed:**
- Docker Engine (docker-ce)
- Docker CLI (docker-ce-cli)
- containerd runtime
- User added to `docker` group

**Post-installation:**
```bash
# Log out and back in for group changes
# Or run:
newgrp docker

# Verify installation
docker run hello-world
```

---

## Core Concepts

### Images vs Containers

| Concept | Description |
|---------|-------------|
| **Image** | Read-only template with instructions for creating a container |
| **Container** | Runnable instance of an image |
| **Registry** | Storage for images (Docker Hub, GitHub Container Registry) |
| **Dockerfile** | Text file with instructions to build an image |

### Architecture

```
┌─────────────────────────────────────────┐
│              Docker Host                │
│  ┌─────────────────────────────────┐   │
│  │         Docker Daemon           │   │
│  │  ┌─────────┐  ┌─────────┐      │   │
│  │  │Container│  │Container│ ...  │   │
│  │  └─────────┘  └─────────┘      │   │
│  │  ┌─────────────────────────┐   │   │
│  │  │        Images           │   │   │
│  │  └─────────────────────────┘   │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

---

## Essential Commands

### Quick Reference

| Command | Description |
|---------|-------------|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker images` | List images |
| `docker run` | Create and start container |
| `docker stop` | Stop container |
| `docker start` | Start stopped container |
| `docker rm` | Remove container |
| `docker rmi` | Remove image |
| `docker logs` | View container logs |
| `docker exec` | Run command in container |

### System Commands

```bash
# Docker version and info
docker version
docker info

# Disk usage
docker system df

# Clean up unused resources
docker system prune        # Remove unused data
docker system prune -a     # Remove all unused images too
docker system prune --volumes  # Include volumes
```

---

## Working with Images

### Pulling Images

```bash
# Pull from Docker Hub
docker pull nginx
docker pull node:20
docker pull postgres:16-alpine

# Pull from other registries
docker pull ghcr.io/user/image:tag
docker pull myregistry.com/image:tag
```

### Listing Images

```bash
docker images
docker images -a              # Include intermediate images
docker images --filter "dangling=true"  # Untagged images
```

### Building Images

**Dockerfile example:**
```dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000
CMD ["npm", "start"]
```

**Build commands:**
```bash
docker build -t myapp .
docker build -t myapp:v1.0 .
docker build -t myapp:latest -f Dockerfile.prod .
docker build --no-cache -t myapp .
```

### Managing Images

```bash
# Tag image
docker tag myapp myregistry.com/myapp:v1.0

# Push to registry
docker push myregistry.com/myapp:v1.0

# Remove image
docker rmi nginx
docker rmi -f nginx          # Force remove

# Remove unused images
docker image prune
docker image prune -a        # Remove all unused
```

---

## Working with Containers

### Running Containers

```bash
# Basic run
docker run nginx

# Common options
docker run -d nginx                    # Detached (background)
docker run -it ubuntu bash             # Interactive with TTY
docker run --name webserver nginx      # Named container
docker run -p 8080:80 nginx            # Port mapping
docker run -v /host:/container nginx   # Volume mount
docker run -e VAR=value nginx          # Environment variable
docker run --rm nginx                  # Remove when stopped

# Combined example
docker run -d \
  --name myapp \
  -p 3000:3000 \
  -v $(pwd):/app \
  -e NODE_ENV=development \
  --restart unless-stopped \
  node:20
```

### Container Lifecycle

```bash
# Start/stop
docker start container_name
docker stop container_name
docker restart container_name

# Pause/unpause
docker pause container_name
docker unpause container_name

# Kill (force stop)
docker kill container_name

# Remove
docker rm container_name
docker rm -f container_name    # Force remove running
docker rm $(docker ps -aq)     # Remove all containers
```

### Inspecting Containers

```bash
# List containers
docker ps                      # Running only
docker ps -a                   # All containers
docker ps -q                   # IDs only

# Detailed info
docker inspect container_name
docker inspect -f '{{.NetworkSettings.IPAddress}}' container_name

# Logs
docker logs container_name
docker logs -f container_name         # Follow
docker logs --tail 100 container_name # Last 100 lines
docker logs --since 1h container_name # Last hour

# Resource usage
docker stats
docker stats container_name

# Running processes
docker top container_name
```

### Executing Commands

```bash
# Run command in running container
docker exec container_name ls -la
docker exec -it container_name bash    # Interactive shell
docker exec -it container_name sh      # For Alpine images

# As different user
docker exec -u root container_name command

# With environment variable
docker exec -e VAR=value container_name command
```

### Copying Files

```bash
# Copy to container
docker cp file.txt container_name:/path/

# Copy from container
docker cp container_name:/path/file.txt .

# Copy directory
docker cp ./local_dir container_name:/container_dir
```

---

## Docker Compose

### Basic docker-compose.yml

```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
    environment:
      - NODE_ENV=development
    depends_on:
      - db

  db:
    image: postgres:16-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: myapp

volumes:
  postgres_data:
```

### Compose Commands

```bash
# Start services
docker compose up
docker compose up -d              # Detached
docker compose up --build         # Rebuild images

# Stop services
docker compose down
docker compose down -v            # Remove volumes too

# View status
docker compose ps
docker compose logs
docker compose logs -f service_name

# Execute in service
docker compose exec web bash

# Scale services
docker compose up -d --scale web=3
```

---

## Networking

### Network Types

| Type | Description |
|------|-------------|
| `bridge` | Default. Isolated network on host |
| `host` | Use host's network directly |
| `none` | No networking |
| `overlay` | Multi-host networking (Swarm) |

### Network Commands

```bash
# List networks
docker network ls

# Create network
docker network create mynetwork
docker network create --driver bridge mynetwork

# Connect container to network
docker network connect mynetwork container_name
docker network disconnect mynetwork container_name

# Inspect network
docker network inspect mynetwork

# Remove network
docker network rm mynetwork
docker network prune    # Remove unused
```

### Container Communication

```bash
# Containers on same network can communicate by name
docker network create app-network
docker run -d --name db --network app-network postgres
docker run -d --name web --network app-network myapp

# In web container, 'db' resolves to database container
# Connection string: postgres://db:5432/mydb
```

---

## Volumes and Data

### Volume Types

| Type | Description |
|------|-------------|
| Named volumes | Docker-managed, persist after container removal |
| Bind mounts | Map host directory to container |
| tmpfs | In-memory, temporary |

### Volume Commands

```bash
# Create volume
docker volume create myvolume

# List volumes
docker volume ls

# Inspect volume
docker volume inspect myvolume

# Remove volume
docker volume rm myvolume
docker volume prune    # Remove unused
```

### Using Volumes

```bash
# Named volume
docker run -v myvolume:/data nginx

# Bind mount
docker run -v /host/path:/container/path nginx
docker run -v $(pwd):/app node

# Read-only
docker run -v /host/path:/container/path:ro nginx

# tmpfs (in-memory)
docker run --tmpfs /tmp nginx
```

---

## Best Practices

### Dockerfile Best Practices

```dockerfile
# Use specific version tags
FROM node:20-alpine

# Use multi-stage builds
FROM node:20 AS builder
WORKDIR /app
COPY . .
RUN npm ci && npm run build

FROM node:20-alpine
COPY --from=builder /app/dist ./dist

# Minimize layers - combine RUN commands
RUN apt-get update && \
    apt-get install -y package && \
    rm -rf /var/lib/apt/lists/*

# Use .dockerignore
# Copy package files first for better caching
COPY package*.json ./
RUN npm ci
COPY . .

# Don't run as root
USER node

# Use EXPOSE for documentation
EXPOSE 3000

# Prefer COPY over ADD
COPY . .

# Use exec form for CMD
CMD ["node", "server.js"]
```

### Security

```bash
# Run as non-root user
docker run --user 1000:1000 myapp

# Read-only filesystem
docker run --read-only myapp

# Drop capabilities
docker run --cap-drop ALL myapp

# Limit resources
docker run --memory="256m" --cpus="0.5" myapp

# No new privileges
docker run --security-opt no-new-privileges myapp
```

### Resource Limits

```bash
# Memory limits
docker run -m 512m myapp          # Hard limit
docker run --memory-reservation 256m myapp  # Soft limit

# CPU limits
docker run --cpus 2 myapp         # Max 2 CPUs
docker run --cpu-shares 512 myapp # Relative weight

# Combined
docker run -m 1g --cpus 2 myapp
```

---

## Troubleshooting

### Common Issues

**Container exits immediately:**
```bash
# Check logs
docker logs container_name

# Run interactively to debug
docker run -it image_name bash
```

**Port already in use:**
```bash
# Find what's using the port
lsof -i :3000
# or
docker ps --filter "publish=3000"
```

**Permission denied:**
```bash
# Fix socket permissions
sudo chmod 666 /var/run/docker.sock

# Or add user to docker group
sudo usermod -aG docker $USER
```

**Out of disk space:**
```bash
# Check usage
docker system df

# Clean up
docker system prune -a --volumes
```

### Debugging Commands

```bash
# Get container IP
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container

# Check container health
docker inspect --format='{{.State.Health.Status}}' container

# Export container filesystem
docker export container > container.tar

# View container changes
docker diff container
```
