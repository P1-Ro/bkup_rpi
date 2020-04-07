#!/bin/bash
# Script to install the backup_rpi.sh helper, bkup_rpimage.sh and pishrink.sh

# Check sudo
if [ ! "$(id -u)" -eq 0 ]; then
  echo "You must be root to use this. Run with \"sudo $0\""
  exit 1
fi

# Check/Install bkup_rpimage
echo "Checking bkup_rpimage"
if hash bkup_rpimage.sh 2>/dev/null; then
  echo "bkup_rpimage already installed"
else
  echo "Downloading bkup_rpimage"
  wget -q "https://github.com/lzkelley/bkup_rpimage/raw/master/bkup_rpimage.sh"
  chmod a+x bkup_rpimage.sh
  mv bkup_rpimage.sh /usr/local/bin/
  echo "bkup_rpimage succesfully installed"
fi

# Check/Install pishrink
echo "Checking pishrink"
if hash pishrink.sh 2>/dev/null; then
  echo "pishrink already installed"
else
  echo "Downloading pishrink"
  wget -q "https://github.com/Drewsif/PiShrink/raw/master/pishrink.sh"
  echo "Patching pishrink"
  sed -i "s/gzip -f9/pigz/g" pishrink.sh
  chmod a+x pishrink.sh
  mv pishrink.sh /usr/local/bin/
  echo "pishrink succesfully installed"
fi

# Install backup script
echo "Checking backup_rpi"
if hash backup_rpi.sh 2>/dev/null; then
  echo "backup_rpi already installed"
else
  echo "Downloading backup_rpi"
  wget -q "https://github.com/P1-Ro/bkup_rpi/raw/master/backup_rpi.sh"
  chmod a+x backup_rpi.sh
  mv backup_rpi.sh /usr/local/bin/
  echo "backup_rpi succesfully installed"
fi

# Install dependecies
echo "Installing dependecies"
apt-get update > /dev/null
apt-get install pigz rsync > /dev/null

# Setup share
read -r -p "Do you want to automatically upload backup to share ? [y/N]" SHARE
if [ "$SHARE" == "y" ]; then
  read -r -p "Please type path URL of share: " SHARE_PATH
  read -r -p "Please provide user for share: " USER
  read -r -p "Please provide password for share: " PASS
  if [[ -n "$SHARE_PATH" ]]; then
    sed -i "s/SHARE=\"\"/SHARE=\"$SHARE_PATH\"/g" /usr/local/bin/backup_rpi.sh
    sed -i "s/user=,password=/user=$USER,password=$PASS/g" /usr/local/bin/backup_rpi.sh
    echo "Share set up succesfully"
  fi
fi

echo "Setting up cron"

crontab -l | grep -q 'backup_rpi.sh' && echo 'Cron job already entry exists' || ( (crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/backup_rpi.sh") | crontab - && echo 'Cron job created for user root to run once every month')

echo "Installation complete"

