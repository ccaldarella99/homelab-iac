#!/bin/bash
# =================================================================
# Chops' Home Lab Bootstrap - Raspberry Pi (Trixie/ARM64)
# =================================================================

# 1. System Protection (SD Card Preservation)
echo "🛡️ Configuring SD Card Protections..."
sudo apt update && sudo apt install -y log2ram zram-tools rsync

# Update log2ram to 512MB
sudo sed -i 's/SIZE=128M/SIZE=512M/' /etc/log2ram.conf

# Mount /tmp in RAM (tmpfs)
if ! grep -q "/tmp tmpfs" /etc/fstab; then
    echo "tmpfs /tmp tmpfs defaults,noatime,nosuid,size=250M 0 0" | sudo tee -a /etc/fstab
    sudo mount -a
fi

# 2. Directory Architecture
echo "📁 Building USB Service Directory..."
SERVICES_DIR="/mnt/usb-data/services"
mkdir -p $SERVICES_DIR/{ansible,uptime-kuma,beszel,homepage,homarr,fail2ban,docker-compose}
mkdir -p $SERVICES_DIR/ansible/{collections,roles,plugins/modules}

# 3. Ansible Environment Setup
echo "🤖 Configuring Ansible for USB..."
if ! grep -q "ANSIBLE_HOME" ~/.bashrc; then
    echo "export ANSIBLE_HOME=$SERVICES_DIR/ansible" >> ~/.bashrc
fi

# 4. Automation (Cron Job for Backups)
echo "⏰ Setting up Nightly Backups to QNAP..."
BACKUP_SCRIPT="$SERVICES_DIR/ansible/backup-to-qnap.sh"
chmod +x $BACKUP_SCRIPT

# Add to crontab if not already there
(crontab -l 2>/dev/null | grep -F "$BACKUP_SCRIPT") || \
(crontab -l 2>/dev/null; echo "0 2 * * * $BACKUP_SCRIPT >> /var/log/backup.log 2>&1") | crontab -

echo "✅ Lab Setup Complete!"
echo "⚠️ Please REBOOT to finalize log2ram and RAM disk changes."