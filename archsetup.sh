# bootloader
pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

# local settings
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
ln -sf /usr/share/zoneinfo/Europe/Vienna  /etc/localtime
#localectl set-keymap --no-convert de-latin1
#localectl set-locale LANG=en_US.UTF-8

# read user name
user="$(cat username.txt)"

# install basics
pacman -Syu
pacman -S --noconfirm --needed sudo git wget dmenu freetype2 libx11 libxft libxinerama libxext libxft xorg-fonts-misc ncurses wicd-gtk ttf-liberation xorg-server xorg-xrandr xorg-xev xorg-xinit feh gvim dialog zathura firefox diff-so-fancy acpi xorg-xsetroot alsa-utils mutt

# give user permissions
useradd -m -G wheel -s /bin/bash $user
sed -i "/%wheel ALL=(ALL) ALL/s/^#//g" /ect/sudoers

# folder structure
mkdir /home/$user/src
mkdir /home/$user/bin

# zsh & oh my zsh
pacman -S --noconfirm --needed zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$user/.oh-my-zsh
usermod -s /usr/bin/zsh $user

# suckless
git clone git://git.suckless.org/st /home/$user/src/st
git clone git://git.suckless.org/dwm /home/$user/src/dwm
cd /home/$user/src/st
wget https://st.suckless.org/patches/scrollback/st-scrollback-0.8.diff
git apply st-scrollback-0.8.diff
make clean install
cd ../dwm
make clean install
cd

# python
pacman -S --noconfirm --needed python python-pip
pip3 install httplib2

# calcurse
pacman -S --noconfirm --needed asciidoc
cd /home/$user/src
git clone git://git.calcurse.org/calcurse.git
cd calcurse
./autogen.sh
./configure
make
make install
echo "#!/bin/sh
CALCURSE_CALDAV_PASSWORD=$(pass show calcurse) calcurse-caldav --config ~/.calcurse/caldav/config_cal --syncdb ~/.calcurse/caldav/sync_cal.db
CALCURSE_CALDAV_PASSWORD=$(pass show calcurse) calcurse-caldav --config ~/.calcurse/caldav/config_todo --syncdb ~/.calcurse/caldav/sync_todo.db
exec calcurse" > /home/$user/bin/calcurse-sync.sh
chmod +x /home/$user/bin/calcurse-sync.sh
cd

# get dotfiles
git clone https://github.com/kobus-v-schoor/dotgit /home/$user/dotgit
cp -r /home/$user/dotgit/bin/dotgit* /home/$user/bin
rm -rf /home/$user/dotgit
echo 'export PATH="$PATH:home/$user/bin"' >> ~/.bashrc
git clone https://github.com/PaulSt/dots /home/$user/dots
cd /home/$user/dots/dotfiles/x
chmod +x .xinitrc
cd /home/$user/dots
../bin/dotgit restore
cd

# git pass
pacman -S --noconfirm --needed gnupg pass
git clone https://github.com/PaulSt/pass /home/$user/.password-store

# set pw
passwd
passwd $user
chown -R $user /home/$user
