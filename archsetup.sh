# bootloader
pacman --noconfirm --needed -S grub && grub-install --target=i386-pc /dev/sda && grub-mkconfig -o /boot/grub/grub.cfg

# local settings
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US ISO-8859-1" >> /etc/locale.gen
locale-gen
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
localectl set-keymap --no-convert de-latin1
ln -sf /usr/share/zoneinfo/Europe/Vienna  /etc/localtime
localectl set-locale LANG=en_US.UTF-8

# Add new user
read -p "User: " user
useradd -m -G wheel -s /bin/bash $user
passwd $user
sed -i "/%wheel ALL=(ALL) ALL/s/^#//g" /ect/sudoers

# install basics
pacman -Syu
pacman -S sudo git wget dmenu freetype2 libx11 libxft libxinerama libxext libxft xorg-fonts-misc ncurses wicd-gtk ttf-liberation

# suckless
cd /usr/local/src
git clone git://git.suckless.org/st
cd st
wget https://st.suckless.org/patches/scrollback/st-scrollback-0.8.diff
git apply st-scrollback-0.8.diff
sudo make clean install
cd ..
git clone git://git.suckless.org/dwm
cd dwm
sudo make clean install

# oh my zsh
pacman -S zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# python
pacman -S python python-pip
pip3 install httplib2

# calcurse
pacman -S asciidoc
cd /usr/src
git clone git://git.calcurse.org/calcurse.git
cd calcurse
./autogen.sh
./configure
make
make install
mkdir /usr/scripts
echo '#!/bin/sh
CALCURSE_CALDAV_PASSWORD=$(pass show calcurse) calcurse-caldav --config /home/paul/.calcurse/caldav/config_cal --syncdb /home/paul/.calcurse/caldav/sync_cal.db
CALCURSE_CALDAV_PASSWORD=$(pass show calcurse) calcurse-caldav --config /home/paul/.calcurse/caldav/config_todo --syncdb /home/paul/.calcurse/caldav/sync_todo.db
exec calcurse' > /usr/local/bin/calcurse-sync.sh
chmod +x /usr/local/bin/calcurse-sync.sh
cd

# get dotfiles
git clone https://github.com/kobus-v-schoor/dotgit
mkdir -p ~/.bin
cp -r dotgit/bin/dotgit* ~/.bin
cat dotgit/bin/bash_completion >> ~/.bash_completion
rm -rf dotgit
echo 'export PATH="$PATH:$HOME/.bin"' >> ~/.bashrc
git clone https://github.com/PaulSt/dots

# git pass
pacman -S gnupg pass
git clone https://github.com/PaulSt/pass.git
