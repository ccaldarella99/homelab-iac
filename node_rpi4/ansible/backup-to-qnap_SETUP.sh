#!/bin/bash
# Make scripts executable
chmod +x /mnt/usb-data/services/ansible/*.sh

# Add to crontab (2 AM daily)
(crontab -l 2>/dev/null; echo "0 2 * * * /mnt/usb-data/services/ansible/backup-to-qnap.sh >> /var/log/backup.log 2>&1") | crontab -
