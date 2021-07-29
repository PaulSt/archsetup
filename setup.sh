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

# wpa_supplicant config
cat <<EOF>/etc/wpa_supplicant/wpa_supplicant.conf
ctrl_interface=/run/wpa_supplicant
update_config=1
EOF
# hook to dhcpcd
ln -s /usr/share/dhcpcd/hooks/10-wpa_supplicant /usr/lib/dhcpcd/dhcpcd-hooks/
# autostart
systemctl enable dhcpcd

# install basics
pacman -Syu --noconfirm --needed

basics=(
    sudo
    git
    wget
    dmenu
    libx11
    libxinerama
    libxext
    libxft
    freetype2
    ttf-liberation
    ttf-dejavu
    ttf-font-awesome
    wpa_supplicant
    #ncurses
    #wicd-gtk
    feh
    acpi
    xf86-video-intel
    alsa-utils
    dosfstools
    cowsay
    #zsh
)
pacman -S --noconfirm --needed ${basics[@]}

work=(
    gvim
    ctags
    zathura
    firefox
    diff-so-fancy
    newsboat
    vim-spell-de
    #octave
    #dialog
    #mutt
)
pacman -S --noconfirm --needed ${work[@]}

xorg=(
    xorg-server
    xorg-xrandr
    xorg-xev
    xorg-xinit
    xorg-fonts-misc
    xorg-xbacklight
    xorg-xsetroot
)
pacman -S --noconfirm --needed ${xorg[@]}

# autostart wicd
#systemctl enable wicd

# give user permissions
useradd -m -G wheel -s /bin/bash $user
#sed -i "/%wheel ALL=(ALL) ALL/s/^#//g" /etc/sudoers
echo "%wheel ALL=(ALL) NOPASSWD: ALL, /sbin/poweroff, /sbin/reboot, /sbin/shutdown" >> /etc/sudoers

# folder structure
mkdir /home/$user/src
mkdir /home/$user/bin
mkdir /home/$user/projects

# zsh & oh my zsh
#pacman -S --noconfirm --needed zsh
#git clone https://github.com/robbyrussell/oh-my-zsh.git /home/$user/.oh-my-zsh
#usermod -s /usr/bin/zsh $user

# suckless
git clone https://github.com/PaulSt/st.git /home/$user/src/st
git clone https://github.com/PaulSt/dwm.git /home/$user/src/dwm
git clone https://github.com/PaulSt/slock.git /home/$user/src/slock
cd /home/$user/src/st
git apply *.diff
make clean install
cd ../dwm
git apply *.diff
make clean install
cd ../slock
make clean install
cd /

# python
pacman -S --noconfirm --needed python python-pip
python_modules=(
    python
    python-pip
    pytest
    pytest-watch
    numpy
    pandas
    jupyterlab
)
pip install --user ${python_modules[@]}

# calcurse
#pacman -S --noconfirm --needed asciidoc
#cd /home/$user/src
#git clone git://git.calcurse.org/calcurse.git
#cd calcurse
#./autogen.sh
#./configure
#make
#make install
#cd /

# get dotfiles
git clone https://github.com/kobus-v-schoor/dotgit /home/$user/dotgit
cp -r /home/$user/dotgit/old/bin/dotgit* /home/$user/bin
rm -rf /home/$user/dotgit
git clone https://github.com/PaulSt/dots /home/$user/dots
cd /

# ngsolve
ngq="$(cat ngq.txt)"
rm ngq.txt
if [[ "$ngq" =~ "yes" ]]
then
    pacman -S --noconfirm --needed blas cmake ffmpeg glu libxmu opencascade python tk lapack
    export BASEDIR=/home/$user/ngsuite
    mkdir -p $BASEDIR
    cd $BASEDIR && git clone https://github.com/NGSolve/ngsolve.git ngsolve-src
    cd $BASEDIR/ngsolve-src && git submodule update --init --recursive
    mkdir $BASEDIR/ngsolve-build
    mkdir $BASEDIR/ngsolve-install
    cd $BASEDIR/ngsolve-build
    cmake -DCMAKE_INSTALL_PREFIX=${BASEDIR}/ngsolve-install ${BASEDIR}/ngsolve-src
    make
    make install
    cd /
fi

# get projects
git clone https://github.com/PaulSt/archsetup.git /home/$user/projects/archsetup

#git pass
#pacman -S --noconfirm --needed gnupg pass
#git clone https://github.com/PaulSt/pass /home/$user/.password-store

# set pw
passwd
passwd $user
chown -R $user /home/$user

# now that user is owner - create dotfiles
runuser -l $user -c "cd /home/$user/dots && /home/$user/bin/dotgit restore"
