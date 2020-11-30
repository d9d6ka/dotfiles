# Debian

## Bare git repo

### Init

```bash
git init --bare $HOME/.dotgit 
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'" >> $HOME/.bashrc
source ~/.bashrc
dotfiles config --local status.showUntrackedFiles no 
```

### Clone

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotgit/ --work-tree=$HOME'" >> $HOME/.bashrc
source ~/.bashrc
echo ".dotfiles.git" >> .gitignore
git clone --bare <repo URL> $HOME/.dotfiles.git
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no 
```

## Network

### wpa_supplicant

```bash
ip link show
ip link set <INTERFACE> up
wpa_passphrase <SSID> <PASSWORD> >> /etc/wpa_supplicant/wpa_supplicant-<INTERFACE>.conf
systemctl restart wpa_supplicant
#wpa_supplicant -B -i <INTERFACE> -c <CONFIG>
#dhcpcd <INTERFACE>
```

## Post-Install

```bash
dpkg-reconfigure locales
```

## Elementary icon set:

```bash
git clone https://github.com/shimmerproject/elementary-xfce.git
cd elementary-xfce
sudo cp -r ./elementary-xfce /usr/share/icons/
sudo gtk-update-icon-cache /usr/share/icons/elementary-xfce/
```

## Papirus icon set:

```bash
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git
cd papirus-icon-theme
sudo cp -r ./Papirus /usr/share/icons/
sudo gtk-update-icon-cache /usr/share/icons/Papirus/
```

## Nicer `/etc/lightdm/lightdm-gtk-greeter.conf`:

```
[greeter]
theme-name = Arc
icon-theme-name = Paper
cursor-theme-name = Breeze_Snow
```

## Installing Nerd fonts

```
git clone https://github.com/ryanoasis/nerd-fonts.git
./install.sh 
```

## Touchpad

```bash
apt remove xserver-xorg-input-synaptics
apt install xserver-xorg-input-libinput

sudo mkdir -p /etc/X11/xorg.conf.d
sudo ln -s /usr/share/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf
sudo tee -a /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null <<EOT
Section "InputClass"
        Identifier "MyTouchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
        Option "NaturalScrolling" "true"
        Option "AccelSpeed" "0.3"
EndSection
EOT

systemctl restart lightdm
```

## Debian EEE PC dark screen fix

In `/etc/default/grub` find

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

Change it to

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpi_osi=Linux acpi_backlight=vendor"
```

Then `grub-update`.

## Installing i3 from authors' repo (deb)

```
$ /usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
# dpkg -i ./keyring.deb
# echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" >> /etc/apt/sources.list.d/sur5r-i3.list
# apt update
# apt install i3
```

## Installing i3lock-fancy

```
git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy
sudo make install
```

## Installing Polybar (deb)

- Dependencies: `apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev`
- Optional dependencies: `apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev`
```
git clone https://github.com/jaagr/polybar.git`
cd polybar
./build.sh
```

## Installing Powerline (deb)

```
apt install fonts-powerline powerline
pip install --user powerline-status
pip show powerline-status
```

Add to `.vimrc`:

```
set rtp+=/home/<user>/.local/lib/python2.7/site-packages/powerline/bindings/vim
set laststatus=2
```

Add to `.bashrc` (also in `/root`):

```bash
if [ -f `which powerline-daemon` ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /home/zyamalov/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
```

And then do:

```bash
mkdit -p ~/.config/powerline
cat <<-'EOF' > ~/.config/powerline/config.json
{
    "ext": {
        "shell": {
            "theme": "default_leftonly"
        }
    }
}
EOF
powerline-daemon --replace
```

Whether powerline in shell is not needed we can just use `vim-airline`.

## Vim fix

To start vim in xfce-terminal change in vim.desktop: 

```bash
Exec=xfce4-terminal -e "vim %F"
Terminal=false
```
