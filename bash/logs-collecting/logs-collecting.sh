#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 17-10-2012

# A script for collecting logs from remote machine
# Please change the contents of the variables that we are using for connecting to the remote server

SCP='/usr/bin/scp'
SSHPASS='/usr/bin/sshpass'
MV='/bin/mv'
DATE=$(date +"%Y%m%d")
MKDIR='/bin/mkdir'
TAR='/bin/tar'
RM='/bin/rm'

function logging {

	ssh_host='host'
	ssh_user='username'
	ssh_pass='password'

        domainname='domainname'

	logs=( "/var/logs/error_log" "/var/www/vhosts/${domainname}/httpdocs/var/log/exception.log" "/var/www/vhosts/${domainname}/httpdocs/var/log/system.log" "/var/log/messages" "/var/log/mysqld.log" "/var/log/secure" "/var/log/sa/sar*" )
	elements=${#logs[@]}

	destination="/home/hosting/${domainname}"

	for (( i=0;i<$elements;i++ )); do
		log=${logs[${i}]}

		$( $SSHPASS -p $ssh_pass $SCP $ssh_user'@'$ssh_host':'$log $destination 2> /home/html/scripts/logs-collecting.log )

	done

	$( $MV $destination $destination'_'$DATE )
	$( $MKDIR $destination )
	$( cd '/home/hosting' && $TAR -zcf "${domainname}_$DATE.tar.gz" "${domainname}_${DATE}" )
	$( cd '/home/hosting' && $RM -Rf 'domainname_'$DATE )

}

logging

$( echo "Log files from $domainname on $DATE, path: /home/hosting/" | mail -s "check log files" "info@$domainname" )



