#!/bin/bash -e

set -x

sudo apt-get install git devscripts equivs
cd $(mktemp -d)
git clone http://lab.saloun.cz/jakub/mpv-build.git
cd mpv-build
echo "--enable-mmal" >> ffmpeg_options
./use-mpv-master
./use-ffmpeg-release
./update
rm -f mpv-build-deps_*_*.deb
mk-build-deps -s sudo -i
dpkg-buildpackage -uc -us -b -j4
ls -l ../*.deb
