#!/bin/bash
set -ex

rm -f /etc/ssh/ssh_host_*
ssh-keygen -v -A


umount /dev/mmcblk0p3
parted /dev/mmcblk0 -a optimal -s resizepart 3 100%
yes | mkfs.ext4 -F -m 0 /dev/mmcblk0p3
mount /dev/mmcblk0p3

systemctl disable pikvm-firstboot
