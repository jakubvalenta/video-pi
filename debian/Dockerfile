# https://krzysztofzuraw.com/blog/2017/building-python-packages-for-debian.html
FROM debian:buster

RUN apt-get update && apt-get install --yes \
    build-essential \
    debhelper \
    devscripts \
    dpkg-sig \
    sudo \
    wget

ADD ./debian/control /app/debian/control
RUN mk-build-deps --install /app/debian/control --tool "apt-get --allow-downgrades --yes"

RUN useradd -m -G sudo docker && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /app
