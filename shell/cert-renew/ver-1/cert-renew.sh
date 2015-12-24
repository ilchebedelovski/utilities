#!/bin/bash

OPENSSL=`which openssl`
HOSTNAME=`/bin/hostname`

files_name=`echo $HOSTNAME | tr . _`
key_name="www_$files_name.key"
csr_name="www_$files_name.csr"

ssl_dir="/etc/pki/tls/certs"
ssl_dir_new="/etc/pki/tls/certs/certs-new"
ssl_dir_old="/etc/pki/tls/certs/certs-past"

csr_country="NL"
csr_state="Utrecht"
csr_locality="Utrecht"
csr_organization="Ecomwise B.V."
csr_ounit="ICT"
csr_commonname="www.$HOSTNAME"

mkdir $ssl_dir_new
mkdir $ssl_dir_old

`$OPENSSL genrsa -out $ssl_dir_new"/"$key_name 2048`

if [ -f $ssl_dir_new"/"$key_name ]; then
	`$OPENSSL req -new -key $ssl_dir_new"/"$key_name -out $ssl_dir_new"/"$csr_name -subj "/C=$csr_country/ST=$csr_state/L=$csr_locality/O=$csr_organization/OU=$csr_ounit/CN=$csr_commonname"`
	cat $ssl_dir_new"/"$csr_name
else
	echo "Key file do not exists"
fi
