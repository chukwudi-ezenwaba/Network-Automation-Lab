

#!/usr/bin/env python3
"""
This script backs up running-config from network devices to TFTP server
Netmiko-converted version of the original `p_device_backup.py` which used Paramiko.

It preserves the original script's comments and two sequential flows (TFTP then SFTP),
but uses Netmiko's `ConnectHandler` for SSH.
"""

import time
from datetime import datetime
from getpass import getpass
from netmiko import ConnectHandler

t_ref = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")  # Get current timestamp
device_list = [
    "192.168.2.3",
    "192.168.2.4",
    "192.168.2.101",
    "192.168.2.102",
    "192.168.2.133"
]  # List of device IPs
start_timer = time.time()  # Start time for the script

def get_credentials():
    """Prompt user for credentials and confirm password."""
    username = input("*Enter Network Admin ID : ")
    while True:
        password = getpass("*Enter Network Admin PWD : ") # Hide password input
        password_verify = getpass("**Confirm Network Admin PWD : ") # Hide password input
        if password == password_verify: # Check if passwords match
            break
        print("! Network Admin Passwords do not match. Please try again.")
    return username, password


username, password = get_credentials()  # Get user credentials

for ip in device_list:
    print(t_ref)  # Print timestamp
    print(f"Now logging into {ip}")
    device = {
        'device_type': 'cisco_ios',
        'host': ip,
        'ip': ip,
        'username': username,
        'password': password,
        'fast_cli': False,
    }
    try:
        conn = ConnectHandler(**device)
        print(f"Successful connection to {ip}\n")
        print(f"Now making running-config backup of {ip}\n")
        # Using send_command_timing to handle interactive prompts for copy to TFTP
        output = conn.send_command_timing("copy running-config tftp")
        if 'Address or name of remote host' in output or 'Remote host' in output:
            output += conn.send_command_timing("192.168.2.170")  # TFTP server IP
        if 'Destination filename' in output or 'Filename' in output:
            output += conn.send_command_timing(f"{ip}.bak@{t_ref}")  # Backup filename
        time.sleep(3)
        print()
        time.sleep(3)
        print(output)
        print(f"Successfully backed-up running-config to TFTP & Disconnecting from {ip}\n")
        print("-" * 80)
    except Exception as e:
        print(f"Error connecting to {ip}: {e}")
    finally:
        try:
            conn.disconnect()
        except Exception:
            pass
    time.sleep(1)

total_time = time.time() - start_timer  # Calculating total script execution time
print(f"Total time : {total_time:.2f} seconds")

#.........................................................................................................................
# Duplicate of the above flow but for SFTP as in the original 

start_timer = time.time()  # Start time for the second flow

username, password = get_credentials()  # Re-prompt for credentials (as original script did)

for ip in device_list:
    print(t_ref)  # Print timestamp
    print(f"Now logging into {ip}")
    device = {
        'device_type': 'cisco_ios',
        'host': ip,
        'ip': ip,
        'username': username,
        'password': password,
        'fast_cli': False,
    }
    try:
        conn = ConnectHandler(**device)
        print(f"Successful connection to {ip}\n")
        print(f"Now making running-config backup of {ip}\n")
        # SFTP flow - interactively provide host, username/password if prompted
        output = conn.send_command_timing("copy running-config sftp")
        if 'Address or name of remote host' in output or 'Remote host' in output:
            output += conn.send_command_timing("192.168.2.170")  # SFTP server IP
        if 'User' in output or 'username' in output.lower():
            output += conn.send_command_timing("Ginaeze66@")
        if 'Destination filename' in output or 'Filename' in output:
            output += conn.send_command_timing(f"{ip}.bak@{t_ref}")  # Backup filename
        time.sleep(3)
        print()
        time.sleep(3)
        print(output)
        print(f"Successfully backed-up running-config to SFTP & Disconnecting from {ip}\n")
        print("-" * 80)
    except Exception as e:
        print(f"Error connecting to {ip}: {e}")
    finally:
        try:
            conn.disconnect()
        except Exception:
            pass
    time.sleep(1)

total_time = time.time() - start_timer  # Calculating total script execution time
print(f"Total time : {total_time:.2f} seconds")
