#!/bin/bash

SCP='/usr/bin/scp'
SSHPASS='/usr/bin/sshpass'
MV='/bin/mv'
DATE=$(date +"%Y%m%d")
MKDIR='/bin/mkdir'
TAR='/bin/tar'
RM='/bin/rm'

function onderwaterhuis {

	ssh_host='213.132.210.44'
	ssh_user='root'
	ssh_pass='tl1oVqng'

	#logs=( '/var/www/vhosts/onderwaterhuis.nl/statistics/logs/error_log' )
	logs=( '/var/www/vhosts/onderwaterhuis.nl/statistics/logs/error_log' '/var/www/vhosts/onderwaterhuis.nl/httpdocs/var/log/exception.log' '/var/www/vhosts/onderwaterhuis.nl/httpdocs/var/log/system.log' '/var/log/messages' '/var/log/mysqld.log' '/var/log/secure' '/var/log/sa/sar*' )
	elements=${#logs[@]}

	destination='/home/hosting/onderwaterhuis'	

	for (( i=0;i<$elements;i++ )); do
		log=${logs[${i}]}

		$( $SSHPASS -p $ssh_pass $SCP $ssh_user'@'$ssh_host':'$log $destination 2> /home/html/scripts/logs-collecting.log )

	done

	$( $MV $destination $destination'_'$DATE )
	$( $MKDIR $destination )
	$( cd '/home/hosting' && $TAR -zcf 'onderwaterhuis_'$DATE'.tar.gz' 'onderwaterhuis_'$DATE )
	$( cd '/home/hosting' && $RM -Rf 'onderwaterhuis_'$DATE )

}

onderwaterhuis

$( echo "log files from onderwaterhuis on $DATE, path: /home/hosting/" | mail -s "check log files" ilche@ecomwise.com )



