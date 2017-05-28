#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 24-11-2014

# A script for creating Magento 1 environment

PWD=$(pwd)
DATE=$(date +"%y%m%d%k%M")
#MYDIR=$(pwd | awk -F/ '{print $NF}')
#MYDATABASE=$MYDIR'_'$1'_'$DATE
HOST='localhost'
USERNAME='username'
PASSWORD='password'
ENVIRONMENT="$1"
SQLFILE=$2

function execute() {

        MYDIR=$1
        MYDATABASE=$MYDIR'_'$ENVIRONMENT'_'$DATE
	ENVURL='http://www.'$ENVIRONMENT'.experiusdevelopment.com/'

        $( mysql -u $USERNAME -p$PASSWORD -h $HOST -Bse "CREATE DATABASE $MYDATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;" )
        $( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE < $SQLFILE )

	$(head -n 50 $SQLFILE > checkmage.sql)
	grep -q "mage_" checkmage.sql; [ $? -eq 0 ] && result="yes" || result="no"
	
	if [ $result == 'yes' ]; then
        #	$( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE < updatemage.sql )
		$( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE -Bse "UPDATE mage_core_config_data SET value=0 WHERE path='dev/js/merge_files'; UPDATE mage_core_config_data SET value=0 WHERE path='dev/css/merge_css_files'")

		$( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE -Bse "UPDATE mage_core_config_data SET value='$ENVURL' WHERE path='web/unsecure/base_url'; UPDATE mage_core_config_data SET value='$ENVURL' WHERE path='web/secure/base_url';"  )

		if [ ! -f createlocal.sh ]; then
		        echo "file createlocal.sh not exists"
		else
		        ./createlocal.sh $MYDATABASE "mage_"
		fi
	
	else
		#$( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE < update.sql )
		$( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE -Bse "UPDATE core_config_data SET value=0 WHERE path='dev/js/merge_files'; UPDATE core_config_data SET value=0 WHERE path='dev/css/merge_css_files'")

		$( mysql -u $USERNAME -p$PASSWORD -h $HOST $MYDATABASE -Bse "UPDATE core_config_data SET value='$ENVURL' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='$ENVURL' WHERE path='web/secure/base_url';"  )

		if [ ! -f createlocal.sh ]; then
        		echo "file createlocal.sh not exists"
		else
        		./createlocal.sh $MYDATABASE ""
		fi
	
	fi

	$(rm -f checkmage.sql)	

}

# 1 = environment name
# 2 = .sql file name

echo "start creating database..."

if [[ $1 == '' && $2 == '' ]]; then
	echo 'first variable should be environment name'
	echo 'second variable should be your .sql file'
else
	if [[ "$PWD" =~ 'clients' ]]; then
        	execute 'clients'
	elif [[ "$PWD" =~ 'development' ]]; then
       		execute 'development'
	elif [[ "$PWD" =~ 'extensions' ]]; then
	      	execute 'extensions'
	else
        	echo "you are not in correct directory"
	fi
fi

echo "end creating database"


