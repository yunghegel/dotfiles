****# WireGuard VPN Guide

A guide to WireGuard - a modern, fast, and secure VPN.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Key Concepts](#key-concepts)
4. [Configuration](#configuration)◊◊◊
```

```
| Option | Description |
|--------|-------------|
| `PrivateKey` | Your private key |
| `Address` | Your VPN IP address |
| `ListenPort` | UDP port to listen on |
| `DNS` | DNS servers (client only) |
| `MTU` | Interface MTU |
| `PostUp` | Command run after interface up |
| `PostDown` | Command run after interface down |
| `SaveConfig` | Save runtime config changes |

**Peer Section:**

| Option | Description |
|--------|-------------|
| `PublicKey` | Peer's public key |
| `PresharedKey` | Optional extra encryption |
| `AllowedIPs` | IPs to route through this peer |
| `Endpoint` | Peer's IP:port |
| `PersistentKeepalive` | Seconds between keepalives |

---

## Common Setups

### Basic VPN (Server + Client)

**1. Generate keys on both machines:**

Server:
```bash
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
sudo chmod 600 /etc/wireguard/private.key
```

Client:
```bash
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
sudo chmod 600 /etc/wireguard/private.key
```

**2. Create server config:**

```bash
sudo nano /etc/wireguard/wg0.conf
```

```ini
[Interface]
PrivateKey = <server-private-key>
Address = 10.0.0.1/24
ListenPort = 51820
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.0.0.2/32
```

**3. Create client config:**

```ini
[Interface]
PrivateKey = <client-private-key>
Address = 10.0.0.2/32
DNS = 1.1.1.1

[Peer]
PublicKey = <server-public-key>
AllowedIPs = 0.0.0.0/0
Endpoint = <server-ip>:51820
PersistentKeepalive = 25
```

**4. Enable IP forwarding on server:**

```bash
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

**5. Start WireGuard:**

Server:
```bash
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0
```

Client:
```bash
sudo wg-quick up wg0
```

### Split Tunnel (Only Some Traffic)

Route only specific networks through VPN:

```ini
[Peer]
PublicKey = <server-public-key>
AllowedIPs = 10.0.0.0/24, 192.168.1.0/24
Endpoint = server:51820
```

### Full Tunnel (All Traffic)

Route all traffic through VPN:

```ini
[Peer]
PublicKey = <server-public-key>
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = server:51820
```

### Site-to-Site

Connect two networks:

**Site A (10.1.0.0/24):**
```ini
[Interface]
PrivateKey = <site-a-private>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <site-b-public>
AllowedIPs = 10.0.0.2/32, 10.2.0.0/24
Endpoint = site-b.example.com:51820
```

**Site B (10.2.0.0/24):**
```ini
[Interface]
PrivateKey = <site-b-private>
Address = 10.0.0.2/24
ListenPort = 51820

[Peer]
PublicKey = <site-a-public>
AllowedIPs = 10.0.0.1/32, 10.1.0.0/24
Endpoint = site-a.example.com:51820
```

---

## Management

### Interface Commands

```bash
# Start interface
sudo wg-quick up wg0

# Stop interface
sudo wg-quick down wg0

# Show status
sudo wg show
sudo wg show wg0

# Show brief status
sudo wg
```

### Systemd Service

```bash
# Enable auto-start on boot
sudo systemctl enable wg-quick@wg0

# Start/stop/restart
sudo systemctl start wg-quick@wg0
sudo systemctl stop wg-quick@wg0
sudo systemctl restart wg-quick@wg0

# Status
sudo systemctl status wg-quick@wg0
```

### Adding Peers Dynamically

```bash
# Add peer
sudo wg set wg0 peer <public-key> allowed-ips 10.0.0.3/32

# With endpoint
sudo wg set wg0 peer <public-key> allowed-ips 10.0.0.3/32 endpoint 1.2.3.4:51820

# Remove peer
sudo wg set wg0 peer <public-key> remove
```

### Viewing Status

```bash
# Show all interfaces
sudo wg

# Detailed output
sudo wg show wg0

# Show specific info
sudo wg show wg0 public-key
sudo wg show wg0 private-key
sudo wg show wg0 peers
sudo wg show wg0 endpoints
sudo wg show wg0 allowed-ips
sudo wg show wg0 transfer
```

---

## Troubleshooting

### Connection Issues

**Check interface is up:**
```bash
ip a show wg0
```

**Check WireGuard status:**
```bash
sudo wg show
```

**Verify endpoint is reachable:**
```bash
nc -zvu server.example.com 51820
```

**Check firewall:**
```bash
# Allow WireGuard port
sudo ufw allow 51820/udp
```

### No Handshake

If `latest handshake` shows "never":

1. Verify keys match (server has client public key, vice versa)
2. Check endpoint is correct
3. Verify port is open on server
4. Check for NAT issues

### No Internet Through VPN

**Enable IP forwarding:**
```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

**Check NAT rules:**
```bash
sudo iptables -t nat -L POSTROUTING
```

**Verify AllowedIPs includes 0.0.0.0/0:**
```ini
AllowedIPs = 0.0.0.0/0, ::/0
```

### DNS Not Working

Add DNS to interface:
```ini
[Interface]
DNS = 1.1.1.1, 8.8.8.8
```

Or configure resolvconf:
```bash
sudo apt install resolvconf
```

### Debug Logging

```bash
# Enable debug
echo module wireguard +p | sudo tee /sys/kernel/debug/dynamic_debug/control

# View logs
sudo dmesg | grep wireguard

# Disable debug
echo module wireguard -p | sudo tee /sys/kernel/debug/dynamic_debug/control
```

---

## Security Best Practices

1. **Protect private keys**
   ```bash
   chmod 600 /etc/wireguard/private.key
   chmod 600 /etc/wireguard/wg0.conf
   ```

2. **Use pre-shared keys** for extra security
   ```bash
   wg genpsk > preshared.key
   ```

3. **Limit AllowedIPs** to only necessary ranges

4. **Regular key rotation** - Generate new keys periodically

5. **Minimal peers** - Only add trusted devices

6. **Firewall** - Restrict access to WireGuard port

---

## Quick Reference

### Generate Keys
```bash
wg genkey | tee private.key | wg pubkey > public.key
```

### Start/Stop
```bash
sudo wg-quick up wg0
sudo wg-quick down wg0
```

### Status
```bash
sudo wg show
```

### Enable on Boot
```bash
sudo systemctl enable wg-quick@wg0
```

### Config Location
```
/etc/wireguard/wg0.conf
```

### Default Port
```
51820/udp
```
