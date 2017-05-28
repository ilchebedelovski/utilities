#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 04-01-2013

# A script for monitoring resources from AWS

# Creating custom metric for used memory

[ -e /etc/profile.d/ec2.sh ] && source /etc/profile.d/ec2.sh
[ -e /etc/profile.d/mon.sh ] && source /etc/profile.d/mon.sh

instanceid='i-b5e299fa'

memtotal=`/usr/bin/free -m | /bin/grep 'Mem' | /usr/bin/tr -s ' ' | /bin/cut -d ' ' -f 2`
memfree=`/usr/bin/free -m | /bin/grep 'buffers/cache' | /usr/bin/tr -s ' ' | /bin/cut -d ' ' -f 4`

let "memused=100-memfree*100/memtotal"

$(/root/aws-command-line-tools/CloudWatch/bin/mon-put-data --metric-name "UsedMemoryPercent" --namespace "System/Linux" --dimensions "InstanceID=$instanceid" --value "$memused" --unit "Percent" --region "eu-west-1")

