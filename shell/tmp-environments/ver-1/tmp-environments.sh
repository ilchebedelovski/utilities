#!/bin/bash

mysqluser="root"
mysqlpass="8*Aj(Dd)"
mysqlhost="localhost"

SRC_PATH_1702="/home/html/development/clean-mage-1702"
SRC_PATH_1800="/home/html/development/clean-mage-1800"

DST_1702_1="/home/html/development/tmp1-mage-1702"
DST_1800_1="/home/html/development/tmp1-mage-1800"
DST_1702_2="/home/html/development/tmp2-mage-1702"
DST_1800_2="/home/html/development/tmp2-mage-1800"

SQL_PATH_1702="/home/html/development/clean-mage-1702/development_tmp1_mage_1702.sql"
SQL_PATH_1800="/home/html/development/clean-mage-1800/development_tmp1_mage_1800.sql"

SQL_DB_1="development_tmp1_mage_1702"
SQL_DB_2="development_tmp1_mage_1800"
SQL_DB_3="development_tmp2_mage_1702"
SQL_DB_4="development_tmp2_mage_1800"

TMP_FILES="/home/html/development/tmp-files"

if [ -d $SRC_PATH_1702 ]; then

	$(rm -Rf $DST_1702_1/*)
	$(cp -a $SRC_PATH_1702/* $DST_1702_1)
        $(cp -a $SRC_PATH_1702/.htaccess $DST_1702_1)
	$(cp -a $TMP_FILES"/tmp1-1702/local.xml" $DST_1702_1"/app/etc/")	

	$(rm -Rf $DST_1702_2/*)
	$(cp -a $SRC_PATH_1702/* $DST_1702_2)
	$(cp -a $SRC_PATH_1702/.htaccess* $DST_1702_2)
	$(cp -a $TMP_FILES"/tmp2-1702/local.xml" $DST_1702_2"/app/etc/")
	
	$(chmod 777 -R $DST_1702_1)
	$(chmod 777 -R $DST_1702_2)

	if [ -f $SQL_PATH_1702 ]; then
		$(/usr/bin/mysqladmin -u $mysqluser -p$mysqlpass -h $mysqlhost -f drop $SQL_DB_1)
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost -Bse "CREATE DATABASE $SQL_DB_1 CHARACTER SET utf8 COLLATE utf8_general_ci;" )
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_1 < $SQL_PATH_1702)
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_1 -Bse "UPDATE core_config_data SET value='http://www.tmp1-mage-1702.ecomwisedev.com/' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='http://www.tmp1-mage-1702.ecomwisedev.com/' WHERE path='web/secure/base_url';")
		
		$(/usr/bin/mysqladmin -u $mysqluser -p$mysqlpass -h $mysqlhost -f drop $SQL_DB_3)
                $(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost -Bse "CREATE DATABASE $SQL_DB_3 CHARACTER SET utf8 COLLATE utf8_general_ci;" )
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_3 < $SQL_PATH_1702 )
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_3 -Bse "UPDATE core_config_data SET value='http://www.tmp2-mage-1702.ecomwisedev.com/' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='http://www.tmp2-mage-1702.ecomwisedev.com/' WHERE path='web/secure/base_url';")
	else 
		echo "file $SQL_PATH_1702 does not exist"
	fi

	echo "operation successfull for 1702"
else
 
	echo "$SRC_PATH_1702 doesn't exist"
fi

if [ -d $SRC_PATH_1800 ]; then
	
	$(rm -Rf $DST_1800_1/*)
	$(cp -a $SRC_PATH_1800/* $DST_1800_1)
	$(cp -a $SRC_PATH_1800/.htaccess $DST_1800_1)
	$(cp -a $TMP_FILES"/tmp1-1800/local.xml" $DST_1800_1"/app/etc/")
	
	$(rm -Rf $DST_1800_2/*)
	$(cp -a $SRC_PATH_1800/* $DST_1800_2)
	$(cp -a $SRC_PATH_1800/.htaccess $DST_1800_2)
	$(cp -a $TMP_FILES"/tmp2-1800/local.xml" $DST_1800_2"/app/etc/")

	$(chmod 777 -R $DST_1800_1)
	$(chmod 777 -R $DST_1800_2)

	if [ -f $SQL_PATH_1800 ]; then
                $(/usr/bin/mysqladmin -u $mysqluser -p$mysqlpass -h $mysqlhost -f drop $SQL_DB_2)
                $(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost -Bse "CREATE DATABASE $SQL_DB_2 CHARACTER SET utf8 COLLATE utf8_general_ci;" )
                $(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_2 < $SQL_PATH_1800 )
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_2 -Bse "UPDATE core_config_data SET value='http://www.tmp1-mage-1800.ecomwisedev.com/' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='http://www.tmp1-mage-1800.ecomwisedev.com/' WHERE path='web/secure/base_url';")

                $(/usr/bin/mysqladmin -u $mysqluser -p$mysqlpass -h $mysqlhost -f drop $SQL_DB_4)
                $(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost -Bse "CREATE DATABASE $SQL_DB_4 CHARACTER SET utf8 COLLATE utf8_general_ci;" )
                $(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_4 < $SQL_PATH_1800 )
		$(/usr/bin/mysql -u $mysqluser -p$mysqlpass -h $mysqlhost $SQL_DB_4 -Bse "UPDATE core_config_data SET value='http://www.tmp2-mage-1800.ecomwisedev.com/' WHERE path='web/unsecure/base_url'; UPDATE core_config_data SET value='http://www.tmp2-mage-1800.ecomwisedev.com/' WHERE path='web/secure/base_url';")
        else
                echo "file $SQL_PATH_1702 does not exist"
        fi

	echo "operation successfull for 1800"
else 
	echo "$SRC_PATH_1800 doesn't exist"
fi

/usr/sbin/apachectl -k graceful
