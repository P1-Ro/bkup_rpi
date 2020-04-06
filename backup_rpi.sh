#!/bin/bash
# Script to start the backup script "bkup_rpimage.sh" via simple crontab entry

# Params
BACKUPDIR=/mnt/Backup/
BACKUPFILE=$(uname -n)-$(date +%F).img
SHARE=""

# create and mount destination folder
mkdir -p "$BACKUPDIR"
if [[ -z "$SHARE" ]]; then
  mount -t cifs -o user=,password= "$SHARE" "$BACKUPDIR"
fi

#cleanup apt cache
sudo apt-get clean

# Automounting target
if [ -d "$BACKUPDIR" ]; then
        # start script
        bkup_rpimage.sh start -c "$BACKUPDIR/$BACKUPFILE"
        pishrink.sh -z "$BACKUPDIR/$BACKUPFILE"
fi

if [[ -z "$SHARE" ]]; then
  umount $BACKUPDIR
fi

