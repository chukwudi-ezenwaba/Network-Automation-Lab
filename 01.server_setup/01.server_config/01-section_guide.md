# Server Configuration Guide

## What is This Section?

This section prepares your Ubuntu and Fedora lab servers for use. It covers initial setup tasks that must be completed before moving to network services and device configuration.

## What You'll Do

- Update system packages to the latest versions
- Set server hostnames (`ubsvr01` and `fedsvr01`)
- Verify network interfaces are working
- Check DNS and time configuration

## Lab Servers

| Server | OS | Hostname |
|--------|----|----|
| VM 1   | Ubuntu LTS | ubsvr01 |
| VM 2   | Fedora | fedsvr01 |

---

## How to Use This Section

### 1. Start Here: Overview (this file)
   - Understand what needs to be done

### 2. Follow the Steps: [Basic Server Administration](Basic_server_administration.md)
   - This document has all the commands and procedures
   - Follow the 4 phases in order
   - Both Ubuntu and Fedora commands are shown side-by-side

### 3. Verify Your Work: System Information Scripts
   - Run the provided bash scripts to confirm everything is configured correctly
   - Scripts in current directory: `ubuntu_system_info.sh` and `fedora_system_info.sh`

---

## Success Checklist

- ✓ System packages are updated
- ✓ Hostname is set and persistent (ubsvr01 or fedsvr01)
- ✓ `/etc/hosts` file contains correct hostname entry
- ✓ Network interfaces are visible with `ip a`
- ✓ DNS resolution is working
- ✓ System information scripts run without errors

---

## What's Next?

After completing this section:

1. **Service Setup** (`../02.setup_services/`) - Configure SSH, NTP, TFTP, SFTP
2. **IP Management** (`../03.ip_address_management/`) - Configure additional IP addresses
3. **Network Topology** (`../../02.eveng_topology/`) - Deploy device configurations

---

## Troubleshooting

For issues or questions:
- Check the "Common Issues and Solutions" table in [Basic Server Administration](Basic_server_administration.md)
- Run the system information scripts to see your current configuration
- Verify you have sudo privileges on both servers
