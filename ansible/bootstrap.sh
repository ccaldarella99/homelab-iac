#!/bin/bash
# Home Lab Bootstrap Script for Raspberry Pi (Debian Trixie)
# Target: /mnt/usb-data/services/

echo "Starting Home Lab Bootstrap..."

# 1. Update and Install Prerequisites
sudo apt update && sudo apt install -y curl git docker-compose ansible log2ram

# 2. Configure log2ram (Set to 512MB)
sudo sed -i 's/SIZE=128M/SIZE=512M/' /etc/log2ram.conf
sudo sed -i 's/LOG_DISK_SIZE=128M/LOG_DISK_SIZE=512M/' /etc/log2ram.conf

# 3. Secure /tmp in RAM (tmpfs)
if ! grep -q "/tmp tmpfs" /etc/fstab; then
    echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=250M 0 0" | sudo tee -a /etc/fstab
    sudo mount -a
fi

# 4. Create USB Directory Structure
mkdir -p /mnt/usb-data/services/{ansible,uptime-kuma,beszel,homepage,homarr,fail2ban,backups}
mkdir -p /mnt/usb-data/services/ansible/{collections,roles,plugins/modules}

# 5. Setup Ansible Environment Variables
if ! grep -q "ANSIBLE_HOME" ~/.bashrc; then
    echo 'export ANSIBLE_HOME=/mnt/usb-data/services/ansible' >> ~/.bashrc
    source ~/.bashrc
fi

echo "Bootstrap complete. Please REBOOT to apply log2ram changes."