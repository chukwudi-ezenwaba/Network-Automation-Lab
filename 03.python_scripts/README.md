Python Automation Scripts

This folder contains Python scripts used to automate common network tasks in the lab: connectivity testing, device information extraction, configuration backup and restore, and patch/IOS upgrades.

Overview of scripts and how they map to lab scope:

- `02. network_tests/ping_test.py` — Script that automates ICMP ping tests across the LAN to verify device connectivity (Scope item 5). Run from the lab admin machine or server. Use the Python virtual environment and provide an inventory file of IPs.

- `01. device_info/get_device_info_regex.py` — Uses SSH/Netmiko and regular expressions to extract structured device information (Scope item 6). Useful for inventory discovery and parsing show command output.

- `03. config_backup/backup_running_config.py` — Connects to devices and retrieves running configurations, storing them locally or pushing them to the TFTP/SFTP servers (Scope item 7). Can be scheduled or invoked on-demand.

- `05. config_pull/pull_config_from_server.py` — Pulls backed-up configurations from the servers back to a local machine for inspection or to prepare for restore operations (Scope item 7 and 8).

- `06. ospf_status/show_ospf_neighbor.py` — Parses OSPF neighbor output to help validate OSPF peering and routing status (Scope item 4).

- `04. patch_management/patch_update_manager.py` — Orchestrates remote firmware/IOS upgrades across devices (Scope item 9). Use with care: always test on a single device first.

Requirements and setup

1. Install Python 3 and the project requirements (recommended via the installer):

```bash
sudo bash ../01.server_setup/02.setup_services/install_python.sh
```

2. Activate the virtual environment (created at `/opt/network-lab/venv` by the installer):

```bash
source /opt/network-lab/venv/bin/activate
python -V
pip -V
```

3. Run scripts from their directories. Example:

```bash
cd 02.\ network_tests
python3 ping_test.py
```

Notes

- Each script should be reviewed and adapted to your device IPs, credentials, and environment before running. Credentials should be stored securely (not in plaintext scripts) — consider using environment variables or a secrets manager.
- The `requirements.txt` in this directory lists the Python packages used by the scripts. The installer script will attempt to install these packages into the venv.

If you want, I can add example inventory files and adjust the scripts to accept CLI arguments and config files for easier reuse.
