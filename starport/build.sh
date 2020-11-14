#!/bin/bash

wget --progress=bar:force:noscroll http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz

export ROOT_PASSWD=root

docker buildx build --build-args ROOT_PASSWD --platform linux/arm64 .

