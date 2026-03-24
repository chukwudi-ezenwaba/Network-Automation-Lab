#!/usr/bin/env python3
"""Simple Netmiko script to check OSPF neighbors from a list of routers.

Reads `routerlist` in the current directory (one IP/hostname per line).
Prompts securely for username and password using `getpass`.
Runs `show ip ospf neighbor` on each device and prints the output.
"""

from getpass import getpass
from netmiko import ConnectHandler


def read_routerlist(path='routerlist'):
    with open(path) as f:
        return [line.strip() for line in f if line.strip()]


def main():
    routers = read_routerlist()
    username = input('Username: ')
    password = getpass('Password: ')

    for host in routers:
        print('=' * 60)
        print(f'Connecting to {host}...')
        device = {
            'device_type': 'cisco_ios',
            'host': host,
            'username': username,
            'password': password,
        }
        try:
            conn = ConnectHandler(**device)
            out = conn.send_command('show ip ospf neighbor')
            print(out)
        except Exception as e:
            print(f'Error connecting to {host}: {e}')
        finally:
            try:
                conn.disconnect()
            except Exception:
                pass


if __name__ == '__main__':
    main()
