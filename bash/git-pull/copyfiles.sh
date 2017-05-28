#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 24-11-2014

# A script for creating Magento 1 environment

INDEX=/home/html/git/index.php
LOCAL=/home/html/git/local.xml
HTACCESS=/home/html/git/.htaccess
PWD=$(pwd)

echo "Start copying files..."

if [[ $PWD =~ '/home/html/clients' || $PWD =~ '/home/html/development' || $PWD =~ '/home/html/extensions' ]]; then
	if [[ ( -f $INDEX ) && ( -f $LOCAL ) && ( -f $HTACCESS ) ]]; then
		$(cp -rf $INDEX $PWD'/')
		$(cp -rf $HTACCESS $PWD'/')
		$(cp -rf $LOCAL $PWD'/app/etc/')
	else
		echo "No such a file or directory"
	fi
else
        echo    "Please change your root directory"
fi

echo "Finish copying files"
