#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 30-08-2013

# A script for creating mysql backups

XML_PATH=$(pwd)/app/etc/local.xml
PWD=$(pwd)/app/etc/local.xml
DATE=$(date +"%d-%m-%y")

HOST='host'
USERNAME='username'
PASSWORD='password'
DB_NAME='dbname'

if [ ! -f $XML_PATH ]; then
	echo $"$XML_PATH not found!"
else

	HOST_RESULT=$(grep "<$HOST>.*<.$HOST>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$HOST/<$HOST/" | cut -f2 -d">"| cut -f1 -d"<")
	USERNAME_RESULT=$(grep "<$USERNAME>.*<.$USERNAME>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$USERNAME/<$USERNAME/" | cut -f2 -d">"| cut -f1 -d"<")
	PASSWORD_RESULT=$(grep "<$PASSWORD>.*<.$PASSWORD>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$PASSWORD/<$PASSWORD/" | cut -f2 -d">"| cut -f1 -d"<")
	DB_NAME_RESULT=$(grep "<$DB_NAME>.*<.$DB_NAME>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$DB_NAME/<$DB_NAME/" | cut -f2 -d">"| cut -f1 -d"<")

	if [ $(mysqldump -u $USERNAME_RESULT -p$PASSWORD_RESULT -h $HOST_RESULT $DB_NAME_RESULT > $DB_NAME_RESULT'-'$DATE'.sql') ]; then
		echo "mysqldump"
	fi

fi
