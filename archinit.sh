#!/bin/bash
BL=$(tput bold) # 굵게
NRM=$(tput sgr0) # 일반글씨
RW="\033[41;37m" # 빨간색 배경 글씨
NRW="\033[0m" #일반 배경 글씨

function becho {
	>&2 echo -n "$BL$1$NRM"
	echo ""
}

function ach {
	>&2 arch-chroot /mnt $1
	echo ""
}

becho "1. Make Partition Table... "
	becho "-1. Select Disk ex)sda / nvme0n1"
		becho "**************************"
				lsblk
		becho "**************************"
		echo -n " > "; read "seldisk"
		cfdisk /dev/$seldisk

	becho "-2. Format ex)sda1 / nvme0n1p1"
		becho "***** [/boot] *****"
				lsblk
		becho "**************************"
		echo -n " > "; read "selboot"
		mkfs.xfs -f /dev/$selboot
		echo ""

		becho "***** [/boot/efi] *****"
				lsblk
		becho "**************************"
		echo -n " > "; read "selefi"
		mkfs.vfat -F32 /dev/$selefi
		echo ""

		becho "***** [/] *****"
				lsblk
		becho "**************************"
		echo -n " > "; read "selroot"
		mkfs.xfs -f /dev/$selroot
		echo ""
		
		becho "***** [swap] *****"
				lsblk
		becho "**************************"
		becho "If you do not need a swap partition, enter n or N"
		echo -n " > "; read "selswap"
		if [ $selswap = "n" -o $selswap = "N" ]; then
			echo "Pass"
		else
			mkswap /dev/$selswap
			swapon /dev/$selswap
		fi
		echo ""


	becho "-3 Mount"
		becho "Mount root"
		mount /dev/$selroot /mnt

		becho "Mount /boot"
		mkdir /mnt/boot
		mount /dev/$selboot /mnt/boot

		becho "Mount /boot/efi"
		mkdir /mnt/boot/efi
		mount /dev/$selefi /mnt/boot/efi	
echo ""

becho "2. Init System"
	pacstrap /mnt base linux-zen linux-zen-headers linux-firmware nano networkmanager base-devel man-db man-pages texinfo dosfstools e2fsprogs
	genfstab -U /mnt >> /mnt/etc/fstab
echo ""

becho "3. Copy for setting on chroot"
becho "Type ./archset.sh"
becho "When Finish, Type exit"
	if [ -f ./archset.sh ]; then
		cp ./archset.sh /mnt
		arch-chroot /mnt
	else
		pacman -S wget
		wget https://raw.githubusercontent.com/kimlulz/lulzarch/main/archset.sh
		cp ./archset.sh /mnt
		arch-chroot /mnt
	fi
#arch-chroot /mnt /archset.sh
becho "Unmount..."
umount -lr /mnt
becho "Finished!!"
