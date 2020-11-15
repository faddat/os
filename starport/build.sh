#!/bin/bash
# This process uses tools and a design pattern first developed by the pikvm team for their pi-builder and os tools.
# the biggest differences between this process and theirs are:
# * we use docker buildx so we don't need to deal with qemu directly.
# * we are not offering as many choices to users and are designing around automation.

# Later we can make this work for more devices and platforms with nearly the same technique.
# Reasonable build targets include: https://archlinuxarm.org/platforms/armv8
# For example, the Odroid-N2 is the same software-wise as our Router!

# Fail on error
set -exo pipefail


# Get the 64 bit rpi rootfs for Pi 3 and 4
wget --progress=bar:force:noscroll http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz

# Reintroduce later
# export ROOT_PASSWD=root


# BUILD IMAGE
# --build-arg ROOT_PASSWD
docker buildx build --tag starport --platform linux/arm64 .


# PREPARE TOOLBOX
docker build --rm --tag toolbox --file toolbox/Dockerfile.root toolbox


# EXTRACT IMAGE

# Make a temporary directory
mkdir .tmp
# remove anything in the way of extraction
docker run --rm --tty --volume $(shell pwd)/./.tmp:/root/./.tmp --workdir /root/./.tmp/.. toolbox rm -rf ./.tmp/result-rootfs
# save the image to result-rootfs.tar
docker save --output ./.tmp/result-rootfs.tar starport
# Extract the image using docker-extract
docker run --rm --tty --volume $(shell pwd)/./.tmp:/root/./.tmp --workdir /root/./.tmp/.. toolbox /tools/docker-extract --root ./.tmp/result-rootfs  ./.tmp/result-rootfs.tar
# Set hostname
bash -c "echo starport > ./.tmp/result-rootfs/etc/hostname"
