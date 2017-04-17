#!/bin/bash
#Backup script to archive sent emails older then a set number of days
#This is designed to backup emails put into the Archive folder as well as the Sent folder

VERSION=0.1.0
USAGE="Usage: email-backup.sh [domain] [days]"

#Check for no variables
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

#Check which cpanel user owns domain
USER=`/scripts/whoowns $1`

#Setup variables
DATE=`date +%F_%H:%M`
SENT='true'
INBOX='true'
DAYS="$2"
DOMAIN="$1"
DIR_PATH="/home/$USER/mail/$DOMAIN"

#Move the files or copy the files
TRANSFER_METHOD="move"


#Check for no variables
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

move_email(){
    find $1/{cur,new}/ -type f -mtime +$DAYS -exec mv {} "$3" \;
}
copy_email(){
    rsync -aH $1/{cur,new}/ $2
}

#show number days value
echo "backing up files older then $3"

#Backup emails in SENT_DIR
if [ $SENT == true ] ; then
        pushd $DIR_PATH 1>/dev/null
        for i in */;
        do
                BACKUP_DIR="/backup/email_backup/$DATE/${i}Sent"
                SENT_DIR="/home/$USER/mail/$DOMAIN/$i.Sent"
                mkdir -p $BACKUP_DIR
                echo "Created backup directory at $BACKUP_DIR"
                    if [ $TRANSFER_METHOD == copy ] ; then
                        copy_email $SENT_DIR $BACKUP_DIR
                    elif [ $TRANSFER_METHOD == move ]; then
                        move_email $SENT_DIR $BACKUP_DIR
                    else
                        echo "Invalid transfer method!"
                        exit 1;
                    fi
        done
        popd 1>/dev/null
fi
#Backup any emails in ARCHIVE_DIR
if [ $INBOX == true ] ; then
        pushd $DIR_PATH 1>/dev/null
        for i in */;
        do
                BACKUP_DIR="/backup/email_backup/$DATE/${i}Archive"
                ARCHIVE_DIR="/home/$USER/mail/$DOMAIN/$i.Archive"
                mkdir -p $BACKUP_DIR
                echo "Created backup directory at $BACKUP_DIR"
                    if [ $TRANSFER_METHOD == copy ] ; then
                        copy_email $ARCHIVE_DIR $BACKUP_DIR
                    elif [ $TRANSFER_METHOD == move ]; then
                        move_email $ARCHIVE_DIR $BACKUP_DIR
                    else
                        echo "Invalid transfer method!"
                        exit 1;
                    fi
        done
        popd 1>/dev/null
fi
echo "Backup finished"
