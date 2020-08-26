#!/bin/sh -e

influx_url="http://10.60.0.92:8086/write?consistency=any&db=ffzg"
influx=/dev/shm/temp.influx

:> $influx

ls /sys/bus/w1/devices/w1_bus_master*/*-*/w1_slave | while read path ; do
	temp=$( cat $path | grep t= | cut -d= -f2 )
	if [ $temp -ne 85000 ] ; then # 85 is error
		temp=$( echo $temp | awk '{ printf "%.3f\n", $1 / 1000 }' )
		id=$( echo $path | cut -d/ -f 7 )
		name=$( grep "^$id" id2name.txt | cut -d' ' -f2 )
		echo "ac_temp,dc=a125,sensor=$id,name=$name temperature=$temp" >> $influx
		echo $temp > /dev/shm/ds18b20.$id
		echo $temp > /dev/shm/ds18b20.name.$name
	fi
done

#curl --silent -XPOST "$influx_url" --data-binary "@$influx"
curl -XPOST $influx_url --data-binary "@$influx"
