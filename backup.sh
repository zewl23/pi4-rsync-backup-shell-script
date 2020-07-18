#!/bin/bash
### !!! ### sudo chmod a+x /XYZ.sh

#Mounting USB Storage for MV from RAM Disk - Cancel script if fail. (we could do later for example local backup onyl if fail)

#Mounting USB HDD
mkdir -p /mnt/PrcekBlue
mount -L PrcekBlue /mnt/PrcekBlue

#Checking if USB HDD was mounted
mount="/mnt/PrcekBlue"

if grep -qs "$mount" /proc/mounts; then
  echo "It's mounted."
else
  echo "It's not mounted."
  mount "$mount"
  if [ $? -eq 0 ]; then
   echo "Mount success!"
  else
   echo "Something went wrong with the mount..."
   stop	
  fi
fi

#Script to synchronise Pi files to Backup folder on USB HDD, fails if there is no drive
BACKUP_MOUNTED=$(mount | awk '/PrcekBlue/ {print $6}' | grep "rw")
if [ $BACKUP_MOUNTED ]; then
    echo $BACKUP_MOUNTED
    echo "Commencing Backup"
    rsync -avH --delete-during --delete-excluded --exclude-from=/usr/bin/rsync-exclude.txt / /mnt/PrcekBlue/Backup/
else
    echo "Backup drive not available or not writable"
fi

#Tar created to RAM-disk, then move to USB mounted drive
mkdir /mnt/BackupRAM
mount -t tmpfs -o size=3G,mode=700 tmpfs /mnt/BackupRAM
cd /mnt/PrcekBlue/
tar cfzv /mnt/BackupRAM/prcek_backup-$(date +%Y.%m.%d_%H-%M-%S).tar.gz Backup
mv /mnt/BackupRAM/* /mnt/PrcekBlue
cd
sleep 5
echo "Now wait for unmounting RAM Disk and writing cache data to USB drive..."
umount /mnt/BackupRAM
echo "RAM disk was unmounted..."
sleep 5
echo "Unmounting USB drive and checking if USB drive was unmounted..."
if grep -qs "$mount" /proc/mounts; then
  echo "USB Drive still mounted... Unmounting..."
  sync && sync
  sleep 5
  umount "$mount"
  if [ $? -eq 0 ]; then
    echo "USB Drive was unmounted and backup script finished! Disconnect USB drive, please."
else
  echo "Something went wrong with the umount... Run umount manualy before disconnecting drive!"
  fi
fi

#How to recover from this?
# sudo rsync -avH /mnt/PrcekBlue/Backup/ /

