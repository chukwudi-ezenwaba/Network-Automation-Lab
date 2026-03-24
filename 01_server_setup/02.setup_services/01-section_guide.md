# Service Setup Guide

## Overview

This section configures essential infrastructure services on the lab servers. These services are the foundation for automating network device configuration and managing backups of device configuration files.

---

## Lab Context: Network Automation and Configuration Backup

The goal of this lab is to:
1. **Automate the configuration** of network devices (routers, switches)
2. **Backup configuration files** from network devices for disaster recovery

The services configured here enable these goals by providing:
- **Secure remote access** to devices and servers
- **File transfer capabilities** for pushing configs and pulling backups
- **Time synchronization** for accurate logging and troubleshooting
- **Backup storage** with secure file transfer

---

## Services Overview

### 1. SSH (Secure Shell) - Remote Access

SSH (Secure Shell) is a protocol that allows secure, encrypted remote login to the Ubuntu server and enables remote command execution from a management computer. Unlike older protocols such as Telnet, SSH encrypts all communication, protecting sensitive information like passwords and commands from being intercepted over the network.

In the context of this lab, SSH is the foundation for network automation. When you run automation scripts written in Python or tools like Ansible, they rely on SSH to establish secure connections to network devices and execute commands on them. Without SSH, you would have no way to remotely access your servers or devices, and automation would be impossible. Additionally, administrators use SSH to manage and monitor the lab infrastructure from their management computers, allowing them to troubleshoot issues and verify that automation tasks are running correctly.

You will use SSH when connecting to the Ubuntu server to execute scripts, when running automation tools that depend on SSH to reach network devices, and when monitoring device status and reviewing logs remotely. The SSH setup script (`ssh_config.sh`) configures password authentication for easy access in the lab environment, allowing you to quickly test connectivity and run commands without managing key files.

---

### 2. TFTP (Trivial File Transfer Protocol) - Configuration Distribution

TFTP is a lightweight file transfer protocol that has been the industry standard for network device configuration management for decades. Most network devices, including Cisco routers, switches, and many other manufacturers' equipment, are designed to use TFTP for uploading and downloading configuration files. Because of this widespread support, TFTP is the natural choice for communicating configuration data to and from network devices in this lab.

TFTP is essential for achieving the lab's goal of backing up network device configurations. When a router or switch needs to save its current running configuration (which contains all the settings, IP addresses, routing protocols, security policies, and user accounts), it can push that configuration file to a TFTP server using a simple command like `copy running-config tftp://server_ip/backup_name`. This allows you to create automated backup scripts that regularly connect to all network devices and collect their configurations for safekeeping. If a device fails or is misconfigured, you can easily restore the backed-up configuration by copying it back from the TFTP server to the device. Additionally, TFTP enables pushing updated configurations to multiple devices simultaneously, which is critical for large-scale network automation tasks where you need to deploy consistent configurations across many devices.

The typical workflow in your lab will involve network devices sending their running configurations to the TFTP server running on the Ubuntu machine. These backup files can then be processed, archived, or moved to secure storage on the Fedora server for long-term retention. The TFTP setup script will be configured specifically on the Ubuntu server (ubsvr01) as the designated backup collection point.

---

### 3. SFTP (SSH File Transfer Protocol) - Secure Backup Storage

SFTP is a secure file transfer protocol built on top of SSH encryption. Unlike TFTP, which has minimal security features, SFTP encrypts all file transfer communications and requires user authentication before allowing access to files. This means that configuration backups stored on the SFTP server are protected both during transfer and at rest on the storage server.

In the context of this lab, SFTP serves as the secure central repository for all network device configuration backups. Because network device configurations contain sensitive information such as administrator usernames, passwords, routing policies, and security rules, protecting these files from unauthorized access is critical. When configuration files are transferred from the TFTP server on Ubuntu to the SFTP server on Fedora, they are encrypted end-to-end and stored in a location where only authenticated users can access them. SFTP also provides user authentication and access control, allowing you to grant different administrators different levels of permission to view or restore specific configurations. This creates an audit trail that logs who accessed which configuration files and when, which is essential for compliance and security investigations.

You will use SFTP when retrieving backed-up configuration files for analysis, restoration, or archival purposes. The typical two-stage backup workflow involves network devices sending their configurations to TFTP on the Ubuntu server, which then automatically forwards them via SFTP to the Fedora server for secure long-term storage. This architecture ensures that configuration backups are accessible for automation while also being protected from unauthorized access.

---

### 4. NTP (Network Time Protocol) - Time Synchronization

NTP is a protocol that synchronizes the system clock across all servers and network devices so that they all maintain the exact same time. Without NTP, each device would rely on its own internal clock, which might drift and become inaccurate over time. When multiple devices are running out of sync, troubleshooting becomes nearly impossible because log entries from different devices will have conflicting timestamps.

Accurate time synchronization is critical for this lab's success. When you need to troubleshoot a network issue, you will look at logs from the network devices, the Ubuntu server, and the Fedora server. Without synchronized time, these logs become confusing and misleading. For example, if the Ubuntu server shows that a configuration was pushed at 10:05 AM, the router shows that it received the configuration at 9:45 AM, and the Fedora backup server shows that the file was saved at 10:15 AM, you cannot determine the actual sequence of events. This confusion can lead to incorrect conclusions about what went wrong. With NTP ensuring all systems are synchronized, each timestamp tells the true story of when events occurred in the correct order.

Additionally, configuration files are typically timestamped when they are created. If servers are out of sync, a newer backup might have an earlier timestamp than an older backup, causing automated backup systems to accidentally overwrite recent backups with old ones. Security audits also depend on synchronized timestamps to create a reliable record of who made what changes and when. Once NTP is configured on both servers, the synchronization happens automatically in the background, and all logs, backups, and system events will have consistent, accurate timestamps that reflect the true sequence of events.

---

## Scripts in This Section

| Script | Purpose | Status |
|--------|---------|--------|
| `ssh_config.sh` | Install and configure SSH on Ubuntu | ✓ Complete |
| `tftp_config.sh` | Install and configure TFTP on Ubuntu | (To be implemented) |
| `sftp_config.sh` | Install and configure SFTP on Fedora | (To be implemented) |
| `ntp_config.sh` | Install and configure NTP on both servers | (To be implemented) |
| `install_python.sh` | Install Python3, pip and virtualenv; install lab requirements | ✓ Created |
| `make_script_exec.sh` | Make all scripts executable | ✓ Helper utility |
| `ssh_key_auth.md` | Guide: SSH key-based authentication setup between servers and devices | ✓ Created |

---

## Implementation Order

1. **SSH First** - You need this to connect to your servers and run other scripts
2. **NTP Second** - Synchronize time before configuration backups begin
3. **TFTP on Ubuntu** - Enables device configuration backup
4. **SFTP on Fedora** - Provides secure central backup storage

---

## Configuration Architecture for Your Lab

```
┌─────────────────────┐
│  Network Devices    │
│  (Routers, Switches)│
└──────────┬──────────┘
           │ (TFTP: configs)
           ↓
┌──────────────────────────┐
│  Ubuntu Server (ubsvr01) │
│  • SSH enabled           │
│  • TFTP server running   │
│  • NTP client synced     │
└──────────┬───────────────┘
           │ (Backups via SFTP)
           ↓
┌──────────────────────────┐
│  Fedora Server (fedsvr01)│
│  • SSH enabled           │
│  • SFTP server running   │
│  • NTP client synced     │
│  • Secure backups stored │
└──────────────────────────┘
           ↑
           │ (Managed from here)
┌──────────────────────────┐
│  Your Administration PC  │
│  • SSH to servers        │
│  • View/restore backups  │
│  • Run automation scripts│
└──────────────────────────┘
```

---

## Quick Reference Commands

### Test SSH Connection
```bash
ssh username@ubsvr01
```

### View TFTP Backups (from Ubuntu)
```bash
ls /var/lib/tftpboot/
```

### Access SFTP Backups (from your PC)
```bash
sftp username@fedsvr01
```

### Check NTP Status
```bash
timedatectl
systemd-resolve --status
```

---

## Next Steps

1. Run `bash ssh_config.sh` on the Ubuntu server first
2. Continue to individual service setup instructions
3. Verify each service is running before proceeding to network device automation

For detailed configuration procedures, see individual service documentation files.