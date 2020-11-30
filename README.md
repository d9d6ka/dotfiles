# Void Linux

New user must be in `network` group, otherwise he won't be allowed to use NetworkManager.

**To avoid permissions problems add `Defaults umask = 0022` to `sudoers`!!!**

While dualboot, it's better to set `HARDWARECLOCK=localtime` in `/etc/rc.conf`

## Stow Script

To stow config files use `dotstow` script.

## Bare Repository (**not used**)

New:
```bash
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo ".dotfiles" >> $HOME/.gitignore
```

Clone:
```bash
git clone --bare <URL> $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
echo ".dotfiles" >> $HOME/.gitignore
```

## Network

### wpa_supplicant

```bash
ln -s /etc/sv/dhcpcd /var/service/ # if not already
ip link show # get proper interface
ip link set up <INTERFACE>
cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-<INTERFACE>.conf
wpa_passphrase <SSID> <PASSWORD> >> /etc/wpa_supplicant/wpa_supplicant-<INTERFACE>.conf
wpa_supplicant -B -i <INTERFACE> -c /etc/wpa_supplicant/wpa_supplicant-<INTERFACE>.conf
sv restart dhcpcd # restart dhcpcd to get IP
ping -4 -c 5 ya.ru
```

### Network Manager

```bash
xbps-install NetworkManager network-manager-applet  
ln -s /etc/sv/NetworkManager /var/service/
rm -rf /var/service/dhcpcd # we don't need both

sudo tee -a /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManager.rules > /dev/null <<EOT
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
    return polkit.Result.YES;
  }
});
EOT
```

## Post-Install

### Language

```bash
sed -i 's/#\(ru_RU\.UTF-8\)/\1/g' /etc/default/libc-locales
xbps-reconfigure -f glibc-locales
echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
echo "LANG=ru_RU.UTF-8" > /etc/environment

xbps-install terminus-font
```

Set in `/etc/rc.conf`:

```
FONT="ter-u16b"
```

### Packages

```bash
xbps-install -Suv
```

#### Basic packages
```bash
xbps-install dbus elogind polkit tlp udiskie gvfs
xbps-install xorg compton xsel
xbps-install alsa-utils pulseaudio pulsemixer alsa-plugins-pulseaudio

ln -s /etc/sv/{dbus,polkitd,elogind} /var/service/
ln -s /etc/sv/tlp /var/service/
echo 'export $(dbus-launch)' >> ~/.profile
```

#### Desktop manager
```bash
xbps-install lightdm lightdm-gtk-greeter-settings
```

#### Openbox environment
```bash
xbps-install openbox obconf obmenu obmenu-generator tint2 xxkb lxappearance upower mate-powermanagement nitrogen urxvt mate-polkit volctl pnmixer pasystray pavucontrol pcmanfm i3lock-fancy dunst
```

#### i3 environment
```bash
xbps-install i3 i3status i3blocks acpi xxkb lxappearance nitrogen urxvt mate-powermanagement mate-polkit volctl pnmixer pasystray pavucontrol i3lock-fancy dunst
```

#### bspwm environment
```bash
xbps-install bspwm sxhkd xdo lxappearance lxtask nitrogen urxvt mate-powermanagement mate-polkit volctl pnmixer pasystray pavucontrol i3lock-fancy dunst
```

#### xmonad
```bash
xbps-install ghc cabal
ghc-pkg --version # Remember version
rm -r ~/.ghc/i386-linux-8.8.4/package.conf.d
ln -s ~/.cabal/store/ghc-8.8.4/package.db ~/.ghc/i386-linux-8.8.4/package.conf.d
cabal install xmonad xmonad-contrib xmobar
sudo tee -a /usr/share/xsessions/xmonad.desktop > /dev/null <<EOT
[Desktop Entry]
Name=xmonad
Comment=Log in using the xmonad
Exec=/home/zyamalov/.cabal/bin/xmonad
TryExec=/home/zyamalov/.cabal/bin/xmonad
Icon=xmonad
Type=Application
EOT
```

#### dwm environment
```bash
xbps-install xdo xdotool lxappearance nitrogen i3lock-fancy xxkb dunst
```
#### XFCE4 environment
```bash
xbps-install xfce4 xfce4-plugins xfce4-notifyd
```

#### Other stuff
```bash
xbps-install bash-completion zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
xbps-install wget curl unzip p7zip
xbps-install xdg-utils dunst neovim gmrun gksu ranger w3m
xbps-install evince zathura zathura-{cb,pdf-mupdf,ps,djvu} mupdf-tools
xbps-install plasma-workspace-wallpapers paper-gtk-theme paper-icon-theme arc-theme breeze-cursors xcursor-vanilla-dmz
```

#### Go programs
```bash
env CGO_ENABLED=0 GO111MODULE=on go get -u -ldflags="-s -w" github.com/gokcehan/lf
xbps-install file-devel
env GO111MODULE=on go get -u github.com/doronbehar/pistol/cmd/pistol
```

#### Intel GPU hardware acceleration
```bash
xbps-install sysfsutils linux-firmware-intel intel-video-accel mesa-dri vulkan-loader mesa-vulkan-intel 
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

```bash
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh 
```

## Installing JoyPixels fonts

Download JoyPixels TTF font from [Arch Repository](https://www.archlinux.org/packages/community/any/ttf-joypixels/).

Extract the `.ttf` file into `~/.local/share/fonts/`. You may need `xz-utils` installed.

Then do:

```bash
fc-cache -f; sudo fc-cache -f
```

## LightDM brightness

```bash
sudo tee -a /opt/lightdm-brightness > /dev/null <<'EOT'
#! /bin/bash

store() {
    cat "$SYSDIR"/actual_brightness > "$1"
}

restore() {
    MAX=$(cat "$SYSDIR"/max_brightness)
    LIMIT=$((MAX/10))
    if [ -f "$1" ]; then
        VAL=$(cat "$1")
    else
        VAL=$((MAX/2))
    fi
    if [ "$VAL" -lt "$LIMIT" ]; then
        echo "$LIMIT" > "$SYSDIR"/brightness
    else
        echo "$VAL" > "$SYSDIR"/brightness
    fi
}

main() {
    local DATAFILE="/opt/lightdm-last-brightness"
    local SYSDIR="/sys/class/backlight/acpi_video0"
    case "$1" in
        restore) restore $DATAFILE ;;
        store) store $DATAFILE ;;
    esac
}

main "$@"
EOT

sudo chmod 744 /opt/lightdm-brightness
```

Modify `/etc/lightdm/lightdm.conf`:

```bash
[Seat:*]
...
#display-setup-script=
display-setup-script=/opt/lightdm-brightness restore
#display-stopped-script=
display-stopped-script=/opt/lightdm-brightness store
...
#session-setup-script=
session-setup-script=/opt/lightdm-brightness restore
#session-cleanup-script=
session-cleanup-script=/opt/lightdm-brightness store
```

## dbus env variables

Add it to `~/.profile`:

```bash
export $(dbus-launch)
```

## Keyboard layouts

Add it to autostart:

```bash
setxkbmap -layout us,ru -variant -option grp:alt_shift_toggle &
```

## Touchpad

```bash
sudo xbps-install -Su xf86-input-libinput
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
```

## Make `amixer` to work with `pulseaudio`

Add to `/etc/asound.conf`:

```bash
pcm.pulse {
  type pulse
}

ctl.pulse {
  type pulse
}
```

## Disable power button in Void Linux

These settings are needed for Void Linux to allow rofi powerbutton menu.

Modify `/etc/elogind/logind.conf`:

```bash
HandlePowerKey=ignore
```

Modify `/etc/acpi/handler.sh`:

```bash
# shutdown -P now
```

Modify `sudoers`:

```bash
%wheel ALL=(ALL) NOPASSWD:/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/zzz,/usr/bin/ZZZ
```

## vimb adblocking

```bash
sudo xbps-install libglib-devel gtk+3-devel webkit2gtk-devel
git clone https://github.com/jun7/wyebadblock.git
cd wyebadblock
make sudo make install
sudo ln -s /usr/lib/wyebrowser/adblock.so /usr/lib/vimb
```

## Links
- [Openbox Ark Theme](https://github.com/dglava/arc-openbox)
- [Openbox Shiki-Colors](https://github.com/vloup/openbox-shiki-colors-themes)
