#!/usr/bin/env bash
# Minimal SFTP installer for Debian/Ubuntu
# This script performs only the essential steps to install and configure
# a basic chrooted SFTP setup for a group of users (`sftpusers`).

set -e

# Require root so commands don't need sudo prefixes.
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# Update package index and install OpenSSH server.
apt-get update -y
apt-get install -y openssh-server

# Create a group that will be used for chrooted SFTP users.
getent group sftpusers >/dev/null || groupadd sftpusers

# Example user creation (idempotent): create `sftpuser` if it doesn't exist.
# Replace or remove this block if you prefer to create users manually.
if ! id -u sftpuser >/dev/null 2>&1; then
  useradd -m -g sftpusers -s /usr/sbin/nologin sftpuser
fi

# Create chroot base and per-user directories. Chroot directories must be
# owned by root and not writable by other users. The writable upload directory
# inside is owned by the SFTP user.
CHROOT_BASE="/srv/sftp"
mkdir -p "${CHROOT_BASE}"
chown root:root "${CHROOT_BASE}"
chmod 755 "${CHROOT_BASE}"

# Per-user structure for `sftpuser` (create if missing).
USER_DIR="${CHROOT_BASE}/sftpuser"
UPLOAD_DIR="${USER_DIR}/upload"
mkdir -p "${UPLOAD_DIR}"
# Ensure chroot dir is owned by root as required by OpenSSH.
chown root:root "${USER_DIR}"
chmod 755 "${USER_DIR}"
# Upload directory writable by the SFTP user.
chown sftpuser:sftpusers "${UPLOAD_DIR}"
chmod 755 "${UPLOAD_DIR}"

# Create a drop-in SSH config for SFTP to avoid editing the main file.
# This defines a Match Group for `sftpusers` and forces internal-sftp with
# chroot to /srv/sftp/%u (username directory created above).
SSH_DROPIN="/etc/ssh/sshd_config.d/sftp.conf"
cat > "${SSH_DROPIN}" <<'EOF'
Match Group sftpusers
    ChrootDirectory /srv/sftp/%u
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTCPForwarding no
EOF

# Ensure the drop-in directory is read by sshd (modern OpenSSH does this by default).
# Restart sshd to apply configuration changes.
systemctl enable --now ssh
systemctl restart ssh

echo "SFTP setup complete."
echo "- Chroot base: /srv/sftp"
echo "- Example user: sftpuser (passwordless, shell: nologin). To set a password: sudo passwd sftpuser"
echo "- Upload path for sftpuser: /srv/sftp/sftpuser/upload"

exit 0
