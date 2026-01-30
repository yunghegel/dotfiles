#!/bin/bash

# 09-monitoring.sh - Loki and Grafana monitoring setup
# This script installs and configures Loki and Grafana

set -e

echo "=== Monitoring Stack Installation (Loki + Grafana) ==="

# Install Loki
echo "Installing Loki..."
LOKI_VERSION="2.9.1"
wget "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo chmod +x /usr/local/bin/loki
rm loki-linux-amd64.zip

# Install Grafana
echo "Installing Grafana..."
sudo apt-get install -y gnupg2 software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana

# Configure Grafana to run on port 3001
echo "Configuring Grafana..."
sudo sed -i 's/;http_port = 3000/http_port = 3001/' /etc/grafana/grafana.ini

# Create Loki data source configuration
echo "Configuring Loki data source..."
sudo mkdir -p /etc/grafana/provisioning/datasources
cat << EOF | sudo tee /etc/grafana/provisioning/datasources/loki.yaml >/dev/null
apiVersion: 1
datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://localhost:3100
    isDefault: true
EOF

# Create basic Loki configuration
echo "Creating Loki configuration..."
sudo mkdir -p /etc/loki
cat << EOF | sudo tee /etc/loki/config.yml >/dev/null
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 168h

storage_config:
  boltdb:
    directory: /tmp/loki/index

  filesystem:
    directory: /tmp/loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
EOF

# Create systemd service for Loki
echo "Creating Loki systemd service..."
cat << EOF | sudo tee /etc/systemd/system/loki.service >/dev/null
[Unit]
Description=Loki
After=network.target

[Service]
Type=simple
User=grafana
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/config.yml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start services
echo "Enabling and starting services..."
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl enable loki
sudo systemctl start loki
sudo systemctl start grafana-server

echo "✅ Monitoring stack installed successfully!"
echo "ℹ️  Grafana Web UI available at: http://localhost:3001"
echo "   Default credentials: admin/admin (change on first login)"
echo "ℹ️  Loki is running on: http://localhost:3100"