#!/bin/bash -e

ln -s ${ROOTFS_DIR}/lib/systemd/system/graphical.target ${ROOTFS_DIR}/etc/systemd/default.target
ln -fs ${ROOTFS_DIR}/etc/systemd/system/autologin@.service ${ROOTFS_DIR}/etc/systemd/system/getty.target.wants/getty@tty1.service
sed ${ROOTFS_DIR}/etc/lightdm/lightdm.conf -i -e "s/^\(#\|\)autologin-user=.*/autologin-user=pi/"
