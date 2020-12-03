#!/bin/bash
set -x
#
# author: qemtrails
# purpose: minecraft backup script
# date: 11/30/2020
#

export MC_HOME='/opt/minecraft/paper/'
export BACKUP_DIR='/opt/minecraft/backups'
export TIMESTAMP=`date +"%m%d%Y_%H%M%s"`
export BACKUP_FILE=$BACKUP_DIR/paper.$TIMESTAMP.tar.gz
#echo $BACKUP_FILE

#tar -czf $BACKUP_FILE $MC_HOME


cd $BACKUP_DIR
export BACKUP_COUNT=`find . -type f -cmin +360|wc -l`
if [[ $BACKUP_COUNT -gt 0 ]]
then
  export OLD_BACKUPS=`find . -type f -cmin +360`
  for BACKUP in $OLD_BACKUPS
  do
    echo "copying "$BACKUP" to AWS"
    aws s3 cp $BACKUP s3://monkey-backups
    export VAL_FILE=`aws s3 ls monkey-backups|grep $BACKUP`
    if [[ $VAL_FILE -eq 1 ]]
    then
      rm $BACKUP
    else
      echo $BACKUP" was not copied to aws"    
    fi
  done
else
  echo "Foo on you"
fi

#aws sts get-caller-identity
