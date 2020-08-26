#!/bin/sh -e

ls /sys/bus/w1/devices/w1_bus_master*/*-*/w1_slave | while read path ; do
	temp=$( cat $path | grep t= | cut -d= -f2 )
	if [ $temp != 85000 ] ; then # 85 is error
		temp=$( echo $temp | awk '{ printf "%.3f\n", $1 / 1000 }' )
		id=$( echo $path | cut -d/ -f 7 )
		name=$( grep "^$id" id2name.txt | cut -d' ' -f2 )
		echo "$id $name $temp"
	fi
done
