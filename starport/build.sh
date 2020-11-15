#!/bin/bash

# Later we can make this work for more devices and platforms with nearly the same technique.
# Reasonable build targets include: https://archlinuxarm.org/platforms/armv8
wget --progress=bar:force:noscroll http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz

# Reintroduce later
# export ROOT_PASSWD=root
# --build-arg ROOT_PASSWD


# Build the image
docker buildx build --tag starport --platform linux/arm64 .

