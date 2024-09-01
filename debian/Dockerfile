FROM debian:bullseye

RUN sed /etc/apt/sources.list -i -e "s/#deb-src/deb-src/" && \
    apt-get update && apt-get install -y curl gnupg && \
    curl -sS http://raspbian.raspberrypi.org/raspbian.public.key | gpg --dearmor > /etc/apt/trusted.gpg.d/raspberry-pi-debian.gpg && \
    echo "deb http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi" >> /etc/apt/sources.list && \
    echo "deb-src http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi" >> /etc/apt/sources.list && \
    curl -sS http://archive.raspberrypi.org/debian/raspberrypi.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/raspberrypi-archive-stable.gpg && \
    echo "deb http://archive.raspberrypi.org/debian/ bullseye main" > /etc/apt/sources.list.d/raspi.list && \
    apt-get update && apt-get install -y \
    build-essential \
    checkinstall \
    cmake \
    debhelper \
    devscripts \
    dpkg-sig \
    intltool \
    libglib2.0-dev \
    libjpeg-dev \
    libpng-dev \
    libraspberrypi-dev \
    libudev-dev \
    pkgconf \
    raspberrypi-kernel-headers \
    wget

WORKDIR /app
