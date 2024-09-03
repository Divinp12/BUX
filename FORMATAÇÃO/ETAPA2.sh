#!/bin/bash

echo 4RCH > /etc/hostname;


yes 4RCH | passwd root;


useradd -m -g users -G wheel 4RCH;


yes 4RCH | passwd 4RCH;


echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen;


echo "LANG=pt_BR.UTF-8" > /etc/locale.conf;


locale-gen;


hwclock --systohc;


echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;


echo "alias i='yay -S --noconfirm --quiet'
alias d='sudo pacman -Rsc'
sudo rm -rf /home/4RCH/.bash_history /home/4RCH/.cache /var/log /tmp;
sudo pacman -Syyu --noconfirm --quiet;
sudo pacman -Scc --noconfirm --quiet;
clear;
fastfetch
sudo chmod 777 YAY.sh && ./YAY.sh && sed -i '\$d' /home/4RCH/.bashrc" > /home/4RCH/.bashrc;


echo "[options]
Architecture=auto
CheckSpace
ParallelDownloads=1
SigLevel=Required DatabaseOptional
LocalFileSigLevel=Optional
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist
[multilib]
Include=/etc/pacman.d/mirrorlist
[community]
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf;


pacman -Syyu --noconfirm --quiet;


if lspci | grep -i amd; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon
fi;


if lspci | grep -i intel; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel
fi;


if lspci | grep -i nvidia; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings
fi;


if lspci | grep -i virtualbox; then
pacman -Sy --noconfirm \
virtualbox-guest-utils \
virtualbox-guest-modules-arch;
systemctl enable vboxservice;
fi;


systemctl enable \
NetworkManager \
sddm;


systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd;


mkinitcpio -P;


echo "[Autologin]
Relogin=false
User=4RCH
Session=plasma
EnableWayland=true" > /etc/sddm.conf;


echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"4RCH\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub;


grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=4RCH --recheck;


grub-mkconfig -o /boot/grub/grub.cfg;



mv /mnt/YAY.sh /home/4RCH/;

echo "4RCH ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers;

sed -i "/^\s*#/d; /^\s*$/d" \
/home/4RCH/.bash_profile \
/home/4RCH/.bash_logout \
/etc/sudoers \
/etc/sudo.conf \
/etc/host.conf \
/etc/healthd.conf \
/etc/mkinitcpio.conf \
/etc/libva.conf \
/etc/vconsole.conf \
/etc/fuse.conf \
/etc/ts.conf \
/etc/fstab;

sed -i "/^UUID=.* \/boot .*$/! s/rw/rw,noatime,discard,/" /etc/fstab;

echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 4RCH.localdomain 4RCH" > /etc/hosts;

rm -rf /boot/initramfs-linux-fallback.img /mnt/ETAPA2.sh;
