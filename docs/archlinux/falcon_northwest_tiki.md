# Falcon Northwest Tiki

## Windows 10

First, install Windows 10. Before running the install, open a command prompt with Shift+F10. Make sure to replace `disk 0` with whatever the correct disk index is:

```cmd
> diskpart
diskpart> list disks
diskpart> select disk 0
diskpart> clean
diskpart> convert mbr
```

Close the prompt and then continue the install on the selected disk. Once booted into Windows 10, open up Disk Management and shrink the `C:\` drive down to no less than 40 GB.

## Arch Linux

Create a single EXT4 partition in the first segment of free space created by shrinking the `C:\` drive above. Before running `genfstab` or `arch-chroot` during the install, run:

```bash
$ mkdir -p /mnt/efi
$ mount /dev/sda /mnt/efi
```

When installing grub, also install `os-prober`. You may need to add `GRUB_DISABLE_OS_PROBER=false` to `/etc/grub/default` before running `grub-mkconfig`. If it detects Windows 10, it should be set up correctly.

### Graphics Driver

```bash
$ sudo pacman -S xf86-vide-nouveau
```

Add `nouveau` to the `MODULES` section of `/etc/mkinitcpio.config`.

