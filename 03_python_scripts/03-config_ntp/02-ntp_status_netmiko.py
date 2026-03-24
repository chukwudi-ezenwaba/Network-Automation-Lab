#!/usr/bin/env python3
"""
Script to check NTP status.
"""

import time
from netmiko import ConnectHandler

# Time reference in desired time format
t_ref = time.strftime("%Y-%m-%d_%H-%M-%S") # Current timestamp

# Open router list file
def read_files(routerlist='routerlist', adminfile='adminpass'):
    with open(routerlist) as f:
        routers = [line.strip() for line in f if line.strip()]
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

            # Send show commands
            out1 = conn.send_command('show ntp associations')
            out2 = conn.send_command('show ntp status')

            print(out1)
            print(out2)

            print("Successfully configured your device & disconnecting from " + ip)

        except Exception as e:
            print(f"Error connecting to {ip}: {e}")
        finally:
            try:
                conn.disconnect()
            except Exception:
                pass
        time.sleep(2)


if __name__ == '__main__':
    main()
