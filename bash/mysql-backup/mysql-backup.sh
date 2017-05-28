#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 28-04-2013

# A script for creating backups and placing them on Amazon S3

S3CMD=/usr/bin/s3cmd
RM=/bin/rm
TAR=/bin/tar
  
MYSQLDUMP=/usr/bin/mysqldump
MYSQLUSER="username"
MYSQLPASS="password"
MYSQLHOST="localhost"

DATE=$(date +"%y%m%d%H%M")
DAY=$(date +"%u")

DBNAME=`ls -lah /var/lib/mysql/ | grep mconnect | awk '{print $9}'`

for line in $DBNAME; do

	FILENAME="$line-$DATE.sql"
	environment=`echo $DBNAME | cut -d "_" -f2`
	dirname=/var/backups/`echo $DBNAME | cut -d "_" -f2`
	s3cmddst="s3://backups/databases/$environment/"

	if [ ! -d $dirname ]; then
		`mkdir -p $dirname`
	fi

	`$MYSQLDUMP -u $MYSQLUSER -p -h $MYSQLHOST -p$MYSQLPASS $line > "$dirname/$FILENAME"`

	FILESIZE=`ls -lS $dirname | grep $FILENAME | awk '{print $5}'`

	if [ $DAY == 6 ]; then

		tarname="/var/backups/"$environment"-"$DATE".tar.gz"
		`$TAR zcvf $tarname  $dirname`
		`$S3CMD put $tarname $s3cmddst 2>/dev/null`

		`$RM -Rf $tarname`
		`$RM -Rf $dirname`

	fi

done
