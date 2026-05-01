# SSH Key-Based Authentication Setup

This guide shows a concise, practical setup to enable SSH key-based authentication between
the lab servers (Ubuntu LTS and Fedora) and Cisco routers/switches (IOS / IOS‑XE).
Goal: enable secure, non‑password automation access where the device supports public‑key login.

Prerequisites
- Administrative access to the Ubuntu and Fedora servers
- `ssh` and `ssh-keygen` installed (default on both Ubuntu and Fedora)
- A user account on servers for device uploads (e.g., `backup`) or use `admin` for testing
-- Network devices: Cisco IOS / IOS‑XE routers and switches (this guide is Cisco‑specific)

Overview 
1. Generate an SSH key pair on the management host or on each server that will connect to devices.
2. Install the public key on the target server or device (append to `~/.ssh/authorized_keys`).
3. Verify key-based login and adjust permissions.

Steps — Server side (Ubuntu LTS / Fedora)

1. Create a dedicated user for device uploads:

```bash
sudo useradd -m -s /bin/bash dev_admin
sudo passwd dev_admin   # set a secure password once 
```

2. On the machine that will initiate connections (Linux server), generate an SSH key pair.

For broad Cisco compatibility prefer an RSA key (2048 or 4096 bits). Use an empty passphrase for non‑interactive automation, or protect the key with a passphrase and use `ssh-agent`.

```bash
# Recommended (RSA 4096): compatible with most IOS / IOS‑XE releases
ssh-keygen -t rsa -b 4096 -C "lab-backup-key" -f ~/.ssh/lab_backup_rsa # Generates key pair: lab_backup_rsa (private), comment -C "lab-backup-key" and lab_backup_rsa.pub (public)

# If you need a shorter key and your devices support it, you can use ed25519:
# ssh-keygen -t ed25519 -C "lab-backup-key" -f ~/.ssh/lab_backup_ed25519
```

3. Secure the private key and optionally load it into `ssh-agent` for convenience:

```bash
chmod 600 ~/.ssh/lab_backup_rsa # Secure the private key using strict permissions
eval "$(ssh-agent -s)" # Start the ssh-agent in the background
ssh-add ~/.ssh/lab_backup_rsa # Add the private key to the ssh-agent for passwordless authentication
```

4. Copy the public key to the Ubuntu/Fedora server account that will receive connections (example uses `backup`):

```bash
ssh-copy-id -i ~/.ssh/lab_backup_rsa.pub dev_admin@192.168.2.201
# If ssh-copy-id is unavailable, on the target server:
# mkdir -p ~backup/.ssh && cat lab_backup_rsa.pub >> ~backup/.ssh/authorized_keys
# chmod 700 ~backup/.ssh; chmod 600 ~backup/.ssh/authorized_keys
```

5. Test passwordless login from the origin machine:

```bash
ssh -i ~/.ssh/lab_backup_rsa dev_admin@192.168.2.201
```

Server configuration notes
- Ensure `sshd_config` on Ubuntu/Fedora allows `PubkeyAuthentication yes` and that `AuthorizedKeysFile` points to the default (`.ssh/authorized_keys`).
- Restart SSH daemon if you change settings: `sudo systemctl restart sshd`.

Device-side (Cisco IOS / IOS‑XE)

Cisco IOS and IOS‑XE support importing OpenSSH‑style public keys into a device key chain. For maximum compatibility with IOS devices prefer an RSA public key (`ssh-rsa AAAA...`).

1. Copy the public key text (contents of `cat ~/.ssh/lab_backup_rsa.pub`). It will look like:

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... user@host
```

2. On the Cisco device enter configuration mode and add the key to a local username via `ip ssh pubkey-chain`:

```
configure terminal
ip ssh pubkey-chain
 username backup
  key-string
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... user@host
  exit
exit
username backup privilege 15 secret 0 <fallback-password-if-needed>
end
write memory
```

Notes:
- Replace `dev_admin` with the service account you created on servers. If the username does not exist on the device create it with `username <name> privilege <level> secret <pwd>`.
- If your public key starts with `ssh-ed25519` and the device supports it, you may paste it the same way — however many IOS releases have better support for `ssh-rsa` keys.

3. Verify the key is present in the running config and test login from the origin host:

```
show running-config | section ip ssh pubkey-chain
ssh -i ~/.ssh/lab_backup_rsa backup@<device-ip>
```

Removing a key (example):

```
configure terminal
no ip ssh pubkey-chain
end
write memory
```

If you need to remove just a single username under the key chain, edit the section in the running-config accordingly.

Security and compatibility notes
- Many production IOS devices still prefer RSA keys; use `ssh-keygen -t rsa -b 2048|4096` for best compatibility.
- Do not paste the private key to devices — only the public key (.pub) is required.
- If the device requests host-key verification the first time you connect, accept it and continue.

Security best practices
- Use dedicated service accounts (e.g., `backup`) rather than reusable human admin accounts.
- Prefer ed25519 keys for speed and security unless device support is limited.
- Protect private keys with strict file permissions and ssh-agent; do not commit keys to version control.
- Rotate keys periodically and remove old keys from devices/servers when no longer needed.

Troubleshooting
- If login still prompts for a password, check `~/.ssh/authorized_keys` ownership and permissions on the target: `chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys`.
- Verify `sshd` allows pubkey authentication: `PubkeyAuthentication yes` in `/etc/ssh/sshd_config`.
- For devices, ensure the public key was pasted correctly (no line breaks added) and that the device OS supports the chosen key type.

References
- Vendor documentation contains device-specific steps for importing public keys — use those for Fortinet/Palo Alto/ASA when available.

---
