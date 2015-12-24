#!/bin/bash

INDEX=/home/html/git/index.php
LOCAL=/home/html/git/local.xml
HTACCESS=/home/html/git/.htaccess
PWD=$(pwd)

echo "start copying files..."

if [[ $PWD =~ '/home/html/clients' || $PWD =~ '/home/html/development' || $PWD =~ '/home/html/extensions' ]]; then
	if [[ ( -f $INDEX ) && ( -f $LOCAL ) && ( -f $HTACCESS ) ]]; then
		$(cp -rf $INDEX $PWD'/')
		$(cp -rf $HTACCESS $PWD'/')
		$(cp -rf $LOCAL $PWD'/app/etc/')
	else
		echo "files not exist"
	fi
else
        echo    "please change your root directory"
fi

echo "end copying files"
