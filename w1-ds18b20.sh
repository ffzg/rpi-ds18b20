#!/bin/sh -e

ls /sys/bus/w1/devices/w1_bus_master*/*-*/w1_slave | while read path ; do
	temp=$( cat $path | grep t= | cut -d= -f2  | awk '{ printf "%.3f\n", $1 / 1000 }' )
	if [ $temp != 85 ] ; then # 85 is error
		id=$( echo $path | cut -d/ -f 7 )
		echo -n "$id "
		echo $temp | tee /dev/shm/ds18b20.$id
	fi
done
