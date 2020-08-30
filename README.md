# DS18B20 temperature sensors on Raspberry Pi to monitor air condition

## configure kernel module

There are two ways to configure onewire kernel module, one is to use
`/boot/config.txt` and add following line:

```
# IO1 on board
dtoverlay=w1-gpio,gpiopin=17
```

Another way to to use `configfs` and load device tree overlay in
runtime:

```
pi@pihdmi:~/rpi-ds18b20 $ ./overlay-load.sh ./w1-2.dts
```

If you are loading device tree on runtime, you will have to add it
to startup script like `/etc/rc.local`. This might allow you to have
multiple onewire buses on single machine which will be enumerated
in correct order (otherwise, there are ordered by number of gpio pin,
which might not be something which suits your configuration).

## add mapping between sensor id and name

Run `w1-ds18b20.sh` to figure out sensor id:

```
pi@pihdmi:~/rpi-ds18b20 $ ./w1-ds18b20.sh
28-03150505eeff  33.000
```

Now add mapping between sensor id and name into `id2name.txt`

```
pi@pihdmi:~/rpi-ds18b20 $ grep 28-03150505eeff id2name.txt
28-03150505eeff pihdmi
```

Now when you re-run script you will see name displayed:

```
pi@pihdmi:~/rpi-ds18b20 $ ./w1-ds18b20.sh
28-03150505eeff pihdmi 33.437
```

## add systemd service to start automatically

Scripts are configured to work for our setup, to make it work in
your environment you will need to edit IP address of influxdb server
which is `10.60.0.92` in our examples in both `rpi-ds18b20.service`
and `w1-ds18b20-influx.sh`


```
pi@pihdmi:~/rpi-ds18b20 $ sudo cp rpi-ds18b20.service /etc/systemd/system
pi@pihdmi:~/rpi-ds18b20 $ sudo systemctl enable rpi-ds18b20.service
pi@pihdmi:~/rpi-ds18b20 $ sudo systemctl start rpi-ds18b20.service

```
