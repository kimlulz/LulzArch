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
		pacman -S --noconfirm wget noto-fonts-cjk sudo grub efibootmgr reflector ibus-hangul systemd-sysvcompat
		reflector --country 'South Korea' --save /etc/pacman.d/mirrorlist
	echo ""
	becho "-2. Set root password"
		passwd
	echo ""
	becho "-3. Set Language to KR"
		sed -i 's/#ko_KR.UTF-8/ko_KR.UTF-8/g' /etc/locale.gen
		locale-gen
		echo LANG=ko_KR.UTF-8 > /etc/locale.conf
		export LANG=en_US.UTF-8
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
		pacman -Syu --noconfirm
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
	sudo pacman -S --noconfirm xorg-xwayland gnome
	sudo systemctl enable gdm
echo ""

becho "6. Install yay and install packages from aur repo"
	pacman -S --noconfirm --needed git base-devel
	cd /opt/
	git clone https://aur.archlinux.org/yay.git
	chown -R $USER:$USRGRP yay
	su - $USER -c "cd /opt/yay; makepkg -si"
	
	becho "Fastfetch.."
		su - $USER -c "yay -S --noconfirm fastfetch; mkdir -p ~/.fastfetch"
		wget https://raw.githubusercontent.com/kimlulz/dotfiles/main/zsh/preset -P /home/$USER/.fastfetch
		echo "PS1='\[\e[0m\][\[\e[0;1;91m\]\u\[\e[0m\]|\[\e[0;1m\]$?\[\e[0m\]] \[\e[0;1;3;4m\]\w\[\e[0m\] \[\e[0;92m\]\$ \[\e[0m\]'" > /home/$USER/.bashrc && echo "fastfetch --load-config .fastfetch/preset" >> /home/$USER/.bashrc
		echo ""
	
	becho "Hyper Terminal.."
		su - $USER -c "yay -S --noconfirm hyper-bin"
		mkdir /home/$USER/.local/share/fonts
		wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /home/$USER/.local/share/fonts
		wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /home/$USER/.local/share/fonts
		wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /home/$USER/.local/share/fonts
		wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /home/$USER/.local/share/fonts
		su - $USER -c "fc-cache -f -v"
		wget https://raw.githubusercontent.com/kimlulz/dotfiles/main/zsh/.hyper.js -P /home/$USER/
		echo ""

	becho "Visual Studio Code.."
	while :; do
		becho "*************************************************"
        becho "(1) Code - OSS | Official Arch Linux open-source release" 
        becho "(2) Visual Studio Code | Proprietary Microsoft-branded release."
        becho "(3) VSCodium | Community open-source release."
        becho "*************************************************"
        becho "[1/2/3] > " ; read VSCD
	
	case $VSCD in
		1) pacman -S --noconfirm code;;
        2) su - $USER -c "yay -S --noconfirm visual-studio-code-bin";;
        3) su - $USER -c "yay -S --noconfirm vscodium";;
		*) echo "Invalid response, try again"; continue;;
    esac; break; done; echo ""

	becho "Zsh.."
		pacman -S --noconfirm zsh
		su - $USER -c "sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended"
		su - $USER -c "chsh -s /usr/bin/zsh"
        su - $USER -c "curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh"
		su - $USER -c "wget https://raw.githubusercontent.com/kimlulz/dotfiles/main/zsh/.zshrc && mv .zshrc /home/$USER/.zshrc"
        su - $USER -c "echo 'fastfetch --load-config .fastfetch/preset' >> /home/$USER/.zshrc"
	echo ""

	becho "Browser.."
	while :; do
        becho "*************************************************"
        becho "(1) Google Chrome | Google Chromium" 
        becho "(2) Chromium | Stable release of Chromium"
        becho "(3) Ungoogled-Chromium | Build | from github"
        becho "(4) Naver Whale | Package | from naver"
        becho "*************************************************"
        becho "[1/2/3/4] > " ; read BRWS
        
	case $BRWS in
		1) su - $USER -c "yay -S --noconfirm google-chrome";;
		2) pacman -S --noconfirm chromium;;
		3) su - $USER -c "yay -S --noconfirm ungoogled-chromium-bin";;
		4) su - $USER -c "yay -S --noconfirm naver-whale-stable";;
		*) echo "Invalid response, try again"; continue;;
    esac; break; done; echo ""
	cd /

rm -rf ./archset.sh
becho "Finished!!"
becho "When Finish, Type exit"
exit

