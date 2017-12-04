#!/bin/bash -e

if [[ -z $1 ]]; then
    echo "Usage: build-generic.sh <package name>"
    exit 1
fi

tmp_dir=$(mktemp -d --suffix "-video-pi")
mkdir -p $tmp_dir/$1
cd $tmp_dir/$1
sudo sed /etc/apt/sources.list -i -e "s/#deb-src/deb-src/"
sudo apt-get update
sudo apt-get build-dep $1
apt-get source $1
