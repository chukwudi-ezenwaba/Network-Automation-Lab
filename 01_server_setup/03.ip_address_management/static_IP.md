## Server 1 Fedora
1. Check your device network interfaces 
    ```bash
    nmcli device

2. If you encounter an error when you run the command above, install network-manager.
    ```bash
    apt/dnf install network-manager

3. Set static IP as follows
    ```bash
    nmcli connection modify ens18 \
    ipv4.addresses 192.168.2.210/24 \
    ipv4.gateway 192.168.2.1 \
    ipv4.dns "8.8.8.8 1.1.1.1" \
    ipv4.method manual

4. Reset interfaces.
    ```bash
    sudo nmcli connection down ens18; nmcli connection up ens18

5. Check the new configuration
    ```bash
    nmcli device show ens18
    ip address show

## Server 2 Ubuntu
1. Check your device network interfaces 
    ```bash
    nmcli device

2. Set static IP as follows
    ```bash
    network:
    version: 2
    renderer: NetworkManager
    ethernets:
        ens18:
        dhcp4: no
        addresses: [192.168.2.210/24]
        gateway4: 192.168.2.1
        nameservers:
            addresses: [8.8.8.8, 1.1.1.1]

3. Reset interfaces.
    ```bash
    sudo nmcli connection down ens18; nmcli connection up ens18

4. Verify the new configuration
    ```bash
    nmcli device show ens18
    ip address show
