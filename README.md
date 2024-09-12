# Video Pi

Video player that plays files from a USB stick. Designed for art installations
and similar presentations. No maintenance or remote control required.

Video Pi is a software package for the Raspberry Pi mini computer.

[https://videopi.ooooo.page](https://videopi.ooooo.page)

## Features

- supports a __wide range of video formats__
- plays all video files from a __USB stick__ in a __loop__
- __turns on automatically__ when connected to power
- __HDMI and S-Video__ video output
- __HDMI or 3.5mm jack__ audio output

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
   guide](https://www.raspberrypi.com/documentation/computers/getting-started.html#install-an-operating-system).

    It's recommended to use the [2023-05-03 bullseye armhf
    image](https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2023-05-03/2023-05-03-raspios-bullseye-armhf.img.xz),
    because certain newer versions don't play HD video smoothly.

2. Download the Video Pi package and its dependency udevil:

    [video-pi](https://github.com/jakubvalenta/video-pi/releases/download/v2.0.0/video-pi_2.0.0-1_armhf.deb)

    [udevil-0.4.5](https://github.com/jakubvalenta/video-pi/releases/download/v1.2.1/udevil_0.4.5-1_armhf.deb)

3. Transfer the downloaded packages to your Raspberry Pi, for example on a USB stick.

4. On your Raspberry Pi:

    Install the packages as root:

    ``` shell
    sudo apt install ./udevil_*.deb ./video-pi_*.deb
    ```

    Then run the Video Pi installation program as regular user:

    ``` shell
    video-pi-install
    ```

    It will:

    - Set a black wallpaper.
    - Hide the top bar.
    - Hide the trash and devices desktop icons.
    - Disable the built-in USB stick automounting, which could conflict with
      Video Pi's automounting system based on udevil.

4. Reboot your Raspberry Pi.

## Uninstallation

On your Raspberry Pi:

    Run the Video Pi uninstallation program:

    ``` shell
    video-pi-uninstall
    ```

    It will restore your desktop configuration from a backup made when installing Video Pi.

    Then uninstall the Video Pi package and its dependency udevil as root:

    ``` shell
    sudo apt --purge remove udevil video-pi
    ```

## User guide

### Starting Video Pi

1. Make sure the HDMI or S-Video cable is connected _before_ you power on the
   device.
2. Plug in the power source.

When the computer finishes startup, it will show a desktop with black
wallpaper and no icons.

### Video playback

To start playing videos, **connect a USB stick** with your video files. Video Pi
will play all the files in **alphabetical order**. When it finishes the last
file, it will start again with the first file without a break.

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
each slide by opening the main raspberry menu and going to _Graphics_ > _Image
Viewer_ (the one with the purple icon) and then hamburger menu > _Preferences_ >
_Slideshow_.

### Changing audio volume

1. Disconnect your USB stick.
2. Connect a mouse and move the cursor to the upper right corner of the screen.
3. In the top panel that apppars, click the blue speaker icon with the **left
   mouse button**.

### Switching between HDMI and 3.5mm jack audio output

1. Disconnect your USB stick.
2. Connect a mouse and move the cursor to the upper right corner of the screen.
3. In the top panel that apppars, click the blue speaker icon with the **right
   mouse button**.

## FAQ

### Video playback is not smooth

1. Make sure your **power supply** is strong enough and the USB cable is high
   quality. If either are bad, you will see a gray low power notification or a
   yellow lightning icon in the upper right corner of the screen.
2. Try different **encoding** options when rendering the video. Videos
   transcoded in VLC with the setting _Video for MPEG4 1080p TV/device_ are
   tested to play well.
3. Use a more powerful **Raspberry Pi model**. Full HD videos with high
   framerate might need Raspberry Pi 4 or newer.
4. Lastly, you can try **overclocking** your Raspberry Pi.

## Support and getting involved

If you have an idea on how to improve Video Pi or if you need help using it,
send me an email to:

videopi at mailbox dot org

## Buy Video Pi

If you don't feel like installing Video Pi yourself, I can

- **lend you a Raspberry Pi with Video Pi installed** for a daily price,
- or I can **sell it to you**.

In either case, I will **help you with the initial setup**.

Contact:

videopi at mailbox dot org

## Acknowledgements

Video Pi uses:

- [udevil](https://ignorantguru.github.io/udevil/) to trigger an action when a
  USB stick is connected,
- [VLC](https://www.videolan.org/) media player,
- [Eye of Gnome](https://help.gnome.org/users/eog/stable/) image viewer.

## Building from source

1. Install and start Docker.

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
