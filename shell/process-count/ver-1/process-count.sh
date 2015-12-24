#!/bin/bash

pids=$(echo `ps aux | grep php | awk '{print $2}'`)
pidsArray=($pids)

echo ${#pidsArray[@]}
if [ ${#pidsArray[@]} -gt 1  ]; then
	for (( i=0; i<${#pidsArray[@]}; ++i )); do
		pidetime=$(echo `ps -eo pid,etime | grep $line | awk '{print $2}' | cut -d "-" -f 1`)
		if [ "$pidetime" -gt "3" ]; then
			echo $line
		fi
		echo "proces $i: ${pidsArray[$i]}"
	done
fi
