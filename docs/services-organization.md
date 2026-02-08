# Self-Hosted Services Organization Guide

## 1. Core Infrastructure & Virtualization

### Proxmox
A powerful open-source virtualization management platform that combines KVM hypervisor and LXC containers. Proxmox provides enterprise-grade features for managing virtual machines and containers through a web-based interface, offering high availability, backup solutions, and cluster management capabilities.

### Portainer
A lightweight container management platform that provides an intuitive web interface for managing Docker environments. Portainer simplifies container deployment, monitoring, and management, making it easier to visualize and control containerized applications without needing extensive command-line knowledge.

---

## 2. Storage & File Management

### TrueNAS
An enterprise-grade network-attached storage (NAS) operating system built on OpenZFS. TrueNAS offers advanced features including data protection, snapshots, replication, and powerful storage management capabilities. It's ideal for storing and sharing files across your network with high reliability and data integrity.

### Nextcloud (NC)
A self-hosted productivity platform that serves as a private cloud solution. Nextcloud provides file synchronization, sharing, calendars, contacts, and collaboration tools. It's like having your own Dropbox/Google Drive with complete control over your data and extensive plugin ecosystem for additional functionality.

---

## 3. Media Server & Streaming

### Jellyfin
A free and open-source media server that organizes, manages, and streams your personal media collection. Jellyfin provides a beautiful interface for watching movies, TV shows, music, and photos across all your devices. Unlike Plex, it has no premium features locked behind paywalls and respects user privacy.

### Immich
A modern, high-performance self-hosted photo and video backup solution designed as a privacy-focused alternative to Google Photos. Immich offers automatic mobile backup, facial recognition, search capabilities, and a sleek mobile-first interface for managing your personal photo library.

---

## 4. Media Acquisition & Management

### Radarr
An automated movie collection manager that monitors multiple RSS feeds for new releases and integrates with download clients. Radarr automatically searches, downloads, and organizes movies, renaming files according to your preferences and upgrading quality when better versions become available.

### Sonarr
A PVR (Personal Video Recorder) for TV shows that automates the entire process of monitoring, downloading, and organizing your television series. Sonarr tracks upcoming episodes, searches for releases, sends them to download clients, and organizes files with proper naming conventions.

### Prowlarr
An indexer manager and proxy that integrates with your media management applications (Radarr, Sonarr, etc.). Prowlarr centralizes indexer management, allowing you to add indexers once and have them automatically synchronized across all your *arr applications, with built-in search and statistics.

### Whisparr
A specialized fork of Sonarr designed for managing adult content libraries. It provides the same automated monitoring and organization features as Sonarr but is tailored specifically for adult media with appropriate indexers and metadata sources.

### Bazarr
A companion application to Radarr and Sonarr that manages and downloads subtitles for your media library. Bazarr automatically searches for missing subtitles in multiple languages, can fix timing issues, and integrates seamlessly with your existing media management workflow.

### Tdarr
A distributed transcoding system for automating media library optimization. Tdarr can transcode videos to reduce file sizes, standardize formats, remove unwanted audio/subtitle tracks, and ensure compatibility across devices. It supports plugin-based workflows and can utilize multiple nodes for processing.

---

## 5. Download Management

### Deluge
A lightweight, cross-platform BitTorrent client with a clean interface and extensive plugin support. Deluge excels at managing torrent downloads with features like bandwidth scheduling, proxy support, and web-based remote access, making it ideal for automated download systems.

### Flaresolverr
A proxy server that solves Cloudflare and DDoS-GUARD challenges automatically. When your media management tools encounter protected sites, FlareSolverr handles the CAPTCHA and browser challenge verification, allowing seamless access to otherwise protected indexers and trackers.

---

## 6. Monitoring & Observability

### Grafana
A powerful multi-platform analytics and interactive visualization web application. Grafana creates customizable dashboards pulling data from various sources (Prometheus, InfluxDB, etc.) to monitor system metrics, application performance, and infrastructure health with beautiful, real-time visualizations.

### Prometheus
An open-source systems monitoring and alerting toolkit designed for reliability and scalability. Prometheus collects and stores metrics as time-series data, provides a powerful query language (PromQL), and can trigger alerts based on threshold conditions across your infrastructure.

### InfluxDB
A high-performance time-series database optimized for fast storage and retrieval of time-stamped data. InfluxDB is perfect for storing metrics, events, and real-time analytics from sensors, applications, and infrastructure components with efficient compression and querying.

### UptimeKuma
A fancy, self-hosted monitoring tool with a beautiful, modern interface. Uptime Kuma monitors websites, APIs, and services, tracking their availability and response times. It provides status pages, notifications through multiple channels, and detailed uptime statistics.

### Jellystat
A comprehensive statistics and monitoring tool specifically designed for Jellyfin media servers. Jellystat tracks viewing habits, popular content, user activity, library growth, and server performance, providing insights into how your media server is being used.

### Cleanuperr
An automated maintenance tool for Radarr and Sonarr that helps manage and clean up your media libraries. Cleanuperr can remove unwanted releases, handle stalled downloads, and perform routine maintenance tasks to keep your media management system running smoothly.

---

## 7. Network & Security

### Caddy
A modern, enterprise-ready web server with automatic HTTPS. Caddy simplifies reverse proxy configuration, automatically obtains and renews SSL certificates, and provides a simple configuration syntax. It's perfect for exposing services securely with minimal setup.

### Cloudflare
Integration with Cloudflare's CDN and security services. This provides DDoS protection, SSL/TLS encryption, DNS management, and performance optimization for your services. Cloudflare acts as a protective layer between your infrastructure and the internet.

### Gluetun
A lightweight VPN client container that supports multiple VPN providers. Gluetun allows you to route specific containers' traffic through a VPN, perfect for ensuring download clients and torrent applications maintain privacy without affecting your entire network.

### Pi-hole (Pinhole)
A network-wide ad blocker that functions as a DNS sinkhole. Pi-hole blocks advertisements and tracking at the network level, protecting all devices on your network without requiring individual software installation. It also provides detailed statistics on DNS queries and blocking.

### Home Assistant (HA)
An open-source home automation platform that puts local control and privacy first. Home Assistant integrates thousands of smart home devices and services, allowing you to create automations, monitor sensors, and control your entire smart home from a single interface.

---

## 8. Authentication & Access Control

### Authentik
A modern, flexible identity provider (IdP) supporting SSO, OAuth2, SAML, and LDAP. Authentik provides centralized authentication for all your services, enabling single sign-on, multi-factor authentication, and fine-grained access control with a user-friendly interface.

### Vault Warden
An unofficial Bitwarden-compatible server written in Rust, providing a lightweight password manager solution. Vault Warden allows you to self-host your password vault with all premium Bitwarden features, keeping your credentials secure and under your control.

---

## 9. Productivity & Collaboration

### Paperless-ngx
A document management system that transforms your physical documents into a searchable digital archive. Paperless automatically processes scanned documents with OCR, extracts metadata, applies tags, and creates a fully searchable database of all your papers with version tracking.

### Firefly III
A personal finance manager that helps you track expenses, manage budgets, and understand your spending habits. Firefly III provides detailed financial reports, supports multiple accounts and currencies, and helps you gain control over your finances with comprehensive transaction management.

### JupyterLab
An interactive development environment for notebooks, code, and data. JupyterLab provides a flexible interface for data science and scientific computing, supporting Python, R, Julia, and other languages with integrated terminals, text editors, and rich output visualization.

### JellySeerr
A request management and media discovery tool for Jellyfin users. JellySeerr allows users to request movies and TV shows, which are then automatically forwarded to Radarr/Sonarr for download. It features user management, request tracking, and integration with notification services.

---

## 10. Development & Administration

### Code-server
Visual Studio Code running in your browser, providing a full-featured development environment accessible from anywhere. Code-server offers the complete VS Code experience with extensions, debugging, and terminal access, perfect for remote development and collaboration.

### PhpMyAdmin
A web-based administration tool for MySQL and MariaDB databases. PhpMyAdmin provides an intuitive interface for managing databases, tables, and queries without requiring command-line access, making database administration accessible through a browser.

### Subgen
An automated subtitle generation tool that creates subtitles for media using speech-to-text technology. Subgen can generate subtitles for content lacking them, supporting multiple languages and integrating with media management workflows to ensure accessibility.

### Profilarr
A profile and quality management tool for Radarr and Sonarr. Profilarr helps maintain consistent quality settings across your media libraries, making it easier to manage multiple profiles and ensure your media meets your preferred specifications.

---

## 11. Utilities & Tools

### Stirling-PDF
A locally hosted web application for PDF manipulation. Stirling-PDF provides tools for merging, splitting, rotating, compressing PDFs, and many other operations. It's privacy-focused with no data leaving your server, offering a comprehensive PDF toolkit through a web interface.

### FreshRSS
A self-hosted RSS feed aggregator that keeps you updated on your favorite websites. FreshRSS provides a fast, customizable reading experience with features like filtering, tagging, sharing, and support for multiple users, giving you control over your news consumption.

### Speedtest
A self-hosted internet speed testing tool that monitors your connection performance over time. This service allows you to track bandwidth, latency, and connection quality, helping identify network issues and verify ISP service levels.

### Firefox
A containerized version of the Firefox web browser accessible via web interface. This provides a disposable, isolated browsing environment accessible from any device, useful for testing, privacy-focused browsing, or accessing services from a consistent environment.

### Aphrodite
A text generation web UI for AI language models. Aphrodite provides an interface for running and interacting with large language models locally, offering features for creative writing, code generation, and various text-based AI tasks with customizable parameters.

### Huntarr
A monitoring and statistics tool for download clients and media management applications. Huntarr tracks download history, success rates, and performance metrics, helping optimize your automated media acquisition setup.

---

## Category Summary

**Core Infrastructure (2)**: Foundation services for running virtual machines and containers
**Storage & Files (2)**: Network storage and file synchronization solutions
**Media Streaming (2)**: Services for consuming your media library
**Media Management (6)**: Tools for acquiring, organizing, and maintaining media
**Downloads (2)**: Torrent and download automation tools
**Monitoring (6)**: System and application performance tracking
**Network & Security (5)**: VPN, firewall, DNS, and network protection
**Authentication (2)**: Identity and credential management
**Productivity (4)**: Document management and personal organization
**Development (4)**: Programming and database administration tools
**Utilities (6)**: Miscellaneous helpful services

**Total Services: 41**
