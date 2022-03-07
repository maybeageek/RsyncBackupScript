#!/bin/bash

# TimeMachine-Like rsync-Backupscript
# backing up to two different locations.
# © by Thomas Zimmermann thommy@tomkatweb.org
#
# this work is based on the work over at http://blog.interlinked.org/tutorials/rsync_time_machine.html
#
# Tipps:
#- Restore a file: Simply drag&drop it
#- To see the actual disk-requierements for a single backup: du -shc back-*
#- You can remove an old backup by simply deleting the directory
#- "rsync -E" is just for Apple OS X Systems. It keeps the extended attributes
#- to send eMails:
#    GUT=/Users/tzimmermann/Desktop/gut.txt
#    mailx -s "Test" thommy@tomkatweb.org < $GUT

DATE=`date "+%Y-%m-%d_%H_%M"`
HOME=/Users/thommy/
EXCLUDE=/Users/tzimmermann/excludefile.txt
SOURCE=/Users/tzimmermann/ImportantData/
DESTA=/Volumes/BackupA
DESTB=/Volumes/BackupB
LOG=/Users/tzimmermann/logs/backup.log
MAIL=/Users/tzimmermann/tmp/mail
CTIME=+5d

echo "Backupscript starts" >> $LOG
date "+%Y-%m-%d_%H_%M" >> $LOG

if test -d $DESTA;
  then
  echo "Volume A found, begin backup" >> $LOG

  rsync -aEz --verbose --delete --delete-excluded --exclude-from=$EXCLUDE --link-dest=$DESTA/current $SOURCE $DESTA/back-$DATE >> $LOG
 
  rm -f $DESTA/current
  ln -s back-$DATE $DESTA/current
 
  echo "deleting backups older than 5 days" >> $LOG
  find /Volumes/BackupA/back-* -type d -ctime $CTIME -exec rm -rf {} \;
 
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
        find /Volumes/BackupB/back-* -type d -ctime $CTIME -exec rm -rf {} \;
       
        echo "end backup" >> $LOG
        date "+%Y-%m-%d_%H_%M" >> $LOG
        echo "###" >> $LOG

        exit 0
       
      else
        echo "Volume B not found either, aborting!!" >> $LOG
        exit 1
    fifi

exit 1
