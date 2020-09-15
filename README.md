# Video Pi Debian Package

_Video player for artists by artists_

This document contains technical information about Video Pi. For general help
and configuration instructions visit
[videopi.saloun.cz](https://videopi.saloun.cz).

## Build

1. Install Docker and start it.

2. Build the Docker container in which the package will be built:

    ``` shell
    make debian-container-build
    ```

2. Build the Video Pi Debian package:

    ``` shell
    make debian-build
    ```

    The package will be created in the directory `dist/`.

### Signing

Additionally, you can sign the built package with GPG:

``` shell
make sign key_id='<gpg key fingerprint>'
```

### License

Copyright 2015-2020 Jakub Valenta

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
