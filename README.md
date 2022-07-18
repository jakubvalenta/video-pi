# Video Pi

_Video player for artists by artists_

Video Pi is a simple video player specifically designed for art
installations. It is a software package for the Raspberry Pi mini computer.

[https://videopi.saloun.cz](https://videopi.saloun.cz)

## Features

- supports a __wide range of video formats__
- plays all video files from a __USB stick__ in a __loop__
- __turns on automatically__ when connected to power
- __HDMI and S-Video__ output

## Supported hardware

Supported and tested:

- Raspberry Pi 4
- Raspberry Pi 3 Model B

Supported but not tested:

- Raspberry Pi 3 Model B+
- Raspberry Pi 2 Model B

Not supported:

- Raspberry Pi 1

## Installation

1. Install [Raspberry Pi
   OS](https://www.raspberrypi.org/downloads/raspberry-pi-os/) on your Raspberry
   Pi. Follow the [installation
   guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

2. Download the Video Pi package and its dependencies and transfer them to the
   Raspberry Pi:

    [video-pi](https://github.com/jakubvalenta/video-pi/releases/download/v1.2.1/video-pi_1.2.1-1_all.deb)

    [omxiv](https://github.com/jakubvalenta/video-pi/releases/download/v1.0.0/omxiv_20200913-1_armhf.deb)

    [udevil-0.4.5](https://github.com/jakubvalenta/video-pi/releases/download/v1.2.1/udevil_0.4.5-1_armhf.deb)

3. On the Raspberry Pi, install the packages:

    ``` shell
    sudo apt install ./omxiv_*.deb
    sudo apt install ./udevil_*.deb
    sudo apt install ./video-pi_*.deb
    ```

    Be aware that the `video-pi` package installs several files in the home
    directory. If these files exist, they will be overwritten:

    ``` shell
    ~/.config/autostart/video-pi-devmon.desktop
    ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
    ~/.config/pcmanfm/LXDE-pi/pcmanfm.conf
    ~/Desktop/raspi-config.desktop
    ```

## User guide

### Starting Video Pi

1. Make sure the **HDMI or S-Video cable** is connected _before_ you power on
   the device.
2. Plug in the power source.

When Video Pi finishes startup, it will show a desktop with dark background and
the red Video Pi logo.

### Changing video output resolution

1. Connect a USB mouse and keyboard.
3. Click the **configuration icon** in the top left corner of the desktop. Use
   the keyboard to navigate the interface. Screen resolution settings are under
   _Advanced_.

### Video playback

To start playing videos, **connect a USB stick** with the video files. Video Pi
will play all files in **alphabetical order**. When it finishes the last file,
it will start again with the first file without any break.

When a USB stick is connected before the device starts, Video Pi will start
**playing the videos immediatelly after starting up** (you don't need to
disconnect the USB stick and connect it again).

To play the videos in **particular order**, name your files with numbers or
lowercase letters. Non-latin characters (with diacritics, in cyrillic etc) as
well as special characters (punctuation etc) are discouraged.

Video Pi supports Full HD (1080p) **video resolution**.

The **loop** (repeat all) function cannot be turned off.

### Image slideshow

You can put image files on the USB stick too (even mix video and image
files). Each image will be shown for **5 seconds**.

### Audio output

To adjust **audio volume**, disconnect the USB stick and then use the blue icon
on the right side of the top system panel. Right-click the icon to change
whether the **sound will play from HDMI or from the 3.5mm jack**.

## FAQ

### Video playback is not smooth

1. Make sure your power supply is strong enough.
2. Try different encoding options when rendering the video. Videos transcoded in
   VLC with the setting _Video for MPEG4 1080p TV/device_ are tested to play
   well.
3. Lastly, you can try overclocking your Raspberry Pi.

### Changing the time between images in a slideshow

You can change the setting only by editing the files `/usr/bin/video-pi-play`
and `/usr/bin/video-pi-play-images-only`.

## Support and getting involved

If you have an idea on how to improve Video Pi or if you need help using it,
send me an email to:

videopi at saloun dot cz

Also please let us know if you're in Berlin or Prague and have a Raspberry Pi 3
Model B+ or Raspberry Pi 4 to lend out for testing.

## Buy Video Pi

If you don't feel like installing Video Pi yourself, I can

- **lend you a Video Pi** (or more) for a daily price
- or I can **sell it to you**

In either case, I will **help you with the initial setup**.

Contact:

videopi at saloun dot cz

## Acknowledgements

Video Pi uses:

- [udevil](https://ignorantguru.github.io/udevil/) to trigger an action when USB
  stick is inserted
- [VLC](https://www.videolan.org/) video player
- [omxiv](https://github.com/HaarigerHarald/omxiv) image viewer
- [raspi-config](https://github.com/RPi-Distro/raspi-config) configuration tool

## Building from source

1. Install Docker and start it.

2. Build the Docker container in which the package will be built:

    ``` shell
    make debian-docker-build
    ```

2. Build the `video-pi` Debian package:

    ``` shell
    make debian-build
    ```

3. Build the `omxiv` Debian package:

    1. Clone this repository on the target Raspberry Pi.
    2. Run `./build-omxiv`.

4. Build the `udevil` Debian package:

    1. Clone this repository on the target Raspberry Pi.
    2. Run `./build-udevil`.

All packages will be created in the directory `dist/`.

### Signing

Additionally, you can sign the built package with GPG:

``` shell
make sign key_id='<gpg key fingerprint>'
```

## License

Copyright 2015-2022 Jakub Valenta

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
