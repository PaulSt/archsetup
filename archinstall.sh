#!/bin/bash

# get user info
read -p "Name computer: " comp
read -p "User: " user
read -r -p "Do you want to install NGSolve? [Y/n] " ngsresponse
echo "ok"

timedatectl set-ntp true

# partition disk
cat <<EOF | fdisk /dev/sda
o
n
p


+200M
n
p


+4G
n
p


+30G
n
p


w
EOF
partprobe

yes | mkfs.ext4 /dev/sda4
yes | mkfs.ext4 /dev/sda3
yes | mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home

pacstrap /mnt base base-devel

genfstab -U /mnt >> /mnt/etc/fstab
echo "$comp" > /mnt/etc/hostname
echo "$user" > /mnt/username.txt
if [[ "$ngsresponse" =~ ^([yY][eE][sS]|[yY])+$|^$ ]]
then
    echo "yes" > /mnt/ngq.txt
fi

curl https://raw.githubusercontent.com/PaulSt/archsetup/master/archsetup.sh > /mnt/chroot.sh && arch-chroot /mnt bash chroot.sh && rm /mnt/chroot.sh
