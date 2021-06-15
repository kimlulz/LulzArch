# LulzArch
## Base Installation
### Before Install
`ls /sys/firmware/efi` to verify UEFI installation
### Check internet connection
`ping -c 3 www.google.com` Check internet connection

if u need to connect Wi-Fi
```
iwctl
device list
station [device name - Ex. wlan0] scan
station wlan0 get-networks
station wlan0 connect [SSID Name]    
exit
```
### Configure partition
`lsblk` to see device list.    
Give an example of /dev/sdc as target,   
`cfdisk /dev/sdc`   
Select GPT (It does not appear if the device has been previously initialized.)    
```
*** EXAMPLE ***
/dev/sdc1   512MB   EFI System
/dev/sdc2   120GB   Linux filesystem
```
Write and Quit. 
```
mkfs.vfat -F32 /dev/sdc1 // Format EFI partition as FAT32   
mkfs.ext4 -j /dev/sdc2 // Format root partion as EXT4   
mount /dev/sdc2 /mnt // Mount root partition
mkdir /mnt/boot // Make boot directory
mount /dev/sda1 /mnt/boot // Mount efi partition
```
### Install base packages
Essential - base linux linux-firmware     
Choice - nano/vim networkmanager/dhcpd     
`pacstrap /mnt base linux linux-firmware nano networkmanager base-devel man-db man-pages texinfo dosfstools e2fsprogs`    
### Generate UUID
`genfstab -U /mnt >> /mnt/etc/fstab`   

## Arch-chroot
`arch-chroot /mnt`  
### Setting profiles
`ping -c 3 www.google.com` Check internet connection    
`passwd` to set root password    
`nano -w /etc/locale.gen` uncomment what u using (Ex. ko_KR.UTF-8)    
`locale-gen`   
`echo LANG=ko_KR.UTF-8 > /etc/locale.conf`    
`export LANG=en_US.UTF-8`    
`echo [PC name] > /etc/hostname`    
`ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime` set localtime
`hwclock --systohc`    
`useradd -m -g users -G wheel -s /bin/bash [username]`     
`passwd [username]`     
`pacman -Syu`   
`pacman -S sudo`    
`EDITOR=nano visudo` to setting sudo
```
// uncomment below
## Uncomment to allow members of group wheel to execute any command
%wheel ALL= 
```
### Install bootloader (Grub, EFIBootloader)
```
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch --recheck
grub-mkconfig -o /boot/grub/grub.cfg
### exit
systemctl enable NetworkManager
exit
umount -lr /mnt
reboot
```

## BOOT
### Mirrorlist
`reflector --country 'South Korea' --save /etc/pacman.d/mirrorlist`

### Install DE and reboot
```
pacman -S --needed xorg sddm
pacman -S --needed plasma kde-applications
sudo systemctl enable sddm
sudo systemctl enable NetworkManager
```
`sudo nano /usr/lib/sddm/sddm.conf.d/default.conf`    
```
[Theme]
# current theme name
 Current=breeze
 ```
 `reboot`    
