#!/usr/bin/env bash

# Minimal Python installer: detects apt or dnf and installs python3 + pip
if command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y python3 python3-venv python3-pip; else sudo dnf install -y python3 python3-venv python3-pip; fi
