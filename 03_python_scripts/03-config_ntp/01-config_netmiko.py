#!/usr/bin/env python3
"""
This script automates SSH connections to multiple network devices using the Netmiko library. 
It reads device IP addresses from a file named 'routerlist' and retrieves login credentials 
username and password from a file named 'adminpass'. For each device, it establishes an SSH 
session, enters configuration mode, and sets an NTP server (#NTP server IP). It then saves the 
configuration, captures and displays the output from the device, and finally closes the connection. 
This helps network administrators quickly push basic configurations across multiple devices 
without logging in manually.
"""

import time
from netmiko import ConnectHandler

# Time reference in desired time format
t_ref = time.strftime("%Y-%m-%d_%H-%M-%S") # Current timestamp

# Open router list file and read credentials file
def read_files(routerlist='routerlist', adminfile='adminpass'):
    with open(routerlist) as f:
        routers = [line.strip() for line in f if line.strip()]
    # Read admin file lines
    with open(adminfile) as f:
        lines = [l.strip() for l in f]
    username = lines[0] if lines else input('*Enter Network Admin ID : ')
    password = lines[1] if len(lines) > 1 else input('*Enter Network Admin PWD : ')
    return routers, username, password


def main():
    routers, username, password = read_files()
    for ip in routers:
        print(t_ref)
        print("Now logging into " + ip)

        # Create Netmiko connection information
        device = {
            'device_type': 'cisco_ios',
            'host': ip,
            'ip': ip,
            'username': username,
            'password': password,
        }

        try:
            conn = ConnectHandler(**device)
            print("Successful connection to " + ip + "\n")
            print("Now completing following tasks:\n")

            # Send configuration commands using Netmiko
            cfg_commands = [
                'ntp server 192.168.127.10'
            ]
            out_cfg = conn.send_config_set(cfg_commands)
            print(out_cfg)

            # Save config
            save_out = conn.save_config()
            print(save_out)

            print("Successfully configured your device & disconnecting from " + ip)

        except Exception as e:
            print(f"Error connecting to {ip}: {e}")
        finally:
            try:
                conn.disconnect()
            except Exception:
                pass
        time.sleep(2)

# Note: the original Paramiko script appended extra `remote_connection.send("show ntp associations\n")`
# and `remote_connection.send("show ntp status\n")` after closing files. Those were likely
# intended to be run on a live connection; keep them as comments here to preserve original content.
# remote_connection.send("show ntp associations\n")
# remote_connection.send("show ntp status\n")


if __name__ == '__main__':
    main()
