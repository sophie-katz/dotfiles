# VirtualBox guest

## Partition table

Mount point | Partition   | Size  | Format | Flags
----------- | ----------- | ----- | ------ | -----------------
`/boot`     | `/dev/sda1` | 100MB | `ext3` | primary, bootable
`/`         | `/dev/sda2` | *     | `ext4` | primary

## Graphics driver

```bash
$ pacman -S xf86-video-vesa
```

## Guest services

[Install VirtualBox guest services](https://wiki.archlinux.org/title/VirtualBox/Install_Arch_Linux_as_a_guest).
 * Make sure to enable `--clipboard` and `--vmsvga`.
 * Enable bidirectional clipboard mode for the VM to make the above work.
