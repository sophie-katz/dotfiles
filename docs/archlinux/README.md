# Instructions for installing Arch Linux setup

Specific instructions for different hardware/virtualized setups:
 * [Falcon Northwest Tiki](falcon_northwest_tiki.md)
 * [VirtualBox Guest](virtualbox_guest.md)

## Base install

First, [download the Arch Linux ISO](https://archlinux.org/download) and optionally burn it to a flash drive if installing on bare metal hardware. Once booted, follow the [installation guide](https://wiki.archlinux.org/title/Installation_guide). A few notes:
 * See the specific instructions above for partition table details.
 * `vim` is a highly useful package to install at this point.
 * Use the hostname convention of `Sophie*` for different devices (i.e. `SophieDesktop` or `SophieMacbookPro`).

Install packages to get networking up:

```bash
$ pacman -S dhcpcd
```

Enable `dhcpcd` and networking:

```bash
$ systemctl enable dhcpcd systemd-networkd
```

[Install grub](https://wiki.archlinux.org/title/GRUB), then reboot onto the local machine. Use the "boot existing OS" option on the live boot to save time in case a reinstall is needed.

## Post-install setup

### Packages

First, update the system:

```bash
$ pacman -Syy
$ pacman -Syu
```

Then, install the following packages:

```bash
$ pacman -S \
  vi \
  vim \
  sudo \
  xorg-server \
  xorg-xinit \
  ttf-dejavu \
  ttc-iosevka \
  i3-wm \
  rxvt-unicode \
  dmenu \
  i3status \
  git \
  base-devel
```

### Sudo

Enable `wheel` with password:

```bash
$ visudo
```

Add the user `sophie` and add her to the group `wheel`. Logout as root and then log back in as `sophie` once `sudo` is tested with `su sophie`.

### Home directory

Run the following command from `sophie`'s home directory:

```bash
$ mkdir \
  art \
  code \
  documents \
  downloads \
  pictures
```

Clone this repository into `~/code`.

### Xinit/Startx/I3

 * See the specific instructions above for graphics driver setup details.
 * Link [`/home/sophie/.xinitrc`](/home/sophie/.xinitrc) from this repo to `~/.xinitrc`.
 * Link [`/home/sophie/.Xresources`](/home/sophie/.Xresources) from this repo to `~/.Xresources`.
 * Link [`/home/sophie/.config/i3/config`](/home/sophie/.config/i3/config) from this repo to `~/.config/i3/config`.
 * Link [`/home/sophie/.config/i3status/config`](/home/sophie/.config/i3status/config) from this repo to `~/.config/i3status/config`.

Run `startx` to test it out.

### Yay

[Install `yay`](https://github.com/Jguer/yay).
 * Make sure to clone it into `~/downloads/yay`.

Then, install AUR packages:
```bash
$ yay -S \
  1password \
  discord \
  google-chrome \
  spotify \
  visual-studio-code-bin
```
