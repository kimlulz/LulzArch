#!/bin/bash
BL=$(tput bold) # 굵게
NRM=$(tput sgr0) # 일반글씨
RW="\033[41;37m" # 빨간색 배경 글씨
NRW="\033[0m" #일반 배경 글씨

function becho {
	>&2 echo -n "$BL$1$NRM"
	echo ""
}

becho "3. Setting System"
	becho "-1. Init"
		pacman -S noto-fonts-cjk sudo grub efibootmgr reflector ibus-hangul
		reflector --country 'South Korea' --save /etc/pacman.d/mirrorlist
	echo ""
	becho "-2. Set root password"
		passwd
	echo ""
	becho "-3. Set Language to KR"
		sed -i 's/#ko_KR.UTF-8/ko_KR.UTF-8/g' /etc/locale.gen
		locale-gen
		echo LANG=en_US.UTF-8 > /etc/locale.conf
		export LANG=ko_KR.UTF-8
	echo ""
	becho "-4. Change hostname"
		echo -n " > "; read "HOSTNAME"
		echo $HOSTNAME > /etc/hostname
	echo ""
	becho "-5. Change timezone to KR"	
		ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
		hwclock --systohc
	echo ""
	becho "-6. Make Account"	
		USRGRP=users
		echo -n " > "; read "USER"
		useradd -m -g $USRGRP -G wheel -s /bin/bash $USER
		echo "Input password"
		passwd $USER
	becho "-7 Update Packages"
		pacman -Syu
	becho "-7 Update sudoer"
		sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
		echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo ""

becho "4. Install GRUB"
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch --recheck
	grub-mkconfig -o /boot/grub/grub.cfg
	systemctl enable NetworkManager
echo ""

becho "5. Install gnome"
	sudo pacman -S xorg-xwayland gnome gnome-extra
	sudo systemctl enable gdm
echo ""

becho "6. Install yay and some packages"
	pacman -S --needed git base-devel
	cd /opt/
	git clone https://aur.archlinux.org/yay.git
	chown -R $USER:$USRGRP yay
	su - $USER -c "cd /opt/yay; makepkg -si; yay -S naver-whale-stable"
	cd /
echo ""

rm -rf ./archset.sh
becho "Finished!!"

exit
umount -lr /mnt
