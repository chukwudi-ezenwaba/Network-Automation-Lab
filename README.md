# Network Automation Lab

This repository contains a hands-on lab for automating network device configuration and managing configuration backups using Linux servers and Python automation scripts. The lab uses two server VMs (Ubuntu and Fedora) and multiple network devices (routers and switches) running in a virtual topology on EVE-NG.

## Lab Scope

The lab covers the following objectives:

1. Configure IP addresses on all network device interfaces.
2. Configure VLANs for network segmentation.
3. Configure remote access on routers and switches (SSH).
4. Configure dynamic OSPF routing so devices can route traffic between networks.
5. Provide a Python script to automate ping tests to all devices in the LAN.
6. Provide a Python script that extracts custom device information using regular expressions.
7. Provide a Python script to backup device configurations to the Ubuntu (TFTP) and Fedora (SFTP) servers.
8. Provide a Python script to recover backed-up configurations from the servers back to devices.
9. Provide a Python script to upgrade device IOS images where applicable.

## Project Structure

- `01.server_setup/` — Server preparation and configuration documentation and scripts.
	- `01.server_config/` — Basic server admin docs and quick-start (hostnames, verification).
	- `02.setup_services/` — Service setup scripts (SSH, TFTP, SFTP, NTP, Python installer).
- `02.eveng_topology/` — Device interface templates, routing config examples, and topology resources.
- `03.python_scripts/` — Automation scripts (ping tests, device info extraction, backup/restore, patching).
- `04.docs/` — Lab overview, setup guide, and troubleshooting documentation.

## Quick Start

1. Prepare the two lab servers (Ubuntu and Fedora) in your virtualization platform (Proxmox or similar).
2. Follow `01.server_setup/01.server_config/Section_guide.md` and `Basic_server_administration.md` to update packages and set hostnames (`ubsvr01`, `fedsvr01`).
3. From the Ubuntu server, run the SSH setup script:

```bash
bash 01.server_setup/02.setup_services/ssh_config.sh
```

4. Install Python and required packages on servers (run on Ubuntu and Fedora):

```bash
sudo bash 01.server_setup/02.setup_services/install_python.sh
```

5. Continue configuring services in `01.server_setup/02.setup_services/` (TFTP, SFTP, NTP) and verify with the provided system info scripts.

## Where to look next

- Server administration and verification: `01.server_setup/01.server_config/`
- Service setup: `01.server_setup/02.setup_services/`
- Automation scripts: `03.python_scripts/`
- Lab docs and troubleshooting: `04.docs/`

