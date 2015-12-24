#!/bin/bash

S3CMD=/usr/bin/s3cmd
RM=/bin/rm
TAR=/bin/tar
  
MYSQLDUMP=/usr/bin/mysqldump
MYSQLUSER="root"
MYSQLPASS="5z2yg\$PQJK1b"
MYSQLHOST="localhost"

DATE=$(date +"%y%m%d%H%M")
DAY=$(date +"%u")

DBNAME=`ls -lah /var/lib/mysql/ | grep mconnect | awk '{print $9}'`

for line in $DBNAME; do

	FILENAME="$line-$DATE.sql"
	environment=`echo $DBNAME | cut -d "_" -f2`
	dirname=/var/backups/`echo $DBNAME | cut -d "_" -f2`
	s3cmddst="s3://mconnect-backups/databases/$environment/"

	if [ ! -d $dirname ]; then
		`mkdir -p $dirname`
	fi

	`$MYSQLDUMP -u $MYSQLUSER -p -h $MYSQLHOST -p$MYSQLPASS $line > "$dirname/$FILENAME"`

	FILESIZE=`ls -lS $dirname | grep $FILENAME | awk '{print $5}'`

	if [ $DAY == 3 ]; then

		tarname="/var/backups/"$environment"-"$DATE".tar.gz"
		`$TAR zcvf $tarname  $dirname`
		`$S3CMD put $tarname $s3cmddst 2>/dev/null`

		`$RM -Rf $tarname`
		`$RM -Rf $dirname`

	fi

done
