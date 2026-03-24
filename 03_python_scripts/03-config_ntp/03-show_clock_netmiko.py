#!/usr/bin/env python3
"""
This script uses the Netmiko library to connect to multiple network devices (via SSH),
log in with a username and password, and run the "show clock" command on each device.

Steps it performs:
1. Defines a list of device IP addresses along with login credentials.
2. Creates an SSH client that automatically trusts unknown host keys.
3. Loops through each device IP and establishes an SSH connection.
4. Opens an interactive shell session and sends the "show clock" command.
5. Waits briefly for the device to respond, then reads and prints the output.
6. Separates the results with a line of dashes for readability.
7. Closes the SSH connection after completing all device checks.

"""
import time
from netmiko import ConnectHandler

USERNAME = 'jdoe'
PASSWORD = 'cisco'
DEVICES = ['192.168.2.3', '192.168.2.4', '192.168.2.101', '192.168.2.102']


def main():
    ssh_client = None
    for ip in DEVICES:
        device = {
            'device_type': 'cisco_ios',
            'host': ip,
            'ip': ip,
            'username': USERNAME,
            'password': PASSWORD,
        }
        try:
            conn = ConnectHandler(**device)
            print(f"Connected to {ip}")
            out = conn.send_command('show clock')
            print(out)
            print('-'*79)
        except Exception as e:
            print(f"Failed to connect to {ip}: {e}")
        finally:
            try:
                conn.disconnect()
            except Exception:
                pass
        time.sleep(1)

    # Alternative implementation using JSON

    import json
    # JSON-formatted data for credentials and devices
    data = {
        "username": "jdoe",
        "password": "cisco",
        "devices": [
            "192.168.2.3",
            "192.168.2.4",
            "192.168.2.101",
            "192.168.2.102"
        ]
    }
    print("JSON-formatted data:") 
    print(json.dumps(data, indent=4))
    for ip in data["devices"]: 
        try:
            conn = ConnectHandler(
                device_type='cisco_ios',
                host=ip,
                username=data["username"],
                password=data["password"],
            )
            print(f"Connected to {ip}")
            out = conn.send_command('show clock')
            print(out)
            print('-'*79)
        except Exception as e:
            print(f"Failed to connect to {ip}: {e}")
        finally:
            try:
                conn.disconnect()
            except Exception:
                pass


if __name__ == '__main__':
    main()
