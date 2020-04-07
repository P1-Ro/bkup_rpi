# bkup_rpi
Script to backup a Raspberry Pi disk image as small as possible

## What it does:
This script installs [bkup_rpimage](https://github.com/lzkelley/bkup_rpimage), [PiShrink](https://github.com/Drewsif/PiShrink), backup script and all dependecies.
It also creates cron job which creates backup image once every month in `/mnt/Backup`  

## Installation:
Easy install with:

    curl "https://github.com/P1-Ro/bkup_rpi/raw/master/install.sh" | sudo bash
    
Or you can clone this repo and run `install.sh` manually.   
