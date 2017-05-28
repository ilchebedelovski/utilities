#!/bin/bash

INPUT=( $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} )
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
        fi
done

#echo -e "$MYSQLUSERNAME  $MYSQLPASSWORD $MYSQLHOSTNAME $MYSQLDBNAME $BASICDBNAME $SRCPATH $DSTPATH $DOMAINNAME $SQLFILENAME $VHOSTPATH $MYSQLTRIALDB $TRIALDIRECTORY $FORINSTALL $STARTDATE $TRIALID $ADMINPASSWORD"

#$( mysql -u $MYSQLUSERNAME -p$MYSQLPASSWORD -h $MYSQLHOSTNAME clients_webgigtrial -Bse "UPDATE admin_user SET password=MD5('$ADMINPASSWORD') WHERE username='admin';")

		VHOSTCONF=$VHOSTPATH'/'$SUBDOMAIN'.conf'

		$(touch $VHOSTCONF)
		$(chmod 777 $VHOSTCONF)

		echo -e "\t" >> $VHOSTCONF
                echo "<VirtualHost *:80>" >> $VHOSTCONF
                echo -e "\tDocumentRoot "$DSTPATH >> $VHOSTCONF
                echo -e "\tServerName "$DOMAINNAME >> $VHOSTCONF
                echo -e "\t<Directory '/home/html'>" >> $VHOSTCONF
                echo -e         "\t\tAllowOverride All"  >> $VHOSTCONF
                echo -e         "\t\tOptions None" >> $VHOSTCONF
                echo -e         "\t\tOrder allow,deny" >> $VHOSTCONF
                echo -e         "\t\tAllow from all" >> $VHOSTCONF
                echo -e "\t</Directory>" >> $VHOSTCONF
                echo "</VirtualHost>" >> $VHOSTCONF
                echo -e "\t" >> $VHOSTCONF
