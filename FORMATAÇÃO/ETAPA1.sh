#!/bin/bash

echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;


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


if fdisk /dev/nvme0n1; then <<EOF
o
w
EOF
fdisk /dev/nvme0n1 <<EOF
n
p
1

+2G
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

+2G
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
plasma-desktop \
kscreen \
foot \
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


mv 4RCH*/FORMATAÇÃO/ETAPA2.sh /mnt;


chmod 777 /mnt/ETAPA2.sh;


arch-chroot /mnt bash -c 'echo 4RCH > /etc/hostname';


arch-chroot /mnt bash -c 'echo -e "4RCH\n4RCH" | passwd root';


arch-chroot /mnt bash -c 'useradd -m -g users -G wheel 4RCH';


arch-chroot /mnt bash -c "echo -e '4RCH\n4RCH' | passwd 4RCH";


arch-chroot /mnt bash -c 'echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen';


arch-chroot /mnt bash -c 'echo "LANG=pt_BR.UTF-8" > /etc/locale.conf';


arch-chroot /mnt bash -c 'locale-gen';


arch-chroot /mnt bash -c 'hwclock --systohc';


arch-chroot /mnt bash -c 'echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist';


arch-chroot /mnt bash -c 'echo "alias i=\"yay -S --noconfirm --quiet\"
alias d=\"sudo pacman -Rsc\"
sudo rm -rf /home/4RCH/.bash_history /home/4RCH/.cache /var/log /tmp;
sudo pacman -Syyu --noconfirm --quiet;
sudo pacman -Scc --noconfirm --quiet;
clear;
fastfetch
git clone https://aur.archlinux.org/yay.git && \\
chmod 777 yay && \\
cd yay && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf yay && \\
yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake && \\
sed -i \"8,\\$d\" /home/4RCH/.bashrc" > /home/4RCH/.bashrc';


arch-chroot /mnt bash -c 'echo "[options]
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
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf';


arch-chroot /mnt bash -c 'pacman -Syyu --noconfirm --quiet';


arch-chroot /mnt bash -c 'if lspci | grep -i amd; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon
fi';


arch-chroot /mnt bash -c 'if lspci | grep -i intel; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel
fi';


arch-chroot /mnt bash -c 'if lspci | grep -i nvidia; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings
fi';


arch-chroot /mnt bash -c 'if lspci | grep -i virtualbox; then
pacman -Sy --noconfirm \
virtualbox-guest-utils \
virtualbox-guest-modules-arch;
fi';


arch-chroot /mnt bash -c 'systemctl enable \
NetworkManager \
sddm';


arch-chroot /mnt bash -c 'systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd';


arch-chroot /mnt bash -c 'mkinitcpio -P';


arch-chroot /mnt bash -c 'echo "[Autologin]
Relogin=false
User=4RCH
Session=plasma
EnableWayland=true" > /etc/sddm.conf';


arch-chroot /mnt bash -c 'echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"4RCH\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub';


arch-chroot /mnt bash -c 'grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=4RCH --recheck';


arch-chroot /mnt bash -c 'grub-mkconfig -o /boot/grub/grub.cfg';


arch-chroot /mnt ./ETAPA2.sh;


sync;


reboot -f;
