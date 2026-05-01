#!/bin/bash
# Ubuntu NTP configuration guide for lab devices
# Ubuntu host: 192.168.2.209
# Timezone: America/Toronto (UTC-4)

# Why NTP is needed:
# NTP keeps all lab devices synchronized so logs, system events, and automation
# jobs use the same timestamps across servers, routers, and switches.

# 1. Set the timezone to Toronto
sudo timedatectl set-timezone America/Toronto
sudo timedatectl status --no-pager

# 2. Install and enable the NTP service (chrony)
sudo apt update
sudo apt install -y chrony
sudo systemctl enable --now chrony
sudo systemctl status chrony

# 3. Configure chrony time sources
# Edit /etc/chrony/chrony.conf and ensure it contains:
#   pool 0.ca.pool.ntp.org iburst
#   pool 1.ca.pool.ntp.org iburst
#   pool 2.ca.pool.ntp.org iburst
#   pool 3.ca.pool.ntp.org iburst
#   allow 192.168.2.0/24

# 4. Restart chrony after updating the config
sudo systemctl restart chrony

# 5. Allow NTP traffic through Ubuntu firewall
sudo ufw allow 123/udp

# 6. Verify synchronization
timedatectl
chronyc tracking
chronyc sources -v
