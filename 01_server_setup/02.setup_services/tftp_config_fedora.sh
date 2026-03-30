#!/usr/bin/env bash
# Minimal TFTP installer for Fedora (dnf)
# Installs the tftp-server package, prepares the tftp root, enables socket,
# and opens the firewall for the TFTP service if firewalld is present.

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Install server package
dnf install -y tftp-server

TFTP_DIR="/var/lib/tftpboot"
mkdir -p "$TFTP_DIR"

# Ensure a system `tftp` user exists (creates a system account without a
# login shell). This user will own the TFTP directory.
if ! id -u tftp >/dev/null 2>&1; then
  useradd -r -s /sbin/nologin -d "$TFTP_DIR" -M tftp || true
fi
chown -R tftp:tftp "$TFTP_DIR"
chmod 755 "$TFTP_DIR"

# Enable and start the socket-based service
systemctl daemon-reload || true
systemctl enable --now tftp.socket || true

# Allow through firewalld if available
if command -v firewall-cmd >/dev/null 2>&1; then
  firewall-cmd --permanent --add-service=tftp || true
  firewall-cmd --reload || true
fi

echo "TFTP installed and enabled on Fedora. Root: ${TFTP_DIR}"
exit 0
