#!/usr/bin/env bash

# Installer for Python runtime and common packages used by the lab
# Usage: sudo bash install_python.sh

set -euo pipefail

echo "Detecting platform and installing Python 3 + pip..."

if command -v apt >/dev/null 2>&1; then
    PM=apt
    sudo apt update
    sudo apt install -y python3 python3-venv python3-pip
elif command -v dnf >/dev/null 2>&1; then
    PM=dnf
    sudo dnf install -y python3 python3-venv python3-pip
else
    echo "Unsupported package manager. Install Python3 and pip manually." >&2
    exit 1
fi

echo "Creating a virtual environment at /opt/network-lab/venv (requires sudo)"
sudo mkdir -p /opt/network-lab
sudo chown "$USER":"$USER" /opt/network-lab
python3 -m venv /opt/network-lab/venv
source /opt/network-lab/venv/bin/activate

echo "Upgrading pip and installing requirements if available..."
python3 -m pip install --upgrade pip setuptools
REQ_FILE="$(dirname "$0")/../../03.python_scripts/requirements.txt"
if [ -f "$REQ_FILE" ]; then
    python3 -m pip install -r "$REQ_FILE"
    echo "Installed Python packages from requirements.txt"
else
    echo "No requirements.txt found at $REQ_FILE — install packages manually as needed."
fi

echo "Python installation and virtual environment setup complete."
echo "Activate with: source /opt/network-lab/venv/bin/activate"
