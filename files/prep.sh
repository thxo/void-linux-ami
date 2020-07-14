#!/usr/bin/env bash
set -o
# Download Void Linux ROOTFS
curl -o rootfs.tar.xz https://alpha.us.repo.voidlinux.org/live/current/void-x86_64-ROOTFS-20191109.tar.xz

# Partition & format Void's disk.
lsblk -f
parted -a optimal -s /dev/xvdf mklabel msdos
parted -a optimal -s /dev/xvdf mkpart primary 0% 100%
mkfs.ext4 -F /dev/xvdf1

# Preps for chroot
mount /dev/xvdf1 /mnt
tar xf rootfs.tar.xz -C /mnt
mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
sed '/^[[:blank:]]*#/d' /etc/resolv.conf >/mnt/etc/resolv.conf
mv /tmp/files/awsfirstrun/ /mnt/etc/sv/awsfirstrun/
mv /tmp/files/in-chroot.sh /mnt/in-chroot.sh
