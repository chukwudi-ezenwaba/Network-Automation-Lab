# Server Setup

This folder contains documentation and scripts required to prepare the Ubuntu and Fedora servers used in the lab. The server setup is the first step before running automation tasks against the network devices.

Key items:

- `01.server_config/` — Basic server administration, hostnames, system verification, and system information scripts.
- `02.setup_services/` — Service installation and configuration scripts (SSH, TFTP, SFTP, NTP, Python installer).
- `03.ip_address_management/` — Notes and examples for configuring network interfaces on servers and devices.

Follow the `01.server_config/Section_guide.md` first, then run the service scripts in `02.setup_services/` in the order recommended there.

Once servers are configured and verified, proceed to `03.python_scripts/` to run automation scripts that will connect to and manage network devices.
