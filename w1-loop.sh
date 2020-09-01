#!/bin/sh

cd `dirname $0`

export DC

while true ; do
	./w1-ds18b20-influx.sh
	sleep 3
done
