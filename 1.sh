#!/bin/bash

### REMOVER E ADICIONAR ESPELHO BRASILEIRO
echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;

echo "[options]
Architecture=auto
CheckSpace
ParallelDownloads=10
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

pacman -Syy --noconfirm;

if fdisk /dev/nvme0n1; then <<EOF
o
w
EOF
fdisk /dev/nvme0n1 <<EOF
n
p
1

+1G
t
4
w
EOF
fdisk /dev/nvme0n1 <<EOF
n
p
2

+30G
w
EOF
fdisk /dev/nvme0n1 <<EOF
n
p
3


w
EOF
partprobe;
mkfs.fat -F32 /dev/nvme0n1p1;
mkfs.ext4 -F /dev/nvme0n1p2;
mkfs.ext4 -F /dev/nvme0n1p3;
mount /dev/nvme0n1p2 /mnt;
mkdir /mnt/boot;
mkdir /mnt/boot/EFI;
mkdir /mnt/home;
mount /dev/nvme0n1p1 /mnt/boot/EFI;
mount /dev/nvme0n1p3 /mnt/home;
else
fdisk /dev/sda <<EOF
o
w
EOF
fdisk /dev/sda <<EOF
n
p
1

+1G
t
4
w
EOF
fdisk /dev/sda <<EOF
n
p
2

+30G
w
EOF
fdisk /dev/sda <<EOF
n
p
3


w
EOF
partprobe;
mkfs.fat -F32 /dev/sda1;
mkfs.ext4 -F /dev/sda2;
mkfs.ext4 -F /dev/sda3;
mount /dev/sda2 /mnt;
mkdir /mnt/boot;
mkdir /mnt/boot/EFI;
mkdir /mnt/home;
mount /dev/sda1 /mnt/boot/EFI;
mount /dev/sda3 /mnt/home;
fi;

pacstrap /mnt --noconfirm \
base \
base-devel \
linux \
linux-firmware \
linux-headers \
networkmanager \
sudo \
git \
fastfetch \
mesa \
lib32-mesa \
mesa-vdpau \
lib32-mesa-vdpau \
libva-mesa-driver \
lib32-libva-mesa-driver \
vulkan-icd-loader \
lib32-vulkan-icd-loader \
vulkan-validation-layers \
lib32-vulkan-validation-layers \
vulkan-mesa-layers \
lib32-vulkan-mesa-layers \
vulkan-headers \
xfce4-panel \
xfce4-settings \
xfce4-session \
xfce4-terminal \
xfwm4 \
xfdesktop \
wayland \
lib32-wayland \
pipewire \
pipewire-pulse \
pipewire-media-session \
pavucontrol \
sddm \
grub-efi-x86_64 \
efibootmgr;

genfstab -U -p /mnt > /mnt/etc/fstab;

mv ZL/2.sh /mnt;
chmod 777 /mnt/2.sh;
arch-chroot /mnt ./2.sh;

sync;

reboot;
