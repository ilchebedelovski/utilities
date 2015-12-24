#!/bin/bash

ENVIRONMENT=$1
URL='www.'$ENVIRONMENT'.experiusdevelopment.com'
PUBLIC_PATH='/home/html'
CLIENTS_CONF='/etc/httpd/conf.d/clients.conf'
DEVELOPMENT_CONF='/etc/httpd/conf.d/development.conf'
EXTENSIONS_CONF='/etc/httpd/conf.d/extensions.conf'
PWD=$(pwd)

if [[ ! -z $ENVIRONMENT ]]; then
	if [[ $PWD =~ 'clients' ]]; then
		echo -e "\t" >> $CLIENTS_CONF
                echo "<VirtualHost *:80>" >> $CLIENTS_CONF
                echo -e "\tDocumentRoot "$PWD >> $CLIENTS_CONF
                echo -e "\tServerName www."$ENVIRONMENT".experiusdevelopment.com" >> $CLIENTS_CONF
                echo -e "\t<Directory '$PUBLIC_PATH'>" >> $CLIENTS_CONF
                echo -e         "\tAllowOverride All"  >> $CLIENTS_CONF
                echo -e         "\tOptions None" >> $CLIENTS_CONF
                echo -e         "\tOrder allow,deny" >> $CLIENTS_CONF
                echo -e         "\tAllow from all" >> $CLIENTS_CONF
                echo -e "\t</Directory>" >> $CLIENTS_CONF
                echo "</VirtualHost>" >> $CLIENTS_CONF
                echo -e "\t" >> $CLIENTS_CONF
	elif [[ $PWD =~ 'development' ]]; then
                echo -e "\t" >> $DEVELOPMENT_CONF
                echo "<VirtualHost *:80>" >> $DEVELOPMENT_CONF
                echo -e "\tDocumentRoot "$PWD >> $DEVELOPMENT_CONF
                echo -e "\tServerName www."$ENVIRONMENT".experiusdevelopment.com" >> $DEVELOPMENT_CONF
                echo -e "\t<Directory '$PUBLIC_PATH'>" >> $DEVELOPMENT_CONF
                echo -e         "\tAllowOverride All"  >> $DEVELOPMENT_CONF
                echo -e         "\tOptions None" >> $DEVELOPMENT_CONF
                echo -e         "\tOrder allow,deny" >> $DEVELOPMENT_CONF
                echo -e         "\tAllow from all" >> $DEVELOPMENT_CONF
                echo -e "\t</Directory>" >> $DEVELOPMENT_CONF
                echo "</VirtualHost>" >> $DEVELOPMENT_CONF
                echo -e "\t" >> $DEVELOPMENT_CONF
	elif [[ $PWD =~ 'extensions' ]]; then
                echo -e "\t" >> $EXTENSIONS_CONF
                echo "<VirtualHost *:80>" >> $EXTENSIONS_CONF
                echo -e "\tDocumentRoot "$PWD >> $EXTENSIONS_CONF
                echo -e "\tServerName www."$ENVIRONMENT".experiusdevelopment.com" >> $EXTENSIONS_CONF
                echo -e "\t<Directory '$PUBLIC_PATH'>" >> $EXTENSIONS_CONF
                echo -e         "\tAllowOverride All"  >> $EXTENSIONS_CONF
                echo -e         "\tOptions None" >> $EXTENSIONS_CONF
                echo -e         "\tOrder allow,deny" >> $EXTENSIONS_CONF
                echo -e         "\tAllow from all" >> $EXTENSIONS_CONF
                echo -e "\t</Directory>" >> $EXTENSIONS_CONF
                echo "</VirtualHost>" >> $EXTENSIONS_CONF
                echo -e "\t" >> $EXTENSIONS_CONF
        else
		echo "change your directory"
	fi
else
	echo "empty environment name"
fi

echo "restart apache..."
$(service httpd restart)

echo "Domain name: www.$ENVIRONMENT.experiusdevelopment.com"
