#!/bin/bash

# TimeMachine-Like rsync-Backupscript for backing up my Jellyfin server
# by maybeageek
#
 

DATE=`date "+%Y-%m-%d-%H-%M-%S"`
SOURCE=/tank/jellyfin/
DEST=/mnt/backupdisk/jellyfin/
LOG=/mnt/backupdisk/backup.log
CTIME=+5

echo "Start Backup" >> $LOG
date "+%Y-%m-%dT%H_%M_%S" >> $LOG

rsync -aEz --delete --link-dest=$DEST/current $SOURCE $DEST/back-$DATE >> $LOG
rm -f $DEST/current
ln -s back-$DATE $DEST/current

echo "deleting backups older than CTIME" >> $LOG
find $DEST/back-* -maxdepth 0 -type d -ctime $CTIME -exec rm -rf {} \;

echo "End Backup" >> $LOG
date "+%Y-%m-%dT%H_%M_%S" >> $LOG
echo "###" >> $LOG
