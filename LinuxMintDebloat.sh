#!/bin/bash

echo "===→ Starting Deep Debloat ←===" && \

sudo apt purge --autoremove -y \
  libreoffice-common libreoffice-core \
  thunderbird \
  vlc vlc-* rhythmbox \
  hypnotix \
  transmission-gtk transmission-common \
  hexchat hexchat-common \
  pidgin \
  warpinator \
  drawing pix \
  sticky xreader simple-scan webapp-manager \
  system-config-printer cups cups-browsed cups-client cups-common \
  cups-core-drivers cups-daemon cups-ppdc cups-server-common \
  printer-driver-* hplip \
  firefox firefox-locale-* 2>/dev/null && \

sudo apt autoremove -y && \
sudo apt autoclean && \

sudo systemctl stop bluetooth.service 2>/dev/null && \
sudo systemctl disable bluetooth.service 2>/dev/null && \
sudo systemctl mask bluetooth.service 2>/dev/null && \

echo "" && \

echo "===→ Debloat Complete! ←==="
