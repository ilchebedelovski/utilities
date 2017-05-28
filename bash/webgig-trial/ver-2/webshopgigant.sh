#!/bin/bash


INPUT=( $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} )
ELEMENTS=${#INPUT[@]}

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
	elif [ ${VARIABLE%%__*} = 'localxmlpath' ]; then
		LOCALXMLPATH=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'pwd' ]; then
		PWDPATH=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'environmentname' ]; then
		ENVIRONMENT=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'srcpath' ]; then
		SRCPATH=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'dstpath' ]; then
		DSTPATH=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'domainname' ]; then
		DOMAINNAME=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'sqlfilename' ]; then
		SQLFILENAME=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'htaccess' ]; then
		HTACCESS=${VARIABLE##*__}
	elif [ ${VARIABLE%%__*} = 'vhostpath' ]; then
                VHOSTPATH=${VARIABLE##*__}
	fi
done

echo "start copy from shell..."

if [ ! -d $DSTPATH ]; then
        $(mkdir -p $DSTPATH)
        $(chmod 755 -R $DSTPATH)
        $(cp -af $SRCPATH'/.' $DSTPATH)
fi

	DATE=$(date +"%y%m%d%k%M")
        MYDATABASE='webshopgigant_'$MYSQLDBNAME'_'$DATE
        ENVURL='http://'$DOMAINNAME'/'
	FILE=$DSTPATH'/app/etc/local.xml'

echo "start creating db from shell..."

        $( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME -Bse "CREATE DATABASE $MYDATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;" )
        $( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYDATABASE < $SQLFILENAME )
        $( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME $MYDATABASE -Bse "UPDATE core_config_data SET value='$ENVURL' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='$ENVURL' WHERE path='web/secure/base_url';")

	$(sed -i '/connection/,/<\/connection/{s/'$BASICDBNAME'\b/'$MYDATABASE'/}' $FILE)

echo "start creating virtual host from shell..."	

	echo -e "\t" >> $VHOSTPATH
        echo "<VirtualHost *:80>" >> $VHOSTPATH
        echo -e "\tDocumentRoot "$DSTPATH >> $VHOSTPATH
        echo -e "\tServerName "$DOMAINNAME >> $VHOSTPATH
        echo -e "\t<Directory '/home/html'>" >> $VHOSTPATH
        echo -e         "\t\tAllowOverride All"  >> $VHOSTPATH
        echo -e         "\t\tOptions None" >> $VHOSTPATH
        echo -e         "\t\tOrder allow,deny" >> $VHOSTPATH
        echo -e         "\t\tAllow from all" >> $VHOSTPATH
        echo -e "\t</Directory>" >> $VHOSTPATH
        echo "</VirtualHost>" >> $VHOSTPATH
        echo -e "\t" >> $VHOSTPATH

echo $ENVURL


