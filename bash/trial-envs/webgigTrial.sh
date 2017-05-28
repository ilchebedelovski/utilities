#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 19-06-2013

# A script for scheduling environments creation

INPUT=( $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20})
ELEMENTS=${#INPUT[@]}
DATE=$(date +"%y%m%d%k%M")
STARTDATE=$(date +"%Y-%m-%d")

for (( i=0;i<$ELEMENTS;i++ )); do
	VARIABLE=${INPUT[${i}]}
	if [ ${VARIABLE%%__*} = 'mysqlusername' ]; then
                MYSQLUSERNAME=${VARIABLE##*__}
        elif [ ${VARIABLE%%_*} = 'mysqlpassword' ]; then
                MYSQLPASSWORD=${VARIABLE##*_}
        elif [ ${VARIABLE%%__*} = 'mysqlhostname' ]; then
                MYSQLHOSTNAME=${VARIABLE##*__}
        elif [ ${VARIABLE%%__*} = 'mysqldbname' ]; then
                MYSQLDBNAME=${VARIABLE##*__}
        elif [ ${VARIABLE%%__*} = 'basicdbname' ]; then
                BASICDBNAME=${VARIABLE##*__}
        elif [ ${VARIABLE%%__*} = 'srcpath' ]; then
                SRCPATH=${VARIABLE##*__}
        elif [ ${VARIABLE%%__*} = 'dstpath' ]; then
                DSTPATH=${VARIABLE##*__}'-'$DATE
	elif [ ${VARIABLE%%__*} = 'domain' ]; then
                DOMAINNAME=${VARIABLE##*__}
        elif [ ${VARIABLE%%__*} = 'sqlfilename' ]; then
                SQLFILENAME=${VARIABLE##*__}
        elif [ ${VARIABLE%%__*} = 'vhostpath' ]; then
                VHOSTPATH=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'subdomain' ]; then
		SUBDOMAIN=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'mysqltrialdb' ]; then
		MYSQLTRIALDB=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'trialdirectory' ]; then
		TRIALDIRECTORY=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'forinstall' ]; then
		FORINSTALL=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'trialid' ]; then
		TRIALID=${VARIABLE##*__} 
	elif [ ${VARIABLE%%__*} = 'adminpassword' ]; then
		ADMINPASSWORD=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'vhostconf' ]; then
		VCONF=${VARIABLE##*__}
        fi
done

function add {

	if [ -z $TRIALDIRECTORY ]; then

	        $(mkdir -p $DSTPATH)
        	$(chmod 755 -R $DSTPATH)
	        $(cp -af $SRCPATH'/.' $DSTPATH)

	        mydatabase='webshopgigant_trial_'$DATE
        	envurl='http://'$DOMAINNAME'/'
	        localxml=$DSTPATH'/app/etc/local.xml'
		vhostconf=$VHOSTPATH'/'$SUBDOMAIN'.conf'

	        $( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME -Bse "CREATE DATABASE $mydatabase CHARACTER SET utf8 COLLATE utf8_general_ci;" )
        	$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $mydatabase < $SQLFILENAME )
	        $( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $mydatabase -Bse "UPDATE core_config_data SET value='$envurl' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='$envurl' WHERE path='web/secure/base_url';")
		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $mydatabase -Bse "UPDATE admin_user SET password=MD5('$ADMINPASSWORD') WHERE username='admin';")



		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYSQLDBNAME -Bse "UPDATE webshopgigant_trial SET mysql_trial_db='$mydatabase', trial_directory='$DSTPATH' WHERE id='$TRIALID'" ) 
		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYSQLDBNAME -Bse "UPDATE webshopgigant_trial SET start_date='$STARTDATE' WHERE id='$TRIALID'" )
		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYSQLDBNAME -Bse "UPDATE webshopgigant_trial SET to_be_installed='0' WHERE id='$TRIALID'")	
		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYSQLDBNAME -Bse "UPDATE webshopgigant_trial SET to_be_deleted='1' WHERE id='$TRIALID'")	
		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYSQLDBNAME -Bse "UPDATE webshopgigant_trial SET vhostconf='$vhostconf' WHERE id='$TRIALID'")

        	$(sed -i '/connection/,/<\/connection/{s/'$BASICDBNAME'\b/'$mydatabase'/}' $localxml)

                $(touch $vhostconf)
                $(chmod 777 $vhostconf)

                echo -e "\t" >> $vhostconf
                echo "<VirtualHost *:80>" >> $vhostconf
                echo -e "\tDocumentRoot "$DSTPATH >> $vhostconf
                echo -e "\tServerName "$DOMAINNAME >> $vhostconf
                echo -e "\t<Directory '/home/html'>" >> $vhostconf
                echo -e         "\t\tAllowOverride All"  >> $vhostconf
                echo -e         "\t\tOptions None" >> $vhostconf
                echo -e         "\t\tOrder allow,deny" >> $vhostconf
                echo -e         "\t\tAllow from all" >> $vhostconf
                echo -e "\t</Directory>" >> $vhostconf
                echo "</VirtualHost>" >> $vhostconf
                echo -e "\t" >> $vhostconf


		$(apachectl -k graceful)	

		echo $envurl

	fi

}

function remove {

	if [ -d $TRIALDIRECTORY ]; then
            	$(rm -Rvf $TRIALDIRECTORY)
        	$( mysqladmin -u $MYSQLUSERNAME -p$MYSQLPASSWORD -f drop $MYSQLTRIALDB )
		$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYSQLDBNAME -Bse "UPDATE webshopgigant_trial SET	to_be_deleted='0' WHERE id='$TRIALID'" )
		$(rm -r $VCONF)
	fi

}

if [ $FORINSTALL = '1' ]; then
	add
else
	remove
fi
