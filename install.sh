#!/bin/bash
# Script to install the backup_rpi.sh helper, bkup_rpimage.sh and pishrink.sh

set -o errexit

# Check sudo
if [ ! "$(id -u)" -eq 0 ]; then
  echo "You must be root to use this. Run with \"sudo $0\""
  exit 1
fi

# Check/Install bkup_rpimage
if hash bkup_rpimage.sh 2>/dev/null; then
  echo "bkup_rpimage already installed"
else
  wget "https://github.com/lzkelley/bkup_rpimage/raw/master/bkup_rpimage.sh"
  chmod a+x bkup_rpimage.sh
  mv bkup_rpimage.sh /usr/local/bin/
  echo "bkup_rpimage succesfully installed"
fi

# Check/Install pishrink
if hash pishrink.sh 2>/dev/null; then
  echo "pishrink already installed"
else
  wget "https://github.com/Drewsif/PiShrink/raw/master/pishrink.sh"
  echo "Patching pishrink"
  sed -i "s/gzip -f9/pigz/g" pishrink.sh
  chmod a+x pishrink.sh
  mv pishrink.sh /usr/local/bin/
  echo "pishrink succesfully installed"
fi

# Install backup script
wget "https://github.com/P1-Ro/bkup_rpimage/raw/master/backup_rpi.sh"
chmod a+x backup_rpi.sh
mv backup_rpi.sh /usr/local/bin/

# Install dependecies
apt get update
apt get install pigz rsync

# Setup share
dialog --title "Install backup script" \
--yesno "Do you want to automatically upload backup to share ?"  $(expr $LINES - 15) $(expr $COLUMNS - 10)
if $? -eq 0; then
  PATH=$(dialog --stdout --title "Please choose a file" --fselect / $(expr $LINES - 15) $(expr $COLUMNS - 10))
  clear
  if [[ -z "$PATH" ]]; then
    sed -i "s/SHARE=\"\"/SHARE=\"$PATH\"/g" /usr/local/bin/backup_rpi.sh
    echo "Share set up succesfully"
  fi
fi

printf "Script set up succesfully.\nSetting up cron."

crontab -l | grep -q 'backup_rpi.sh'  && echo 'Cron job already entry exists' \
 || ( (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/backup_rpi.sh") | crontab - && echo 'Cron job created for user root to run once every month')

 echo "Installation complete"

