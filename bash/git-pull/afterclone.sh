#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 24-11-2014

# A script for creating Magento 1 environment

ENVIRONMENT=$1
SQLNAME=$2

echo "first parameter should be domain name"
echo "second parameter should be .sql file"
echo "******************************************"

if [ -f 'app/Mage.php' ]; then
	if [[ ! -z $ENVIRONMENT  ]]; then
		if [ ! -f createdir.sh ]; then
			echo "file createdir.sh not exists"
		else
			./createdir.sh $ENVIRONMENT $SQLNAME
		fi
		if [ ! -f copyfiles.sh ]; then
			echo "file copyfiles.sh not exists"
		else
			./copyfiles.sh $ENVIRONMENT $SQLNAME
		fi
		if [ ! -f execute.sh ]; then
			echo "file execute.sh not found"
		else
			./execute.sh $ENVIRONMENT $SQLNAME
		fi
		if [ ! -f virtualhost.sh ]; then
			echo "file virtualhost.sh not found"
		else
			./virtualhost.sh $ENVIRONMENT $SQLNAME
		fi
	fi
else
	echo "Please change your position to magento root"
fi
