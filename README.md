# LulzArch

arch-chroot /mnt
pacman -Syu
## Mirrorlist
pacman -S wget
wget https://raw.githubusercontent.com/kimlulz/LulzArch/main/mirrorlist -P /etc/pacman.d

```
##
## Arch Linux repository mirrorlist
## Generated on 2021-03-30
## Country - South Korea
## /etc/pacman.d/mirrorlist
##

## South Korea
Server = http://mirror.anigil.com/archlinux/$repo/os/$arch
Server = https://mirror.anigil.com/archlinux/$repo/os/$arch
Server = http://ftp.harukasan.org/archlinux/$repo/os/$arch
Server = https://ftp.harukasan.org/archlinux/$repo/os/$arch
Server = http://ftp.lanet.kr/pub/archlinux/$repo/os/$arch
Server = https://ftp.lanet.kr/pub/archlinux/$repo/os/$arch
Server = http://mirror.premi.st/archlinux/$repo/os/$arch
Server = https://mirror.premi.st/archlinux/$repo/os/$arch
```
