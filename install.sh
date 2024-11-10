#!/bin/bash

metatrader_url="https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"

set -e

if [ $(whoami) == "root" ]; then
	echo "Bitte als user ausführen."
	exit
fi

# Update & Upgrade & Install Utilities
sudo apt -y update && sudo apt -y full-upgrade
sudo apt -y install wget

# Install & Configure Flatpak
sudo apt -y install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Bottles
flatpak -y install app/com.usebottles.bottles/x86_64/stable
sudo flatpak override com.usebottles.bottles --filesystem=~/Downloads:ro
timeout 60 flatpak run com.usebottles.bottles || true

# Add Application
echo "Arch: win64
Installed_Dependencies:
- mono
- gecko
Windows: win10" >~/Downloads/metatrader-environment.yml

flatpak run --command=bottles-cli com.usebottles.bottles new --bottle-name metatrader --environment application --custom-environment ~/Downloads/metatrader-environment.yml
wget -O ~/Downloads/mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe
flatpak run --command=bottles-cli com.usebottles.bottles run --bottle metatrader -e ~/Downloads/mt5setup.exe
