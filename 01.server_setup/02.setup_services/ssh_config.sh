#!/bin/bash

# Simple SSH Setup with Password Authentication

echo "Updating package list..."
sudo apt update

echo "Installing OpenSSH Server..."
sudo apt install -y openssh-server

echo "Enabling and starting SSH service..."
sudo systemctl enable ssh
sudo systemctl start ssh

echo "Configuring SSH for password authentication..."
SSHD_CONFIG="/etc/ssh/sshd_config"

# Backup original config
sudo cp $SSHD_CONFIG ${SSHD_CONFIG}.bak

# Ensure password authentication is enabled
sudo sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' $SSHD_CONFIG
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' $SSHD_CONFIG

echo "Restarting SSH service..."
sudo systemctl restart ssh

echo "SSH setup complete. You can now log in using your username and password."



