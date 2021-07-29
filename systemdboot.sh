bootctl --path=/boot install


uuid=$(blkid -s PARTUUID -o value /dev/sda2)
cat <<EOF>/boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=$uuid rw
EOF

cat <<EOF>/boot/loader/loader.conf
default  arch.conf
timeout  4
#console-mode max
#editor   no
EOF
