#!/bin/bash

MYSQL='/usr/bin/mysql'
MYSQLUSER='root'
MYSQLPASS='8*Aj(Dd)'
MYSQLHOST='localhost'
MYSQLDB=$1
MYSQLFILE=$2

if [[ $MYSQLDB == '' ]] || [[ $MYSQLFILE == '' ]]; then
	echo "Please insert database name as first parameter and database file as second parameter"
else
	`mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -Bse "CREATE DATABASE $MYSQLDB DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci"`
	`mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST $MYSQLDB < $MYSQLFILE`
	`mysql -u $MYSQLUSER -p$MYSQLPASS -h $MYSQLHOST -Bse "UPDATE $MYSQLDB.core_config_data SET value='NOINDEX,NOFOLLOW' WHERE path='design/head/default_robots'"`
fi
