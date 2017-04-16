#!/bin/bash
#Backup script to archive sent emails older then a set number of days
VERSION=0.1.0
USAGE="Usage: email-backup.sh [username] [domain] [Older then days]"

#Setup variables
DATE=`date +%F_%H:%M`
SENT='true'
INBOX='true'
DAYS="$3"
DIR_PATH="/home/$1/mail/$2"
ARCHIVE_DIR="/home/$1/mail/$2/{$i}.Archive"
SENT_DIR="/home/$1/mail/$2/{$i}.Sent"

#Move the files or copy the files
TRANSFER_METHOD="rsync"
RSYNC="rsync -avHP"
MV="mv"

#Check for no variables
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

transfer_email(){
    echo "find $1/cur/ -type f -mtime +$DAYS -exec $2 {} $3 \;" 
    echo "find $1/new/ -type f -mtime +$DAYS -exec $2 {} $3 \;"
}

#show number days value
echo "backing up files older then $3"

#Backup emails in SENT_DIR
if [ $SENT == true ] ; then
        pushd $DIR_PATH 1>/dev/null
        for i in */;
        do
                BACKUP_DIR="/backup/email_backup/$DATE/$i/Sent"
                mkdir -p $BACKUP_DIR
                echo "Created backup directory at $BACKUP_DIR"
                    if [ $TRANSFER_METHOD == rsync ] ; then
                transfer_email $SENT_DIR $RSYNC $BACKUP_DIR
                    else
                transfer_email $SENT_DIR $MV $BACKUP_DIR
                    fi
        done
        popd 1>/dev/null
fi
#Backup any emails in ARCHIVE_DIR
if [ $INBOX == true ] ; then
        pushd $DIR_PATH 1>/dev/null
        for i in */;
        do
                BACKUP_DIR="/backup/email_backup/$DATE/$i/Archive"
                mkdir -p $BACKUP_DIR
                echo "Created backup directory at $BACKUP_DIR"
                    if [ $TRANSFER_METHOD == rsync ] ; then
                transfer_email $ARCHIVE_DIR $RSYNC $BACKUP_DIR
                    else
                transfer_email $ARCHIVE_DIR $MV $BACKUP_DIR
                    fi
        done
        popd 1>/dev/null
fi
echo "Backup finished"
