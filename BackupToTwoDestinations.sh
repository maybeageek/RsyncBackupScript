#!/bin/bash

# TimeMachine-Like rsync-Backupscript
# backing up to two different locations.
# by maybeageek
#
# this work is based off on some guys rsync magic and extended. The source webpage is offline now.
#

DATE=`date "+%Y-%m-%d_%H_%M"`
HOME=/path/to/home/
SOURCE=/path/to/folder/you/want/backuped/
DESTA=/path/to/where/you/want/storeyourbackup1
DESTB=/path/to/where/you/want/storeyourbackup2
LOG=/path/to/logfile/backup.log
EXCLUDE=/path/to/exclude/list/excludefile.txt
CTIME=+5d
# ^How long do you want to keep your backup?

echo "start backup" >> $LOG
date "+%Y-%m-%d_%H_%M" >> $LOG

if test -d $DESTA;
  then
  echo "Volume A found, begin backup" >> $LOG

  rsync -aEz --verbose --delete --delete-excluded --exclude-from=$EXCLUDE --link-dest=$DESTA/current $SOURCE $DESTA/back-$DATE >> $LOG
 
  rm -f $DESTA/current
  ln -s back-$DATE $DESTA/current
 
  echo "deleting backups older than CTIME" >> $LOG
  find $DESTA/back-* -type d -ctime $CTIME -exec rm -rf {} \;
 
  echo "end backup" >> $LOG
  date "+%Y-%m-%d_%H_%M" >> $LOG
  echo "###" >> $LOG
 
  exit 0
 
  else
  echo "Volume A NOT found, test for Volume B" >> $LOG
    if test -d $DESTB;
      then
        echo "Volume B found, begin Backup" >> $LOG
       
        rsync -aEz --verbose --delete --delete-excluded --exclude-from=$EXCLUDE --link-dest=$DESTB/current $SOURCE $DESTB/back-$DATE >> $LOG
       
        rm -f $DESTB/current
        ln -s back-$DATE $DESTB/current
       
        echo "deleting backups older than 5 days" >> $LOG
        find $DESTB/back-* -type d -ctime $CTIME -exec rm -rf {} \;
       
        echo "end backup" >> $LOG
        date "+%Y-%m-%d_%H_%M" >> $LOG
        echo "###" >> $LOG

        exit 0
       
      else
        echo "Volume B not found either, aborting!!" >> $LOG
        exit 1
    fifi

exit 1
