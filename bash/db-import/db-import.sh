#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 09-06-2014

# A script for importing databases

MYSQL='/usr/bin/mysql'
MYSQLUSER='username'
MYSQLPASS='password'
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
