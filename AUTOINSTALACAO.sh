#!/bin/bash





if echo "INICIANDO FORMATACAO EM 10 SEGUNDOS,
ESTEJA CIENTE DO QUE ESTA FAZENDO,
POIS TODOS OS DADOS SERAO APAGADOS
PARA QUE A INSTALACAO SEJA BEM SUCEDIDA..."; then
sleep 10; clear
fi;





echo "ADICIONANDO ESPELHO BRASILEIRO"
if echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
echo "ESPELHO BRASILEIRO ADICIONADO COM SUCESSO"
else
echo "ERRO AO ADICIONAR O ESPELHO BRASILEIRO"
fi;





sleep 5;
clear;





echo "SOBSCREVENDO ARQUIVO pacman.conf"
if echo "[options]
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
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf; then
echo "ARQUIVO pacman.conf SOBSCRITO COM SUCESSO"
else
echo "ERRO AO SOBSCREVER ARQUIVO pacman.conf"
fi;





sleep 5;
clear;





echo "SINCRONIZANDO REPOSITORIOS DO PACMAN"
if pacman -Sy --noconfirm --quiet > /dev/null 2>&1 || true; then
echo "REPOSITORIOS DO PACMAN SINCRONIZADOS COM SUCESSO"
else
echo "ERRO AO SINCRONIZAR REPOSITORIOS DO PACMAN"
fi;





sleep 5;
clear;





echo "FORMATANDO DISPOSITIVO DE ARMAZENAMENTO DE DADOS VALIDO"
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




sleep 5;
clear;





echo "INSTALANDO PACOTES DO SISTEMA";
if pacstrap /mnt --noconfirm --quiet \
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
efibootmgr > /dev/null 2>&1 || true; then
echo "PACOTES DO SISTEMA INSTALADOS COM SUCESSO"
else
echo "ERRO AO INSTALAR PACOTES DO SISTEMA"
fi;






sleep 5;
clear;





echo "AUTOGERANDO E AUTOCONFIGURANDO PARTICOES NO ARQUIVO fstab"
if genfstab -U -p /mnt > /mnt/etc/fstab; then
echo "ARQUIVO fstab AUTOGERADO E AUTOCONFIGURADO COM SUCESSO"
else
echo "ERRO AO AUTOGERAR E AUTOCONFIGURAR ARQUIVO fstab"
fi





sleep 5;
clear;





echo "ENTRANDO NO AMBIENTE arch-chroot"
arch-chroot /mnt bash -c '





sleep 5;
clear;





echo "ADICIONANDO NOME 4RCH AO USUARIO ROOT NO ARQUIVO hostname";
if echo 4RCH > /etc/hostname; then
echo "NOME 4RCH DO USUARIO ROOT ADICIONADO NO ARQUIVO hostname COM SUCESSO"
else
echo "ERRO AO ADICIONAR NOME 4RCH AO USUARIO ROOT NO ARQUIVO hostname"
fi





echo -e "4RCH\n4RCH" | passwd root;
useradd -m -g users -G wheel 4RCH;
echo -e "4RCH\n4RCH" | passwd 4RCH;
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen;
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf;
locale-gen;
hwclock --systohc;
echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;
echo "alias i=\"yay -S --noconfirm --quiet\"
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
sudo sed -i \"8,\\\$d\" /home/4RCH/.bashrc" > /home/4RCH/.bashrc;
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
pacman -Sy --noconfirm --quiet;
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
virtualbox-guest-modules-arch
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
echo "4RCH ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers;
sed -i "/^UUID=.* \/boot .*$/! s/rw/rw,noatime,discard,/" /etc/fstab;
echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 4RCH.localdomain 4RCH" > /etc/hosts;
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
rm -rf /boot/initramfs-linux-fallback.img';
sync;
reboot -f;
