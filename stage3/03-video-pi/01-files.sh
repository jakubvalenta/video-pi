#!/bin/bash -e

install -v -D -m 644 files/opt/video_pi/video_pi_wallpaper.png ${ROOTFS_DIR}/opt/video_pi/video_pi_wallpaper.png

mkdir -p ${ROOTFS_DIR}/home/pi/bin
chown 1000:1000 ${ROOTFS_DIR}/home/pi/bin
install -v -m 755 -o 1000 -g 1000 files/home/pi/bin/video_pi_devmon ${ROOTFS_DIR}/home/pi/bin/video_pi_devmon
install -v -m 755 -o 1000 -g 1000 files/home/pi/bin/video_pi_play ${ROOTFS_DIR}/home/pi/bin/video_pi_play

mkdir -p ${ROOTFS_DIR}/home/pi/.config/lxsession/LXDE
chown 1000:1000 ${ROOTFS_DIR}/home/pi/.config/lxsession
chown 1000:1000 ${ROOTFS_DIR}/home/pi/.config/lxsession/LXDE
install -v -m 644 -o 1000 -g 1000 files/home/pi/.config/lxsession/LXDE/autostart ${ROOTFS_DIR}/home/pi/.config/lxsession/LXDE/autostart

mkdir -p ${ROOTFS_DIR}/home/pi/.config/mpv
chown 1000:1000 ${ROOTFS_DIR}/home/pi/.config
chown 1000:1000 ${ROOTFS_DIR}/home/pi/.config/mpv
install -v -m 644 -o 1000 -g 1000 files/home/pi/.config/mpv/mpv.conf ${ROOTFS_DIR}/home/pi/.config/mpv/mpv.conf

mkdir -p ${ROOTFS_DIR}/home/pi/.config/pcmanfm
chown 1000:1000 ${ROOTFS_DIR}/home/pi/.config/pcmanfm
install -v -m 644 -o 1000 -g 1000 files/home/pi/.config/pcmanfm/LXDE/desktop-items-0.conf ${ROOTFS_DIR}/home/pi/.config/pcmanfm/LXDE/desktop-items-0.conf
install -v -m 644 -o 1000 -g 1000 files/home/pi/.config/pcmanfm/LXDE/pcmanfm.conf ${ROOTFS_DIR}/home/pi/.config/pcmanfm/LXDE/pcmanfm.conf

install -v -m 644 -o 1000 -g 1000 files/home/pi/Desktop/raspi-config.desktop ${ROOTFS_DIR}/home/pi/Desktop/raspi-config.desktop
