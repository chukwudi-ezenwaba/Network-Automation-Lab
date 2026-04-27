#!/usr/bin/env bash
# Minimal TFTP installer for Debian/Ubuntu
# This script performs only the essential steps to install and start tftpd-hpa.

set -e

# Require root so commands don't need sudo prefixes.
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root: sudo $0"
	exit 1
fi

# Update package index and install the TFTP server package.
# The `tftp` client package is obsolete in this environment; install only the
# maintained server package `tftpd-hpa`.
apt-get update -y
apt-get install -y tftpd-hpa

# Create the TFTP root directory and set ownership/permissions.
# tftpd-hpa uses the `tftp` user by default; ensure the directory exists.
mkdir -p /var/lib/tftpboot
chown -R tftp:tftp /var/lib/tftpboot
chmod 755 /var/lib/tftpboot

# Configure tftpd-hpa defaults. This file defines how the daemon runs.
cat > /etc/default/tftpd-hpa <<'EOF'
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/var/lib/tftpboot"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure -c"
EOF

# Enable the service to start at boot and start it now.
systemctl enable --now tftpd-hpa

echo "TFTP installed and started. Root: /var/lib/tftpboot"
exit 0

