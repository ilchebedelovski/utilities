#!/bin/bash

FILE='app/etc/local.xml'
MYDATABASE=$1
PREFIX=$2

$(sed -i '/connection/,/<\/connection/{s/mage-1702\b/'$MYDATABASE'/}' $FILE)
$(sed -i '/db/,/<\/db/{s/mage_\b/'$PREFIX'/}' $FILE)
