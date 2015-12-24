#!/bin/bash

key='/root/.ssh/Ecomwise-1.pem'
ssh='/usr/bin/ssh'
bash='bin/bash'

remotePath='/opt/mconnect/var/log/navisionXMLRequests/'
localPath='/mnt/ebs/public/mconnect/var/log/navisionXMLRequests/'

user='root'
#hosts=( '54.219.134.7' )
hosts=( '54.219.134.7' 'ec2-54-193-28-4.us-west-1.compute.amazonaws.com' '54.193.27.87' '54.215.240.213' '54.215.212.108' )
elements=${#hosts[@]}

for (( i=0;i<$elements;i++ )); do

	host=${hosts[${i}]}	
	hostname=$( ssh -i $key $user'@'$host bash /opt/mconnect/var/log/hostname.sh )
	echo $hostname
	$( scp -i $key -r $user'@'$host':'$remotePath'*' $localPath''$hostname 2> /mnt/ebs/public/mconnect/var/log/navision-xml-errors.txt )

done
