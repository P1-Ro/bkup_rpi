#!/bin/bash
# Script to start the backup script "bkup_rpimage.sh" via simple crontab entry

BACKUPDIR=/mnt/Backup/
BACKUPFILE=$(uname -n)-$(date +%F).img
SHARE=//rpi.local/nas/Backup

# create and mount destination folder
mkdir -p $BACKUPDIR
mount -t cifs -o user=,password= $SHARE $BACKUPDIR

#cleanup apt cache
sudo apt-get clean

# Automounting target
if [ -d "$BACKUPDIR" ]; then
        # start script
        bkup_rpimage.sh start -c $BACKUPDIR/$BACKUPFILE
        pishrink.sh -z $BACKUPDIR/$BACKUPFILE
fi

umount $BACKUPDIR
