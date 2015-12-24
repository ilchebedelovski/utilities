#!/bin/bash

PWD=$(pwd)
echo "creating directories..."

#creating var dir
if [[ $PWD =~ '/home/html/clients' || $PWD =~ '/home/html/development' || $PWD =~ '/home/html/extensions' ]]; then
	mkdir var
	mkdir var/cache
	chmod 777 -R var

	mkdir media/catalog/product/cache
	chmod 777 -R media/catalog/product/cache
else
	echo	"please change your directory position"
fi

echo "finish creating directories"
