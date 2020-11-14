# INIT

# Start with nothing
FROM scratch

# Add and decomprress Arch Linux ARM rpi arm64 rootfs at /
ADD ArchLinuxARM-rpi-aarch64-latest.tar.gz /

# Might be able to avoid by using buildx
# COPY "qemu-%QEMU_GUEST_ARCH%-static" "%QEMU_STATIC_GUEST_PATH%"

# ARG TIMEZONE
# ENV TIMEZONE $TIMEZONE

ARG REPO_URL
ENV REPO_URL $REPO_URL

# OS:

# https://lists.gnu.org/archive/html/qemu-devel/2017-10/msg03681.html

# Set System Locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
		&& locale-gen
ENV LC_ALL en_US.UTF-8

# Set Time Zone
# RUN timedatectl set-timezone UTC

# Configure Kernel
RUN echo "HOOKS=(base udev block filesystems)" >> /etc/mkinitcpio.conf && \
		echo "MODULES=(bcm_phy_lib broadcom mdio_bcm_unimac genet)" >> /etc/mkinitcpio.conf

# RUN echo "Server = $REPO_URL/\$arch/\$repo" > /etc/pacman.d/mirrorlist \
#		&& pacman-key --init \
#		&& pacman-key --populate archlinuxarm

# Pacman Keyring
RUN pacman-key --init \
		&& pacman-key --populate archlinuxarm

# Don't check disk space
RUN sed -i -e "s/^CheckSpace/#!!!CheckSpace/g" /etc/pacman.conf

# Install depenencies
RUN pacman --noconfirm -Syy \
		&& pacman --needed --noconfirm -S \
				glibc \
				pacman \
		&& pacman-db-upgrade \
		&& pacman --noconfirm -Syu \
		&& pacman --needed --noconfirm -S \
				p11-kit \
				archlinux-keyring \
				ca-certificates \
				ca-certificates-mozilla \
				ca-certificates-utils

# Dependencies more specific to our purposes
RUN pacman --needed --noconfirm -S \
				base \
				base-devel \
				vim \
				colordiff \
				tree \
				wget \
				unzip \
				unrar \
				htop \
				nmap \
				iftop \
				iotop \
				strace \
				lsof \
				git \
				jshon \
				rng-tools \
				nano \
				bc \
				go \
				npm \
				go-ipfs \
				zerotier-one
				yarn \
				netctl \
				parted \
				jq \
				e2fsprogs


#		&& case "$BOARD" in \
#						rpi|rpi2|rpi3|zero|zerow) pacman --needed --noconfirm -S linux-raspberrypi linux-raspberrypi-headers;; \
#						rpi4) pacman --needed --noconfirm -S linux-raspberrypi4 linux-raspberrypi4-headers;; \
#						*) echo "Unknown board: $BOARD"; exit 1;; \
#				esac \
#		&& (pacman --noconfirm -Sc || true)


# Use the Pi's Hardware rng.  You may wish to modify depending on your needs and desires: https://wiki.archlinux.org/index.php/Random_number_generation#Alternatives
RUN echo 'RNGD_OPTS="-o /dev/random -r /dev/hwrng"' > /etc/conf.d/rngd \
		&& systemctl disable haveged \
		&& systemctl enable rngd

# systemd-resolved: we will use hnsd instead
RUN echo "DNSSEC=no" >> /etc/systemd/resolved.conf \
		&& systemctl enable systemd-resolved


# Maybe do things like this to make the shell pretty
# RUN mkdir /tmp/linux-profile \
#		&& git clone https://github.com/mdevaev/linux-profile.git /tmp/linux-profile --depth=1 \
#		&& cp -a /tmp/linux-profile/{.bash_profile,.bashrc,.vimrc,.vimpagerrc,.vim} /etc/skel \
#		&& cp -a /tmp/linux-profile/{.bash_profile,.bashrc,.vimrc,.vimpagerrc,.vim} /root \
#		&& cp -a /tmp/linux-profile/{.bash_profile,.bashrc,.vimrc,.vimpagerrc,.vim} /home/alarm \
#		&& chown -R alarm:alarm /home/alarm/{.bash_profile,.bashrc,.vimrc,.vimpagerrc,.vim,.gitconfig} \
#		&& rm -rf /tmp/linux-profile

# STARPORT: This section is variable and special-- put your blockchain here.

COPY motd /etc/

# RUN sed -i -e "s/-session   optional   pam_systemd.so/#-session   optional   pam_systemd.so/g" /etc/pam.d/system-login

# This should be phased out most likely.
# ARG ROOT_PASSWD
# ENV ROOT_PASSWD $ROOT_PASSWD


# Set root password to root
RUN echo "root:root" | chpasswd \
	&& echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
	&& userdel -r -f alarm

# First Boot service
COPY firstboot.sh /usr/local/bin/firstboot.sh
COPY firstboot.service /etc/systemd/system/firstboot.service
RUN systemctl enable firstboot

# CLEANUP: Always here

# Remove setup-related cruft
RUN rm -rf \
/etc/*- \
/var/lib/systemd/* \
/var/lib/private/* \
/var/log/* \
/var/tmp/* \
/tmp/* \
/run/* \
/root/.bash_history \
/root/.cache \
/home/*/.bash_history \
/home/*/.cache

RUN sed -i -e "s/^#!!!CheckSpace/CheckSpace/g" /etc/pacman.conf

ENV LD_PRELOAD=
