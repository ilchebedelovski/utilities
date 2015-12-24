#!/bin/bash
### ilche ###
#Bash scipt for importing from .sql

if [[ $1 = '' && $2 = '' ]]; then
	echo "write input variables"
	echo "first you have to write the database name"
	echo "second you have to write the name of the .sql file"
else
	if [ ! -f $2 ]; then
		echo $"$2 file not found!"
	else
		XML_PATH=$(pwd)/app/etc/local.xml
		PWD=$(pwd)/app/etc/local.xml
		DATE=$(date +"%d-%m-%y")

		HOST='host'
		USERNAME='username'
		PASSWORD='password'
		DB_NAME=$1

		HOST_RESULT=$(grep "<$HOST>.*<.$HOST>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$HOST/<$HOST/" | cut -f2 -d">"| cut -f1 -d"<")
		USERNAME_RESULT=$(grep "<$USERNAME>.*<.$USERNAME>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$USERNAME/<$USERNAME/" | cut -f2 -d">"| cut -f1 -d"<")
		PASSWORD_RESULT=$(grep "<$PASSWORD>.*<.$PASSWORD>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$PASSWORD/<$PASSWORD/" | cut -f2 -d">"| cut -f1 -d"<")
		DB_NAME_RESULT=$(grep "<$DB_NAME>.*<.$DB_NAME>" $XML_PATH | sed -e "s/<\!\[CDATA\[//" | sed -e "s/\]\]>//" | sed -e "s/^.*<$DB_NAME/<$DB_NAME/" | cut -f2 -d">"| cut -f1 -d"<")

		if [ $(mysql -u $USERNAME_RESULT -p$PASSWORD_RESULT -h $HOST_RESULT $DB_NAME < $2) ]; then
			echo "mysql import"
		fi
	fi
fi
	
