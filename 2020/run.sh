#!/bin/sh
set -x

# Disable anything on the host that use the smartcard.
# Disable pcscd
sudo /etc/init.d/pcscd stop
sudo systemctl stop pcscd
sudo systemctl stop pcscd.socket
# GNU privacy guard - smart card support
sudo killall scdaemon

# Ensure user can connect to X server on localhost
xhost +localhost

# Individual Income Tax
docker run -ti --rm \
    -e XMODIFIERS=$XMODIFIERS \
    -e LANGUAGE=$LANGUAGE \
    -e LC_ALL=$LC_ALL \
    -e LANG=$LANG \
    -e LC_CTYPE=${LC_CTYPE} \
    -e DISPLAY=$DISPLAY \
    --privileged -v /dev/bus/usb:/dev/bus/usb \
    -v $(xdg-user-dir DOWNLOAD):/home/firefox/Downloads \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --shm-size 256m \
    chihchun/personal-income-tax:2020 \
    $@
