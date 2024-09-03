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

- Raspberry Pi 5
- Raspberry Pi 3 Model B+
- Raspberry Pi 2 Model B

Not supported:

- Raspberry Pi 1

## Installation

1. Install Raspberry Pi OS on your Raspberry Pi by following the [installation
   guide](https://www.raspberrypi.com/documentation/computers/getting-started.html#install-an-operating-systemhttps://www.raspberrypi.org/documentation/installation/installing-images/README.md).

       It is recommended to use the [2023-05-03 bullseye armhf
       image](https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2023-05-03/2023-05-03-raspios-bullseye-armhf.img.xz),
       because certain newer versions don't play HD video smoothly.

2. Download the Video Pi package and its dependency udevil:

    [video-pi](https://github.com/jakubvalenta/video-pi/releases/download/v2.0.0/video-pi_2.0.0-1_all.deb)

    [udevil-0.4.5](https://github.com/jakubvalenta/video-pi/releases/download/v1.2.1/udevil_0.4.5-1_armhf.deb)

3. Transfer the downloaded packages to your Raspberry Pi, for example on a USB stick.

4. On your Raspberry Pi:

    Install the packages as root:

    ``` shell
    sudo apt install ./udevil_*.deb ./video-pi_*.deb
    ```

    Then run the Video Pi installation script as regular user:

    ``` shell
    video-pi-install
    ```

    The script will edit your desktop configuration to set the Video Pi
    wallpaper and to disable PCManFM's USB stick automounting, which would
    conflict with Video Pi's automounting system based on udevil.

4. Reboot your Raspberry Pi.

## Uninstallation

On your Raspberry Pi:

    Run the Video Pi uninstallation script:

    ``` shell
    video-pi-uninstall
    ```

    This will restore your LXDE configuration from a backup made when installing Video Pi.

    Then uninstall the Video Pi package and its dependency udevil as root:

    ``` shell
    sudo apt --purge remove udevil video-pi
    ```

## User guide

### Starting Video Pi

1. Make sure the **HDMI or S-Video cable** is connected _before_ you power on
   the device.
2. Plug in the power source.

When Video Pi finishes startup, it will show a desktop with dark background and
the red Video Pi logo.

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

You can put image files on the USB stick too. Each image will be shown for **5
seconds**.

If you put only image files on the USB stick (no video files), an image viewer
program will be used to show them. Then you can **configure the duration** of
each slide by opening the main raspberry menu and going to Graphics > Image
Viewer (the one with the purple icon) and then hamburger menu > Preferences >
Slideshow.

### Changing audio volume

Disconnect your USB stick and then left-click the blue speaker icon on the right
side of the top system panel.

### Switching between HDMI and 3.5mm jack audio output

Disconnect your USB stick and then right-click the blue speaker icon on the
right side of the top system bar.

## FAQ

### Video playback is not smooth

1. Make sure your power supply is strong enough and the USB cable is high
   quality. If either are bad, you will see a gray lower power notification or a
   yellow lightning icon in the upper right corner of the screen.
2. Try different encoding options when rendering the video. Videos transcoded in
   VLC with the setting _Video for MPEG4 1080p TV/device_ are tested to play
   well.
3. Lastly, you can try overclocking your Raspberry Pi.

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
- [VLC](https://www.videolan.org/) media player
- [Eye of Gnome](https://help.gnome.org/users/eog/stable/) image viewer

## Building from source

1. Install Docker and start it.

2. Install and set up QEMU to be able to build and run AMRv7 Docker images.

3. Build the Docker container in which the package will be built:

    ``` shell
    make debian-docker-build
    ```

4. Build the `video-pi` and `udevil` Debian packages:

    ``` shell
    make debian-build
    make debian-build-udevil
    ```

All packages will be created in the directory `dist/`.

### Signing

Additionally, you can sign the built package with GPG:

``` shell
make sign key_id='<gpg key fingerprint>'
```

## License

Copyright 2015-2024 Jakub Valenta

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
