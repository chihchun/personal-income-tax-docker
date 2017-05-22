#!/bin/sh

# Disable pcscd
sudo /etc/init.d/pcscd stop


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
    chihchun/personal-income-tax:2017 \
    $@
