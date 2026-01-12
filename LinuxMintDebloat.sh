#!/bin/bash

# Linux Mint "Hardened" Debloat Script
# OPTIMIZED FOR: Linux Mint 21.x / 22.x (Cinnamon)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}======================================${NC}"
echo -e "${YELLOW}  LINUX MINT HARDENING & DEBLOAT      ${NC}"
echo -e "${YELLOW}======================================${NC}"
echo "warn: This will remove 'mint-meta-cinnamon'. This is normal but means"
echo "      future default apps won't install automatically."
echo ""
sleep 3

# Helper function that doesn't crash script on failure
remove_pkg() {
    echo -e "${YELLOW}Targeting: $1${NC}"
    sudo apt-get remove --purge -y "$1" 2>/dev/null || echo " - Package $1 not found (skipping)."
}

# ==========================================
# 1. NETWORK & ATTACK SURFACE (Priority)
# ==========================================
echo -e "\n${GREEN}=== 1. Removing Network-Facing Apps ===${NC}"
# Warpinator: Opens LAN ports for file sharing (Critical for attack surface)
# Hexchat: IRC Client (Old default)
# Thunderbird: Email Client
# Transmission: BitTorrent
# Webapp-manager: Mint tool to bridge web to desktop
remove_pkg "warpinator"
remove_pkg "hexchat"
remove_pkg "thunderbird"
remove_pkg "transmission-gtk"
remove_pkg "transmission-common"
remove_pkg "webapp-manager"
remove_pkg "onioncircuits"  # Sometimes present in Mint for Tor

# ==========================================
# 2. BLUETOOTH (Deep Clean)
# ==========================================
echo -e "\n${GREEN}=== 2. Nuke Bluetooth Stack ===${NC}"
# Mint uses 'blueberry' as the GUI wrapper.
remove_pkg "blueberry"
remove_pkg "bluez"
remove_pkg "bluez-cups"
remove_pkg "bluez-obexd"
remove_pkg "pulseaudio-module-bluetooth"


# OPTIONAL: Block kernel modules for Bluetooth to prevent resurrection
echo "blacklist btusb" | sudo tee /etc/modprobe.d/no-bluetooth.conf
echo "blacklist bluetooth" | sudo tee -a /etc/modprobe.d/no-bluetooth.conf


# ==========================================
# 3. OFFICE SUITE (Disk Space)
# ==========================================
echo -e "\n${GREEN}=== 3. Removing LibreOffice ===${NC}"
# Using wildcard to catch core, writer, calc, impress, etc.
sudo apt-get remove --purge -y libreoffice* liblibreoffice*

# ==========================================
# 4. MEDIA & EXTRAS
# ==========================================
echo -e "\n${GREEN}=== 4. Removing Media & Mint Extras ===${NC}"
remove_pkg "hypnotix"       # IPTV Player
remove_pkg "rhythmbox"      # Music Player
remove_pkg "rhythmbox-data"
remove_pkg "pix"
remove_pkg "pix-data" 
remove_pkg "drawing"        # Paint replacement
remove_pkg "sticky"         # Sticky Notes
remove_pkg "thingy"         # Document Library

# ==========================================
# 5. HARDWARE & SERVICES (Hardening)
# ==========================================
echo -e "\n${GREEN}=== 5. Disabling Hardware Services ===${NC}"

# Printer Support (CUPS listens on port 631)
remove_pkg "cups"
remove_pkg "cups-daemon"
remove_pkg "cups-browsed"
remove_pkg "system-config-printer"

# Modem Manager (Often runs as root, unneeded for most)
remove_pkg "modemmanager"

# Avahi (mDNS/Bonjour - announces your PC to the network)
remove_pkg "avahi-daemon"
remove_pkg "avahi-autoipd"

# Scanner Support (SANE)
remove_pkg "sane-utils"
remove_pkg "simple-scan"

# Samba/SMB (file sharing protocol - often exploited)
remove_pkg "samba-common"
remove_pkg "samba-libs"

# ==========================================
# 6. WIFI HARDENING (Kernel Level)
# ==========================================
echo -e "\n${GREEN}=== 6. WiFi Hardening ===${NC}"
# We do not use power save config as that doesn't disable radio.
# We block the radio via nmcli (persistent).
sudo nmcli radio wifi off
echo "WiFi radio turned off via NetworkManager."

# ==========================================
# 7. CLEANUP
# ==========================================
echo -e "\n${GREEN}=== Final Cleanup ===${NC}"
sudo apt-get autoremove -y
sudo apt-get autoclean

echo -e "\n${GREEN}Done! Reboot your system.${NC}"
