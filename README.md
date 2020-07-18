# pi4-rsync-backup-shell-script
Personal script for backing up Raspberry Pi4 to USB HDD

Prerequisities:
1) Raspberry Pi4 4GB minimum with enough free RAM (3GB minimum), or you can change script to use the same USB drive for creating the tar.gz from your Backup folder inside the drive it self and do not copy compressed data from RAM drive to USB drive

2) USB HDD must have a partition called PrcekBlue OR you can find "PrcekBlue" in "backup.sh" and chage it to fit your partition LABEL on USB drive

3) Your backup must fit into 3GB total compressed - it will create RAM disk with 3GB to store compressed data from folder Backup on USB drive after rsync backup 

What needs to be done:
1) Copy the script "backup.sh" to your favourite folder (I am using "/home/pi4") and run:

$ sudo cp backup.sh /home/pi4

2) Set script permissions

$ sudo chmod a+x backup.sh

3) Copy also "rsync-exclude.txt" to /usr/bin/rsync-exclude.txt

$ sudo cp rsync-exclude.txt /usr/bin/rsync-exclude.txt

4) Edit script to fit your needs

$ sudo nano backup.sh

5) Run the script

$ sudo ./backup.sh
