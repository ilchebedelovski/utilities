#!/bin/bash

# Composer: Ilche Bedelovski
# Version: 1.1
# Last update: 26-11-2014

# exporting AWS global variables because exporting from .bashrc is not available in cron
export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/usr/sbin

EC2_DESCRIBE_REGIONS_BIN=`which ec2-describe-regions`
EC2_DESCRIBE_INSTANCES_BIN=`which ec2-describe-instances`
EC2_DESCRIBE_TAGS_BIN=`which ec2-describe-tags`

regions=`$EC2_DESCRIBE_REGIONS_BIN | awk '{print $2}'`
regionsarray=($regions)

instances_file='/root/remote-instances.csv'
instances_check='/root/remote-check.csv'

if [ -f $instances_file ]; then
	rm $instances_file
fi

for (( i=0; i<${#regionsarray[@]}; ++i )); do
	instance_region=${regionsarray[$i]}
	instances=`$EC2_DESCRIBE_TAGS_BIN --region $instance_region --filter "resource-type=instance" --filter "key=project" --filter "value=Mconnect" | awk '{print $3}'`
	instancesarray=($instances)
	for (( j=0; j<${#instancesarray[@]}; ++j )); do
		instance_id=${instancesarray[$j]}
		instance_domain=`$EC2_DESCRIBE_TAGS_BIN --region $instance_region --filter "resource-type=instance" --filter "resource-id=$instance_id" --filter "key=Name" | awk '{print $6}'`
		echo -e "$instance_domain,$instance_id,$instance_region" >> $instances_file
	done
	
done

LSOF_BIN=`which lsof`

lsof_check() {
	lines=`$LSOF_BIN | grep $instances_check | wc -l`
        if [ "$lines" -eq "0" ]; then
        	return 0
        else
		return 1
	fi
}

if [ -f $instances_check ]; then
	while true; do
		if lsof_check; then
			rm $instances_check
                        mv $instances_file $instances_check
			exit 1
		fi
		sleep 5
	done
else
        mv $instances_file $instances_check
fi

