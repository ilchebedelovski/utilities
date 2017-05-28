#!/bin/bash 

# Composer: Ilche Bedelovski
# Version: 1.1
# Last update: 27-04-2015

# exporting AWS global variables because exporting from .bashrc is not available in cron
set -ue
set -o pipefail

export PATH=$PATH:$EC2_HOME/bin
export PATH=$PATH:/usr/sbin

EC2_DESCRIBE_INSTANCES=`which ec2-describe-instances`
EC2_CREATE_SNAPSHOT=`which ec2-create-snapshot`
EC2_CREATE_TAGS=`which ec2-create-tags`
EC2_DESCRIBE_SNAPSHOTS=`which ec2-describe-snapshots`
EC2_DELETE_SNAPSHOT=`which ec2-delete-snapshot`

# Logging options
logfile="/var/log/ebs-snapshot.log"
logfile_max_lines="5000"

# Retention date 
retention_days="7"
retention_date_in_seconds=`date +%s --date "$retention_days days ago"`

log_setup() {
	# Checking if the log file exists
	( [ -e "$logfile" ] || touch "$logfile" ) && [ ! -w "$logfile" ] && echo "ERROR: Cannot write to $logfile. Check permissions or sudo access." && exit 1

	tmplog=`tail -n $logfile_max_lines $logfile 2>/dev/null` && echo "${tmplog}" > $logfile
	exec > >(tee -a	$logfile)
	exec 2>&1
}

# Function: Log an event.
log() {
    echo "[$(date +"%Y-%m-%d"+"%T")]: $*"
}

snapshot_volume() {
	date=`date +"%Y%m%d"`
	instance_id='i-a536f141' #jira live
	#instance_id='i-3d5e42da' #jira demo
	region='eu-west-1'

	echo -e "Looking for volumes in $instance_id..."
	volumes=`$EC2_DESCRIBE_INSTANCES $instance_id --region $region | grep "BLOCKDEVICE" | awk '{print $3}'`
	volumesarray=($volumes)

	for (( i=0; i<${#volumesarray[@]}; i++ )); do
		volume_id=${volumesarray[$i]}
		description="jira-snapshot-[$volume_id]-$date"
		echo -e "Starting snapshot creation for $volume_id..."
		snapshot_id=`$EC2_CREATE_SNAPSHOT $volume_id --region $region --description $description | awk '{print $2}'`
		log "New snapshot is $snapshot_id"

		$EC2_CREATE_TAGS $snapshot_id --tag "CreatedBy=AutomatedJiraBackup" --region $region
	done
}

snapshot_cleanup() {
	instance_id='i-a536f141' #jira live
        #instance_id='i-3d5e42da' #jira demo
        region='eu-west-1'

        echo -e "Looking for old snapshots for $instance_id..."
        volumes=`$EC2_DESCRIBE_INSTANCES $instance_id --region $region | grep "BLOCKDEVICE" | awk '{print $3}'`
        volumesarray=($volumes)

        for (( i=0; i<${#volumesarray[@]}; i++ )); do
                volume_id=${volumesarray[$i]}
		
		snapshot_list=`$EC2_DESCRIBE_SNAPSHOTS --region $region --filter "volume-id=$volume_id" --filter "tag:CreatedBy=AutomatedJiraBackup" --hide-tags | awk '{print $2}'`
		snapshot_id=${snapshot_list[0]}
		snapshot_date=`$EC2_DESCRIBE_SNAPSHOTS $snapshot_id --region $region --hide-tags | awk '{print $5}' | awk -F "T" '{printf "%s\n", $1}'`
		snapshot_date_in_seconds=$(date "--date=$snapshot_date" +%s)
		snapshot_description=`$EC2_DESCRIBE_SNAPSHOTS $snapshot_id --region $region --hide-tags | awk '{print $9}'`
		
		if (( $snapshot_date_in_seconds <= $retention_date_in_seconds )); then
			log "DELETING snapshot $snapshot_id . Description: $snapshot_description ..."
			$EC2_DELETE_SNAPSHOT $snapshot_id --region $region
		fi
        done
}

log_setup
snapshot_volume
snapshot_cleanup
