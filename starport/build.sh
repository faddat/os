#!/bin/bash

wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz

docker buildx build --platform linux/arm64 .

