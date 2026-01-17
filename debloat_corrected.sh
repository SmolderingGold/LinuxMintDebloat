#!/bin/bash

# Linux Mint "Clean & Optimized" Debloat Script v3.0
# AUDIENCE: Power Users, Gamers, & Privacy-Conscious Families
# GOAL: Maximize resources, minimize attack surface, maintain stability.

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}==============================================${NC}"
echo -e "${YELLOW}   LINUX MINT: CLEAN, SECURE & OPTIMIZED      ${NC}"
echo -e "${YELLOW}==============================================${NC}"
echo "warn: This script removes Firefox, Office, Printers, and Bluetooth."
echo "      It is designed to leave a lightweight, 'browse-only' OS base."
echo "      PLEASE ENSURE YOU HAVE INTERNET TO INSTALL A NEW BROWSER."
echo ""
sleep 3

# Function to remove packages safely
remove_pkg() {
    sudo apt-get remove --purge -y "$1" 2>/dev/null || echo " - $1 not found."
}

# ==========================================
# 1. BROWSER REMOVAL
# ==========================================
echo -e "\n${GREEN}=== 1. Removing Stock Browser ===${NC}"
# Removes Firefox so you can install your preferred browser clean.
remove_pkg "firefox"
sudo apt-get remove --purge -y firefox-locale-* 2>/dev/null || true

# ==========================================
# 2. OFFICE & MEDIA BLOAT
# ==========================================
echo -e "\n${GREEN}=== 2. Removing Office & Unused Media ===${NC}"
# Replaces LibreOffice with "Nothing" (Use Google Docs/O365 in browser)
sudo apt-get remove --purge -y libreoffice* liblibreoffice*

# Remove Media Managers (We keep simple Viewers: Celluloid & Xviewer)
remove_pkg "hypnotix"       # IPTV
remove_pkg "rhythmbox"      # Music Database
remove_pkg "rhythmbox-data"
remove_pkg "rhythmbox-plugin-tray-icon"
remove_pkg "pix"            # Heavy Photo Manager
remove_pkg "pix-data"
remove_pkg "drawing"        # Paint App
remove_pkg "sticky"         # Sticky Notes
remove_pkg "thingy"         # Document Library

# ==========================================
# 3. MINT & NETWORK EXTRAS
# ==========================================
echo -e "\n${GREEN}=== 3. Removing Mint Network Extras ===${NC}"
remove_pkg "warpinator"     # Local File Sharing (Open Port 42000)
remove_pkg "hexchat"        # IRC Client
remove_pkg "thunderbird"    # Email Client
remove_pkg "transmission-gtk" # Torrent Client
remove_pkg "transmission-common"
remove_pkg "webapp-manager" # Web-to-App wrapper
remove_pkg "mintwelcome"    # Welcome Screen
remove_pkg "mintreport"     # System Reports

# ==========================================
# 4. BLUETOOTH (The Nuclear Option)
# ==========================================
echo -e "\n${GREEN}=== 4. Removing & Blacklisting Bluetooth ===${NC}"
# Remove the software stack
remove_pkg "blueberry"
remove_pkg "bluez"
remove_pkg "bluez-cups"
remove_pkg "pulseaudio-module-bluetooth"

# Blacklist the kernel modules so the hardware never initializes
# (Prevents the radio from turning on during boot)
echo "Blacklisting Bluetooth kernel modules..."
echo "blacklist btusb" | sudo tee /etc/modprobe.d/no-bluetooth.conf > /dev/null
echo "blacklist bluetooth" | sudo tee -a /etc/modprobe.d/no-bluetooth.conf > /dev/null
echo "blacklist btrtl" | sudo tee -a /etc/modprobe.d/no-bluetooth.conf > /dev/null
echo "blacklist btbcm" | sudo tee -a /etc/modprobe.d/no-bluetooth.conf > /dev/null
echo "blacklist btintel" | sudo tee -a /etc/modprobe.d/no-bluetooth.conf > /dev/null

# ==========================================
# 5. PRINTERS & SCANNERS
# ==========================================
echo -e "\n${GREEN}=== 5. Removing Printing/Scanning Stack ===${NC}"
# Closes Port 631 and frees ram. 
remove_pkg "cups"
remove_pkg "cups-daemon"
remove_pkg "cups-browsed"
remove_pkg "system-config-printer"
remove_pkg "hplip"
remove_pkg "sane-utils"
remove_pkg "simple-scan"

# ==========================================
# 6. SAMBA & JAVA (Attack Surface)
# ==========================================
echo -e "\n${GREEN}=== 6. Removing Java & Windows Sharing ===${NC}"
# Remove Samba Server components (Client/Nemo remains safe via gvfs)
remove_pkg "samba"
remove_pkg "samba-common"
remove_pkg "samba-libs"

# Remove System Java (Games bundle their own, you don't need this)
sudo apt-get remove --purge -y default-jre* openjdk-* 2>/dev/null || true

# ==========================================
# 7. CLEANUP & WIFI
# ==========================================
echo -e "\n${GREEN}=== 7. Cleaning Home & Configs ===${NC}"
# Wipe config folders for the apps we just deleted
rm -rf ~/.config/libreoffice
rm -rf ~/.config/hexchat
rm -rf ~/.config/transmission
rm -rf ~/.config/rhythmbox
rm -rf ~/.config/pix
rm -rf ~/.config/hypnotix
rm -rf ~/.config/warpinator
rm -rf ~/.mozilla/firefox
rm -rf ~/.thunderbird
rm -rf ~/.local/share/rhythmbox

# WIFI: Uncomment the next line ONLY if you use Ethernet exclusively.
# sudo nmcli radio wifi off

echo -e "\n${GREEN}=== 8. Final System Polish ===${NC}"
sudo apt-get autoremove -y
sudo apt-get autoclean

echo -e "\n${GREEN}==============================================${NC}"
echo -e "${GREEN}  OPTIMIZATION COMPLETE. REBOOT REQUIRED.     ${NC}"
echo -e "${GREEN}==============================================${NC}"
echo "Your system is now clean."
echo "Use 'curl' or 'wget' to grab your browser installer."