#!/bin/sh -e

cd `dirname $0`

while true ; do
	./w1-ds18b20-influx.sh
	sleep 3
done
