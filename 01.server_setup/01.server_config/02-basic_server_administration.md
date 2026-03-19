# Basic Linux Server Administration

## Overview

This guide covers essential system administration tasks for configuring Ubuntu LTS and Fedora servers in this lab. All procedures apply to both distributions unless specifically noted.

**Lab Servers:**
- Ubuntu Server: **ubsvr01**
- Fedora Server: **fedsvr01**

---

## Phase 1: Initial System Updates and Verification

### Step 1: Update System Packages

**Ubuntu:**
```bash
sudo apt update && sudo apt upgrade -y
```

**Fedora:**
```bash
sudo dnf update -y
```

### Step 2: Verify Operating System Version

**Ubuntu:**
```bash
cat /etc/os-release
```

**Fedora:**
```bash
cat /etc/fedora-release
```

### Step 3: Install Text Editor (Optional but Recommended)

**Ubuntu:**
```bash
sudo apt install nano -y
```

**Fedora:**
```bash
sudo dnf install nano -y
```

---

## Phase 2: Hostname Configuration

### For Ubuntu Server (ubsvr01)

1. Set the hostname:
   ```bash
   sudo hostnamectl set-hostname ubsvr01
   ```

2. Update the hosts file:
   ```bash
   sudo nano /etc/hosts
   ```
   Add or modify this line:
   ```
   127.0.1.1    ubsvr01
   ```

3. Apply changes immediately:
   ```bash
   exec bash
   ```

4. Verify:
   ```bash
   hostname
   ```

### For Fedora Server (fedsvr01)

1. Set the hostname:
   ```bash
   sudo hostnamectl set-hostname fedsvr01
   ```

2. Update the hosts file:
   ```bash
   sudo nano /etc/hosts
   ```
   Add or modify this line:
   ```
   127.0.1.1    fedsvr01
   ```

3. Apply changes immediately:
   ```bash
   exec bash
   ```

4. Verify:
   ```bash
   hostname
   ```

---

## Phase 3: System Information Verification

Use the provided system information scripts to gather all system details at once:

**For Ubuntu:**
```bash
bash ./ubuntu_system_info.sh
```

**For Fedora:**
```bash
bash ./fedora_system_info.sh
```

These scripts display:
- Operating system details
- Hostname and hostname configuration
- Network interfaces and IP addresses
- DNS resolver configuration
- System time and timezone
- CPU information
- Memory usage
- Disk usage
- Kernel version

---

## Phase 4: Manual System Checks (Individual Commands)

If needed, you can run individual commands to verify specific system information:

### Check Current Hostname
```bash
hostname
```

### View Network Interfaces
```bash
ip a
```

### Check DNS Configuration
```bash
systemd-resolve --status
```

### View Hosts File
```bash
cat /etc/hosts
```

### Check System Time and Timezone
```bash
timedatectl
```

---

## Common Issues and Solutions

| Issue | Solution |
|-------|----------|
| Hostname not persisting after reboot | Verify `/etc/hosts` contains hostname entry, then run `exec bash` |
| DNS resolution not working | Check `/etc/hosts` entries, verify `systemd-resolve --status` output |
| Cannot edit files with nano | Install nano first: `sudo apt install nano -y` (Ubuntu) or `sudo dnf install nano -y` (Fedora) |
| Network interface not visible | Run `ip link show` to list all interfaces |

---

## Next Steps

Once server configuration is complete:

1. **Service Setup** - Configure SSH, NTP, TFTP, and SFTP services
2. **IP Management** - Configure additional network interfaces
3. **Network Topology** - Deploy device configurations and routing

For navigation and overview, see the [01-section_guide.md](01-section_guide.md)
