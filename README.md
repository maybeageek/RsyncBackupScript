# RsyncBackupScript

this work is based off on some guys rsync magic and extended/reworked and fitted to my purposes. The source webpage is offline now.

There are several versions, not all of them usable on all systems.

This script creates a backup with a date each time it is run. It also deletes backups older than the defined time (see variables).
It uses links so that each backup folder contains everything, yet a file that has not changed is only physically ONCE on the backup disk.
This saves tremendous amounts of data. If you delete a file from source, and then your oldest backup containing a copy of the file ages out
thus deleting the last reference to the file, it gets deleted from disk.

Tipps:

- Restore a file: Simply browse to the date in question and drag&drop it
- To see the actual disk-requierements for a single backup: du -shc back-*
- You can remove an old backup by simply deleting the directory
- "rsync -E" is just for Apple OS X Systems. It keeps the extended attributes. Remove the -E option on Linux and FreeBSD.

# Happy backup :-)