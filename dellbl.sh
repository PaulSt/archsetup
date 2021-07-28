bootctl --path=/boot install

UUID=$(cryptsetup luksUUID /dev/nvmen0n1p2)
cat <<EOF>/boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root="LABEL=/dev/nvme0n1p2" rw
EOF

cat <<EOF>/boot/loader/loader.conf
default  arch.conf
timeout  4
console-mode max
editor   no
EOF
