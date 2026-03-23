#!/bin/bash
SOURCE="/mnt/usb-data/services/"
QNAP_USER="chops"
QNAP_IP="192.168.88.101"
QNAP_PATH="/shared_media/Backups/Pi-HomeLab/"
DEST="$QNAP_USER@$QNAP_IP:$QNAP_PATH"

echo "Syncing Services to QNAP..."

# Stop DB-heavy services to prevent corruption
cd /mnt/usb-data/services/docker-compose
docker-compose stop uptime-kuma beszel homarr

# Perform Sync
rsync -avz --exclude '**/logs/*' --exclude '**/*.log' --delete $SOURCE $DEST

# Bring services back up
docker-compose start

echo "Backup to QNAP finished."
