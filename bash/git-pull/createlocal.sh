#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 24-11-2014

# A script for creating Magento 1 environment

FILE='app/etc/local.xml'
MYDATABASE=$1
PREFIX=$2

$(sed -i '/connection/,/<\/connection/{s/mage-1702\b/'$MYDATABASE'/}' $FILE)
$(sed -i '/db/,/<\/db/{s/mage_\b/'$PREFIX'/}' $FILE)
