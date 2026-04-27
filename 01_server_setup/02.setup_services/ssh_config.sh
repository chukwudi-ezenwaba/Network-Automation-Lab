#!/bin/bash

# Simple SSH Setup with Password Authentication

echo "Updating package list..."
sudo apt update

echo "Installing OpenSSH Server..."
sudo apt install -y openssh-server

echo "Enabling and starting SSH service..."
sudo systemctl enable ssh
sudo systemctl start ssh

SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup original config
sudo cp $SSHD_CONFIG ${SSHD_CONFIG}.bak

#change the default SSH port from 22 to 2022, we will use the loopback IP of '127.0.0.1' with port 2222 to SSH into the Ubuntu server
sudo sed -i -E 's,^#?Port.*$,Port 2022,' /etc/ssh/sshd_config 

# Disable password authentication (use keys only)
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' $SSHD_CONFIG
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' $SSHD_CONFIG

echo "Restarting SSH service..."
sudo systemctl restart ssh

echo "SSH setup complete. You can now log in using your username and password."



