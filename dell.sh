read -p "Name computer: " comp
read -p "User: " user
read -r -p "Do you want to install NGSolve? [Y/n] " ngsresponse
echo "ok"

loadkeys de
parted -a optimal /dev/nvme0n1 mklabel gpt
parted -a optimal -- /dev/nvme0n1 mkpart ESP fat32 1MiB 513MiB set 1 boot on
parted -a optimal -- /dev/nvme0n1 mkpart ext4 513MiB 50513MiB
parted -a optimal -- /dev/nvme0n1 mkpart ext4 50513MiB 100%

yes | mkfs.ext4 /dev/nvme0n1p2
yes | mkfs.ext4 /dev/nvme0n1p3
yes | mkfs.fat -F32 /dev/nvme0n1p1

mount /dev/nvme0n1p2 /mnt
mkdir /mnt/{boot,home}
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme0n1p3 /mnt/home

pacstrap /mnt base base-devel linux intel-ucode dialog dhcpcd wpa_supplicant git vim
genfstab -U /mnt >> /mnt/etc/fstab

curl https://raw.githubusercontent.com/PaulSt/archsetup/master/systemdboot.sh > /mnt/systemdboot.sh
curl https://raw.githubusercontent.com/PaulSt/archsetup/master/setup.sh > /mnt/setup.sh

arch-chroot /mnt bash systemdboot.sh && bash setup.sh
