#!/bin/sh -e

influx_url="http://10.60.0.92:8086/write?consistency=any&db=ffzg"
influx=/dev/shm/temp.influx

:> $influx

ls /sys/bus/w1/devices/w1_bus_master*/*-*/temperature | while read path ; do
	temp=$( cat $path | awk '{ printf "%.3f\n", $1 / 1000 }' )
	id=$( echo $path | cut -d/ -f 7 )
	echo "ac_temp,dc=a125,sensor=$id temperature=$temp" >> $influx
	echo $temp > /dev/shm/ds18b20.$id
done

#curl --silent -XPOST "$influx_url" --data-binary "@$influx"
curl -XPOST $influx_url --data-binary "@$influx"
