#!/bin/bash
#Backup script to archive sent emails older then a set number of days
VERSION=0.1.0
USAGE="Usage: email-backup.sh [username] [domain] [Older then days]"

#Setup variables
DATE=`date +%F_%H:%M`
SENT='true'
INBOX='true'
DIR_PATH="/home/$1/mail/$2/$i"
ARCHIVE_DIR="$DIR_PATH.Archive"
SENT_DIR="$DIR_PATH.Sent"

#Move the files or copy the files
MV="false"

#Check for no variables
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

#show number days value
echo "backing up files older then $3"

#Backup emails in SENT_DIR
if [ $SENT == true ] ; then
        for i in `ls /home/$1/mail/$2`;
        do
                BACKUP_DIR="/backup/email_backup/$DATE/$i/Sent"
                mkdir -p $BACKUP_DIR
                echo "Created backup directory at $BACKUP_DIR"
                    if [ $MV == true ] ; then
                find $SENT_DIR/cur/ -type f -mtime +$3 -exec mv {} $BACKUP_DIR \; 2>/dev/null
                find $SENT_DIR/new/ -type f -mtime +$3 -exec mv {} $BACKUP_DIR \; 2>/dev/null
                    else
                find $SENT_DIR/cur/ -type f -mtime +$3 -exec rsync -avHP {} $BACKUP_DIR \; 2>/dev/null
                find $SENT_DIR/new/ -type f -mtime +$3 -exec rsync -avHP {} $BACKUP_DIR \; 2>/dev/null
                    fi
        done
fi
#Backup any emails in ARCHIVE_DIR
if [ $INBOX == true ] ; then
        for i in `ls /home/$1/mail/$2`;
        do
                BACKUP_DIR="/backup/email_backup/$DATE/$i/Archive"
                mkdir -p $BACKUP_DIR
                echo "Created backup directory at $BACKUP_DIR"
                    if [ $MV == true ] ; then
                find $ARCHIVE_DIR/cur/ -type f -mtime +$3 -exec mv {} $BACKUP_DIR \; 2>/dev/null
                find $ARCHIVE_DIR/new/ -type f -mtime +$3 -exec mv {} $BACKUP_DIR \; 2>/dev/null
                    else
                find $ARCHIVE_DIR/cur/ -type f -mtime +$3 -exec rsync -avHP {} $BACKUP_DIR \; 2>/dev/null
                find $ARCHIVE_DIR/new/ -type f -mtime +$3 -exec rsync -avHP {} $BACKUP_DIR \; 2>/dev/null
                    fi
        done
fi
echo "Backup finished"
