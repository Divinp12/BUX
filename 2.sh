#!/bin/bash

### CRIAR USUARIO ROOT COM NOME DE "z"
echo z > /etc/hostname;





### CRIAR SENHA COM NOME DE "z" DO USUÁRIO ROOT
yes z | passwd root;





### CRIAR USUÁRIO NORMAL COM NOME DE "z"
useradd -m -g users -G wheel z;





### CRIAR SENHA COM NOME DE "z" DO USUARIO NORMAL
yes z | passwd z;





### REMOVER E ADICIONAR NOVO PARAMETRO DE IDIOMA, DATA, HORARIO E FUSO HORARIO PARA NACIONALIDADE BRASILEIRA
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen;





### REMOVER E ADICIONAR NOVO PARAMETRO DE LOCALIZAÇÃO PARA BRASILERA
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf;





### ATUALIZAR ARQUIVO DE CONFIGURAÇÕES REGIONAIS
locale-gen;





### SINCRONIZAR E ATUALIZAR RELOGIO
hwclock --systohc;





### SOBRESCREVER ARQUIVO "mirrorlist" EM "/etc/pacman.d"
echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;





### SOBRESCREVER ARQUIVO ".bashrc" EM "/mnt/home/z"
echo "alias i='yay -S --noconfirm --quiet'
alias d='sudo pacman -Rsc'
sudo rm -rf /home/z/.bash_history;
sudo rm -rf /home/z/.cache;
sudo rm -rf /var/log;
sudo rm -rf /tmp;
sudo pacman -Syyu --noconfirm --quiet;
sudo pacman -Scc --noconfirm --quiet;
clear;
fastfetch
git clone https://aur.archlinux.org/yay.git && sudo chmod 777 yay && cd yay && makepkg -si --noconfirm && cd .. && sudo rm -rf yay && yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake && sed -i '\$d' /home/z/.bashrc" > /home/z/.bashrc;





### SOBRESCREVER ARQUIVO "pacman.conf" EM "/etc"
echo "[options]
Architecture=auto
CheckSpace
ParallelDownloads=5
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





### SINCRONIZAR ESPELHO E ATUALIZAR PACOTES
pacman -Syyu --noconfirm --quiet;





### INSTALAR DRIVERS AMD
if lspci | grep -i amd; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon
fi;





### INSTALAR DRIVERS INTEL
if lspci | grep -i intel; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel
fi;





### INSTALAR DRIVERS NVIDIA
if lspci | grep -i nvidia; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings
fi;





### INSTALAR DRIVERS VIRTUALBOX
if lspci | grep -i virtualbox; then
pacman -Sy --noconfirm \
virtualbox-guest-utils \
virtualbox-guest-modules-arch;
systemctl enable vboxservice;
fi;





### HABILITAR AUTOINICIALIZACAO DE SERVICOS
systemctl enable \
NetworkManager \
sddm;





### DESABILITAR AUTOINICIALIZACAO DE SERVICOS
systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd;





### RECONSTRUIR IMAGEM DO INITRAMFS USANDO CONFIGURACOES PADRAO DEFINIDAS PARA O PROCESSO DE INICIALIZACAO DO SISTEMA
mkinitcpio -P;





### SOBRESCREVER ARQUIVO "sddm.conf" EM "/etc"
echo "[Autologin]
Relogin=false
User=z
Session=xfce
EnableWayland=true" > /etc/sddm.conf;





### SOBRESCREVER ARQUIVO "grub" EM "/etc/default"
echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"z\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub;





### INSTALAR GRUB
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=z --recheck;





### GERAR UM NOVO ARQUIVO DE CONFIGURACAO PARA O GRUB
grub-mkconfig -o /boot/grub/grub.cfg;





### CONFIGURACOES ADICIONAIS
echo "z ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers;
sed -i "/^\s*#/d; /^\s*$/d" \
/home/z/.bash_profile \
/home/z/.bash_logout \
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
127.0.0.1 z.localdomain z" > /etc/hosts;
rm -rf /boot/initramfs-linux-fallback.img;
rm -rf 2.sh;
