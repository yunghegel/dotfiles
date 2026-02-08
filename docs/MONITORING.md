# Monitoring Stack Guide

A guide to Loki (log aggregation) and Grafana (visualization) setup and usage.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Loki](#loki)
4. [Grafana](#grafana)
5. [LogQL Queries](#logql-queries)
6. [Dashboards](#dashboards)
7. [Alerting](#alerting)
8. [Best Practices](#best-practices)

---

## Overview

This monitoring stack provides:

| Component | Purpose | Port |
|-----------|---------|------|
| **Loki** | Log aggregation and storage | 3100 |
| **Grafana** | Visualization and dashboards | 3001 |

**Architecture:**
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Application │───▶│    Loki     │◀───│   Grafana   │
│    Logs     │    │   (Store)   │    │  (Visualize)│
└─────────────┘    └─────────────┘    └─────────────┘
```

---

## Installation

Run the installer:
```bash
./installers/09-monitoring.sh
```

**What gets installed:**
- Loki v2.9.1 binary at `/usr/local/bin/loki`
- Loki configuration at `/etc/loki/config.yml`
- Grafana from official repository
- Systemd services for both
- Loki as default data source in Grafana

**Default Credentials:**
- Grafana: `admin` / `admin` (change on first login)

---

## Loki

### What is Loki?

Loki is a log aggregation system inspired by Prometheus:
- Indexes metadata (labels), not log content
- Highly efficient storage
- Native Grafana integration
- Horizontally scalable

### Configuration

Located at `/etc/loki/config.yml`:

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1

schema_config:
  configs:
    - from: 2020-01-01
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb:
    directory: /tmp/loki/index
  filesystem:
    directory: /tmp/loki/chunks
```

### Service Management

```bash
# Status
sudo systemctl status loki

# Start/Stop/Restart
sudo systemctl start loki
sudo systemctl stop loki
sudo systemctl restart loki

# View logs
sudo journalctl -u loki -f
```

### Sending Logs to Loki

**Using Promtail (official agent):**

Install Promtail and create `/etc/promtail/config.yml`:
```yaml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log

  - job_name: myapp
    static_configs:
      - targets:
          - localhost
        labels:
          job: myapp
          __path__: /var/log/myapp/*.log
```

**Using Docker logging driver:**

```yaml
# docker-compose.yml
services:
  myapp:
    logging:
      driver: loki
      options:
        loki-url: "http://localhost:3100/loki/api/v1/push"
        loki-batch-size: "400"
```

**Using HTTP API directly:**

```bash
curl -X POST http://localhost:3100/loki/api/v1/push \
  -H "Content-Type: application/json" \
  -d '{
    "streams": [{
      "stream": {"app": "myapp", "level": "info"},
      "values": [["'$(date +%s)000000000'", "Hello from myapp"]]
    }]
  }'
```

### API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/loki/api/v1/push` | POST | Push logs |
| `/loki/api/v1/query` | GET | Instant query |
| `/loki/api/v1/query_range` | GET | Range query |
| `/loki/api/v1/labels` | GET | List labels |
| `/loki/api/v1/label/{name}/values` | GET | Label values |
| `/ready` | GET | Readiness check |
| `/metrics` | GET | Prometheus metrics |

---

## Grafana

### Accessing Grafana

Open in browser: `http://localhost:3001`

Default login: `admin` / `admin`

### Initial Setup

1. Log in with default credentials
2. Change admin password when prompted
3. Loki is pre-configured as data source

### Data Sources

Verify Loki connection:
1. Go to **Configuration** > **Data Sources**
2. Click on **Loki**
3. Click **Save & Test**

### Explore Logs

1. Click **Explore** in sidebar
2. Select **Loki** data source
3. Enter LogQL query or use builder
4. Click **Run Query**

---

## LogQL Queries

### Basic Syntax

```
{label="value"} |= "search term"
```

### Stream Selectors

```logql
# Exact match
{app="myapp"}

# Multiple labels
{app="myapp", env="production"}

# Regex match
{app=~"frontend|backend"}

# Not equal
{app!="test"}

# Regex not match
{app!~"test.*"}
```

### Line Filters

| Operator | Description |
|----------|-------------|
| `\|=` | Contains string |
| `!=` | Does not contain |
| `\|~` | Matches regex |
| `!~` | Does not match regex |

```logql
# Contains "error"
{app="myapp"} |= "error"

# Does not contain "debug"
{app="myapp"} != "debug"

# Regex match
{app="myapp"} |~ "error|warning"

# Case insensitive
{app="myapp"} |~ "(?i)error"
```

### Parser Expressions

**JSON parsing:**
```logql
{app="myapp"} | json

# Extract specific fields
{app="myapp"} | json level="level", msg="message"

# Filter on parsed fields
{app="myapp"} | json | level="error"
```

**Logfmt parsing:**
```logql
{app="myapp"} | logfmt

# Example: level=info msg="hello world"
{app="myapp"} | logfmt | level="error"
```

**Pattern parsing:**
```logql
# Apache log format
{job="apache"} | pattern "<ip> - - [<timestamp>] \"<method> <path> <_>\" <status> <size>"

# Filter by extracted field
{job="apache"} | pattern "<ip> - - [<timestamp>] \"<method> <path> <_>\" <status> <size>" | status >= 400
```

**Regex parsing:**
```logql
{app="myapp"} | regexp "level=(?P<level>\\w+)"
```

### Metric Queries

```logql
# Count logs per second
rate({app="myapp"}[5m])

# Count by level
sum by (level) (rate({app="myapp"} | json [5m]))

# Count errors
count_over_time({app="myapp"} |= "error" [1h])

# Bytes per second
bytes_rate({app="myapp"}[5m])

# Top 10 by count
topk(10, sum by (path) (rate({app="myapp"} | json [5m])))
```

### Aggregation Functions

| Function | Description |
|----------|-------------|
| `rate()` | Per-second rate |
| `count_over_time()` | Count in range |
| `bytes_over_time()` | Bytes in range |
| `bytes_rate()` | Bytes per second |
| `sum()` | Sum values |
| `avg()` | Average |
| `min()` | Minimum |
| `max()` | Maximum |
| `topk()` | Top K |
| `bottomk()` | Bottom K |

---

## Dashboards

### Creating a Dashboard

1. Click **+** > **Dashboard**
2. Click **Add visualization**
3. Select **Loki** data source
4. Enter query
5. Configure visualization
6. Click **Apply**
7. **Save dashboard**

### Example Panels

**Log Volume:**
```logql
sum(rate({app="myapp"}[5m])) by (level)
```
- Visualization: Time series
- Legend: `{{level}}`

**Error Rate:**
```logql
sum(rate({app="myapp"} |= "error" [5m]))
  /
sum(rate({app="myapp"}[5m]))
  * 100
```
- Visualization: Stat or Gauge
- Unit: Percent

**Logs Panel:**
```logql
{app="myapp"} | json
```
- Visualization: Logs

**Top Endpoints:**
```logql
topk(10, sum by (path) (count_over_time({app="myapp"} | json [1h])))
```
- Visualization: Bar chart

### Dashboard Variables

Add variables for dynamic filtering:

1. Dashboard settings > **Variables**
2. **Add variable**
   - Name: `app`
   - Type: Query
   - Data source: Loki
   - Query: `label_values(app)`
3. Use in queries: `{app="$app"}`

### Importing Dashboards

1. **+** > **Import**
2. Enter dashboard ID from grafana.com or paste JSON
3. Select data source
4. **Import**

Popular Loki dashboards:
- 13639: Loki Dashboard
- 12611: Logs / App

---

## Alerting

### Creating Alerts

1. Edit panel > **Alert** tab
2. **Create alert rule from this panel**
3. Configure:
   - **Rule name**: Error rate high
   - **Evaluate every**: 1m
   - **For**: 5m
   - **Conditions**: When `last()` of query is above `0.1`
4. Add **notification channel**
5. **Save**

### Alert Query Example

```logql
# Alert when error rate > 5%
sum(rate({app="myapp"} |= "error" [5m]))
  /
sum(rate({app="myapp"}[5m]))
  > 0.05
```

### Notification Channels

Configure under **Alerting** > **Notification channels**:
- Email
- Slack
- PagerDuty
- Webhook
- Microsoft Teams
- Discord

---

## Best Practices

### Label Design

**Good labels:**
```yaml
app: myapp
env: production
host: server01
level: error
```

**Avoid high cardinality labels:**
```yaml
# BAD - unique per request
request_id: abc123
user_id: 12345

# GOOD - limited values
status_code: 200
method: GET
```

### Log Format

**Recommended: Structured JSON**
```json
{
  "timestamp": "2024-02-08T14:30:00Z",
  "level": "error",
  "message": "Failed to connect",
  "service": "api",
  "error": "connection refused",
  "duration_ms": 1500
}
```

### Retention

Configure in Loki config:
```yaml
table_manager:
  retention_deletes_enabled: true
  retention_period: 168h  # 7 days
```

### Performance Tips

1. **Use specific label selectors**
   ```logql
   # Good - specific
   {app="myapp", env="prod"}

   # Bad - too broad
   {env="prod"}
   ```

2. **Limit time range**
   - Start with shorter ranges
   - Expand as needed

3. **Use line filters early**
   ```logql
   # Filters reduce data before parsing
   {app="myapp"} |= "error" | json
   ```

4. **Avoid regex when possible**
   - `|=` is faster than `|~`

---

## Troubleshooting

### Loki Not Starting

```bash
# Check logs
sudo journalctl -u loki -f

# Verify config
loki -config.file=/etc/loki/config.yml -verify-config

# Check port availability
sudo ss -tlnp | grep 3100
```

### No Logs Appearing

1. Verify Loki is receiving logs:
   ```bash
   curl http://localhost:3100/loki/api/v1/labels
   ```

2. Check Promtail/agent logs
3. Verify label selectors match

### Grafana Can't Connect to Loki

1. Check Loki is running:
   ```bash
   curl http://localhost:3100/ready
   ```

2. Verify data source URL in Grafana
3. Check network/firewall rules

### Query Timeout

- Reduce time range
- Add more specific filters
- Check Loki resources (CPU, memory)
