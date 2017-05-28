#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 24-11-2014

# A script for creating Magento 1 environment

PWD=$(pwd)
echo "Creating directories..."

#creating var dir
if [[ $PWD =~ '/home/html/clients' || $PWD =~ '/home/html/development' || $PWD =~ '/home/html/extensions' ]]; then
	mkdir 'var'
	mkdir 'var/cache'
	chmod 777 -R 'var'

	mkdir 'media/catalog/product/cache'
	chmod 777 -R 'media/catalog/product/cache'
else
	echo	"Please change your directory position"
fi

echo "Finish creating directories"
