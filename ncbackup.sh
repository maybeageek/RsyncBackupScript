#!/bin/bash

#
# TimeMachine like backup for my nextcloud instance running in a remote datacenter
#

# Variable declaration
ncfolder="/var/www/nextcloud/"
ncdata="/mnt/nextcloud/data/"
webserveruser="www-data"
databasename="nextcloud"
DATE=$(date "+%Y-%m-%d-%H-%M-%S")
CTIME=+30

# Check for root

if [ "$(id -u)" != "0" ]
then
    echo "ERROR: This script has to be run as root!"
    exit 1
fi

# Putting nextcloud into maintenance mode
echo "Switching on maintenance mode..."
sudo -u $webserveruser php --define apc.enable_cli=1 $ncfolder/occ maintenance:mode --on
echo "Done"

# Backup creation
echo "Backup nextcloud dir ..."
sudo rsync -avx --delete --link-dest=../current-nextcloud $ncfolder ncbackup@172.18.0.20:/tank/ncbackup/nextcloud/nextcloud-$DATE
ssh ncbackup@172.18.0.20 "rm -f /tank/ncbackup/nextcloud/current-nextcloud"
ssh ncbackup@172.18.0.20 "ln -s /tank/ncbackup/nextcloud/nextcloud-$DATE /tank/ncbackup/nextcloud/current-nextcloud"
ssh ncbackup@172.18.0.20 "touch /tank/ncbackup/nextcloud/nextcloud-$DATE"
echo "Done"

echo "Backup data dir ..."
sudo rsync -avx --delete --link-dest=../current-data $ncdata ncbackup@172.18.0.20:/tank/ncbackup/nextcloud/data-$DATE
ssh ncbackup@172.18.0.20 "rm -f /tank/ncbackup/nextcloud/current-data"
ssh ncbackup@172.18.0.20 "ln -s /tank/ncbackup/nextcloud/data-$DATE /tank/ncbackup/nextcloud/current-data"
ssh ncbackup@172.18.0.20 "touch /tank/ncbackup/nextcloud/data-$DATE"
echo "Done"

# backup the database from nextcloud
echo "Backup nextcloud database ..."
sudo mysqldump --single-transaction --default-character-set=utf8mb4 -h localhost nextcloud > nextcloud-sqlbkp_`date +"%Y-%m-%d-%H-%M-%S"`.bak
sudo rsync -avx --delete nextcloud-sqlbkp* ncbackup@172.18.0.20:/tank/ncbackup/nextcloud/
sudo rm nextcloud-sqlbkp*
echo "Done"

# Putting nextcloud out of maintenance mode
echo "Switching off maintenance mode..."
sudo -u $webserveruser php --define apc.enable_cli=1 $ncfolder/occ maintenance:mode --off
echo "Done"

# Deleting old backups
ssh ncbackup@172.18.0.20 "find /tank/ncbackup/nextcloud/nextcloud-* -maxdepth 0 -type d -ctime $CTIME -exec rm -rf {} \;"
ssh ncbackup@172.18.0.20 "find /tank/ncbackup/nextcloud/data-* -maxdepth 0 -type d -ctime $CTIME -exec rm -rf {} \;"
ssh ncbackup@172.18.0.20 "find /tank/ncbackup/nextcloud/nextcloud-sql* -maxdepth 0 -ctime $CTIME -exec rm -rf {} \;"
