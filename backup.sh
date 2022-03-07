#!/bin/bash


# TimeMachine-Like rsync-Backupscript
# by Thomas Zimmermann
#
# this work is based on the work over at http://blog.interlinked.org/tutorials/rsync_time_machine.html
# 
# Tipps:
# 	- Restore a file: Simply drag&drop it
#	- To see the actual disk-requierements for a single backup: du -shc back-*
#	- You can remove an old backup by simply deleting the directory
# 	- "rsync -E" is just for MacOS X Systems. It keeps the extended attributes
# to send eMails:
#    GUT=/Users/tzimmermann/Desktop/gut.txt
#    mailx -s "Test" tzimmermann@energy-net.de < $GUT

DATE=`date "+%Y-%m-%dT%H_%M_%S"`
HOME=/Users/thommy/
SOURCE=/Users/thommy/
DEST=/Volumes/Backup/MacHome/
LOG=/Volumes/Backup/backup.log

echo "Start Backup" >> $LOG
date "+%Y-%m-%dT%H_%M_%S" >> $LOG

rsync -aEz --delete --delete-excluded --exclude-from=$HOME/.rsync/exclude --link-dest=$DEST/current $SOURCE $DEST/back-$DATE >> $LOG

echo "End Backup" >> $LOG
date "+%Y-%m-%dT%H_%M_%S" >> $LOG
echo "###" >> $LOG

rm -f $DEST/current
ln -s back-$DATE $DEST/current