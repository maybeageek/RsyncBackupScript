#!/bin/bash

# TimeMachine-Like rsync-Backupscript
# by maybeageek
#
# this work is based off on some guys rsync magic and extended. The source webpage is offline now.
# 

DATE=`date "+%Y-%m-%dT%H_%M_%S"`
HOME=/path/to/home/
SOURCE=/path/to/folder/you/want/backuped/
DEST=/path/to/where/you/want/storeyourbackup
LOG=/path/to/logfile/backup.log

echo "Start Backup" >> $LOG
date "+%Y-%m-%dT%H_%M_%S" >> $LOG

rsync -aEz --delete --delete-excluded --exclude-from=$HOME/.rsync/exclude --link-dest=$DEST/current $SOURCE $DEST/back-$DATE >> $LOG

echo "End Backup" >> $LOG
date "+%Y-%m-%dT%H_%M_%S" >> $LOG
echo "###" >> $LOG

rm -f $DEST/current
ln -s back-$DATE $DEST/current
