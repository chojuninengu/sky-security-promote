#!/bin/bash

# Update package lists and install nmap + hydra
echo "Updating package lists..."
sudo apt update

echo "Installing nmap and hydra..."
sudo apt install -y nmap hydra

echo "Installation complete!"
echo "Nmap version: $(nmap --version | head -n 1)"
echo "Hydra version: $(hydra -h | head -n 1)"