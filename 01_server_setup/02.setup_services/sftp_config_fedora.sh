#!/usr/bin/env bash
# Minimal SFTP installer/configurator for Fedora (dnf)
# Installs openssh-server and sets up a basic chrooted SFTP directory for
# an example user `sftpuser`. Adapt or remove user creation as desired.

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Install OpenSSH server
dnf install -y openssh-server

# Create sftp group if it doesn't exist
getent group sftpusers >/dev/null || groupadd sftpusers

# Example user (idempotent): creates `sftpuser` in group `sftpusers`.
if ! id -u sftpuser >/dev/null 2>&1; then
  useradd -m -g sftpusers -s /sbin/nologin sftpuser
fi

# Chroot base and per-user upload directory structure
CHROOT_BASE="/srv/sftp"
mkdir -p "${CHROOT_BASE}"
chown root:root "${CHROOT_BASE}"
chmod 755 "${CHROOT_BASE}"

USER_DIR="${CHROOT_BASE}/sftpuser"
UPLOAD_DIR="${USER_DIR}/upload"
mkdir -p "${UPLOAD_DIR}"
# Chroot directory must be owned by root
chown root:root "${USER_DIR}"
chmod 755 "${USER_DIR}"
# Upload directory writable by the sftp user
chown sftpuser:sftpusers "${UPLOAD_DIR}"
chmod 755 "${UPLOAD_DIR}"

# Add a drop-in sshd config for SFTP (supported on modern Fedora)
SSH_DROPIN="/etc/ssh/sshd_config.d/sftp.conf"
mkdir -p /etc/ssh/sshd_config.d
cat > "${SSH_DROPIN}" <<'EOF'
Match Group sftpusers
    ChrootDirectory /srv/sftp/%u
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTCPForwarding no
EOF

# Start/restart the sshd service to apply changes
systemctl enable --now sshd
systemctl restart sshd

echo "SFTP setup complete on Fedora. Chroot base: /srv/sftp"
echo "Example user: sftpuser (set password with: sudo passwd sftpuser)"

exit 0
