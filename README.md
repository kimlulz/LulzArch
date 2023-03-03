# LulzArch

Installation Script of Arch Linux

type `./archinit.sh` to start

1. Make Partition and mount

2. pacstrap and Generate UUID

3. chroot and `archset.sh` 
    1. `wget noto-fonts-cjk sudo grub efibootmgr reflector ibus-hangul` #For Korean Environment
    2. use reflector to change mirror(Korea) 
    3. Set Languages to Korean
    4. Set Hostname, Time Zone, Sudoer(is not working correctly..)
    5. Install GRUB (will have to change `Systemd-boot`
    6. Install Gnome DE
    7. Install YAY and some packages from AUR
        1. Fastfetch (Neofetch, but written in C)
        2. Hyper Terminal
        3. VSCODE
        
        | Name | Description |
        | :- | :- |
        | **Code - OSS** | Official Arch Linux open-source release |
        | **Visual Studio Code** | Proprietary Microsoft-branded release |
        | **VSCodium** | Community open-source release |
        
        4. Zsh (and Customize `.zshrc, .bashrc`)
        5. Browser
        
        | Name | Description |
        | :- | :- |
        | **Google Chrome** | Official from google |
        | **Chromium** | Stable release of Chromium |
        | **Ungoogled-Chromium** | Build from github |
        | **Naver Whale** | Chromium-Based Browsers made by Naver(Korea) |
        
    8. Gnome-Extensions (Not Works)
    9. Remove archset.sh
    10. Type `exit` to finish
4. Unmount 
