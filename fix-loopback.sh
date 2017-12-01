#!/bin/bash

# Loopback crash workaround
# https://github.com/RPi-Distro/pi-gen/issues/104
losetup -D
for i in $(seq 0 5); do
    dd if=/dev/zero of=virtualfs$i bs=1024 count=30720
    losetup /dev/loop$i virtualfs$i
    losetup -d /dev/loop$i
    rm virtualfs$i
done
