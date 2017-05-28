#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 01-07-2014

# A script for remote checking AWS instances

export PATH=$PATH:$AWS_CLOUDWATCH_HOME/bin

CAT_BIN=`which cat`
BASENAME_BIN=`which basename`
CURL_BIN=`which curl`
AWK_BIN=`which awk`
MON_PUT_DATA_BIN=`which mon-put-data`

BASE_NAME=`$BASENAME_BIN "$0"`

INSTANCES_FILE="/root/remote-check.csv"

function mon_put_data() {

	#CloudWatch variables
	metric_name="HttpResponseTime"
	namespace="System/Linux"
	unit="Seconds"

	while read line; do

		instance_domain=`echo $line | cut -d "," -f 1`
                instance_id=`echo $line | cut -d "," -f 2`
		instance_region=`echo $line | cut -d "," -f 3`
		dimensions="InstanceID=$instance_id"

		if [ "$instance_domain" != "" ]; then
			time_total=`$CURL_BIN -sL -w '%{time_total}\\n' "http://$instance_domain/" -o /dev/null`
			`$MON_PUT_DATA_BIN --metric-name $metric_name --namespace $namespace --dimensions $dimensions --value $time_total --unit $unit --region $instance_region`
		else
			echo "Invalid domainname" >&2
			echo "Invalid domainname"
		fi		
	
	done < $INSTANCES_FILE
}

if [ -f $INSTANCES_FILE ]; then
	mon_put_data
else
	echo -e "$INSTANCES_FILE do not exist" >&2
	exit 1
fi
