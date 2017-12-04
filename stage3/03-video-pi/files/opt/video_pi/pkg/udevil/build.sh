#!/bin/bash -e

set -x

../build-helper.sh udevil

mv udevil-0.4.4 udevil-0.4.4.bak
wget https://github.com/IgnorantGuru/udevil/tarball/next
tar xzf next
mv IgnorantGuru-udevil-* udevil-0.4.4
cd udevil-0.4.4
ln -s distros/debian
dpkg-buildpackage -us -uc -nc
ls -l ../*.deb
