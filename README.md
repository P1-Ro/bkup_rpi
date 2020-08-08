# bkup_rpi
Script to backup a Raspberry Pi disk image as small as possible

## What it does:
This script installs [bkup_rpimage](https://github.com/lzkelley/bkup_rpimage) backup script and all dependencies.
It also creates cron job which creates backup image once every month in directory you specify.  

## Installation:
Easy install with:

    curl -L "https://github.com/P1-Ro/bkup_rpi/raw/master/install.sh" | sudo bash
    
Or you can clone this repo and run `install.sh` manually.   
