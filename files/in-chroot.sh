#!/bin/sh
set -o

# Install Void Linux using the CHROOT method.
# https://docs.voidlinux.org/installation/guides/chroot.html
xbps-install -Syu xbps
xbps-install -uy
xbps-install -y base-system grub curl
xbps-remove -y base-voidstrap
xbps-reconfigure -f glibc-locales
echo $(blkid | grep xvdf1 | cut -d " " -f 2) / ext4 rw,relatime 0 0 >/etc/fstab
grub-install /dev/xvdf
xbps-reconfigure -fa

# Remove the password requirement for sudo.
sed -i '/wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers
sed -i '/wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers

# Enable desirable services.
ln -s /etc/sv/dhcpcd /etc/runit/runsvdir/default/
ln -s /etc/sv/sshd /etc/runit/runsvdir/default/

# Add `ec2-user` as a user. User's SSH key will be assigned here.
useradd -m -G wheel ec2-user

# Helper to set hostname + download user's SSH key.
# See files/awsfirstrun.
ln -s /etc/sv/awsfirstrun /etc/runit/runsvdir/default/
chmod +x /etc/sv/awsfirstrun/*

# And we're done!
rm -f /in-chroot.sh
