#!/bin/bash

clear;

if echo "INICIANDO FORMATACAO EM 10 SEGUNDOS,
ESTEJA CIENTE DO QUE ESTA FAZENDO,
POIS TODOS OS DADOS SERAO APAGADOS
PARA QUE A INSTALACAO SEJA BEM SUCEDIDA..."; then
sleep 10; clear
fi;


echo "ADICIONANDO ESPELHO DA FUNDAÇÃO LINUX"
if echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
echo "PASSOU :)"
else
echo "FALHOU :("
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
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "SINCRONIZANDO REPOSITORIOS DO PACMAN"
if pacman -Sy --noconfirm --quiet > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "FORMATANDO DISPOSITIVO DE ARMAZENAMENTO DE DADOS VALIDO"
if fdisk /dev/nvme0n1 > /dev/null 2>&1; then <<EOF > /dev/null 2>&1
o
w
EOF

fdisk /dev/nvme0n1 <<EOF > /dev/null 2>&1
n
p
1

+2G
t
4
w
EOF

fdisk /dev/nvme0n1 <<EOF > /dev/null 2>&1
n
p
2

+30G
w
EOF

fdisk /dev/nvme0n1 <<EOF > /dev/null 2>&1
n
p
3


w
EOF

partprobe > /dev/null 2>&1
mkfs.fat -F32 /dev/nvme0n1p1 > /dev/null 2>&1
mkfs.ext4 -F /dev/nvme0n1p2 > /dev/null 2>&1
mkfs.ext4 -F /dev/nvme0n1p3 > /dev/null 2>&1
mount /dev/nvme0n1p2 /mnt > /dev/null 2>&1
mkdir /mnt/boot > /dev/null 2>&1
mkdir /mnt/boot/EFI > /dev/null 2>&1
mkdir /mnt/home > /dev/null 2>&1
mount /dev/nvme0n1p1 /mnt/boot/EFI > /dev/null 2>&1
mount /dev/nvme0n1p3 /mnt/home > /dev/null 2>&1

else

fdisk /dev/sda <<EOF > /dev/null 2>&1
o
w
EOF

fdisk /dev/sda <<EOF > /dev/null 2>&1
n
p
1

+2G
t
4
w
EOF

fdisk /dev/sda <<EOF > /dev/null 2>&1
n
p
2

+30G
w
EOF

fdisk /dev/sda <<EOF > /dev/null 2>&1
n
p
3


w
EOF

partprobe > /dev/null 2>&1
mkfs.fat -F32 /dev/sda1 > /dev/null 2>&1
mkfs.ext4 -F /dev/sda2 > /dev/null 2>&1
mkfs.ext4 -F /dev/sda3 > /dev/null 2>&1
mount /dev/sda2 /mnt > /dev/null 2>&1
mkdir /mnt/boot > /dev/null 2>&1
mkdir /mnt/boot/EFI > /dev/null 2>&1
mkdir /mnt/home > /dev/null 2>&1
mount /dev/sda1 /mnt/boot/EFI > /dev/null 2>&1
mount /dev/sda3 /mnt/home > /dev/null 2>&1
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
xfce4-panel \
xfce4-session \
xfce4-settings \
xfce4-terminal \
xfwm4 \
xfdesktop \
wayland \
pulseaudio \
pavucontrol \
grub-efi-x86_64 \
efibootmgr > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "AUTOGERANDO E AUTOCONFIGURANDO PARTICOES NO ARQUIVO fstab"
if genfstab -U -p /mnt > /mnt/etc/fstab; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ENTRANDO NO AMBIENTE arch-chroot"
arch-chroot /mnt bash -c '


sleep 5;
clear;


echo "ADICIONANDO NOME 4RCH AO USUARIO ROOT NO ARQUIVO hostname";
if echo 4RCH > /etc/hostname; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO SENHA 4RCH AO USUARIO ROOT"
if echo -e "4RCH\n4RCH" | passwd root; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO USUARIO NORMAL COM NOME 4RCH"
if useradd -m -g users -G wheel 4RCH; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO SENHA 4RCH AO USUARIO NORMAL"
if echo -e "4RCH\n4RCH" | passwd 4RCH; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO CARACTERES PORTUGUES BRASILEIRO"
if echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "APLICANDO IDIOMA PORTUGUES BRASILEIRO NO SISTEMA"
if echo "LANG=pt_BR.UTF-8" > /etc/locale.conf; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "APLICANDO CARACTERES PORTUGUES BRASILEIRO"
if locale-gen > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "SINCRONIZANDO RELOGIO DO HARDWARE E DO SISTEMA VIA WIFI"
if hwclock --systohc > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO ESPELHO DA FUNDAÇÃO LINUX"
if echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "SOBSCREVENDO ARQUIVO .bashrc"
if echo "alias i=\"yay -S --noconfirm --quiet\"
alias d=\"sudo pacman -Rsc\"
sudo rm -rf /home/4RCH/.bash_history;
sudo pacman -Syyu --noconfirm --quiet;
sudo pacman -Scc --noconfirm --quiet;
clear;
sudo sleep 1;
fastfetch;
echo \"
INSTALAR PACOTES (i nome-do-pacote)
DESISTALAR PACOTES (d nome-do-pacote)
EXEMPLO: i google-chrome
\";
git clone https://aur.archlinux.org/yay.git && \\
chmod 777 yay && \\
cd yay && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf yay && \\
yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake && \\
sudo sed -i \"14,\\\$d\" /home/4RCH/.bashrc" > /home/4RCH/.bashrc; then
echo "PASSOU :)"
else
echo "FALHOU :("
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
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "SINCRONIZANDO REPOSITORIOS DO PACMAN"
if pacman -Sy --noconfirm --quiet > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ESCANEANDO HARDWARE AMD E INSTALANDO DRIVERS AMD"
if lspci | grep -i amd > /dev/null 2>&1; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon > /dev/null 2>&1
else
echo "ERRO AO INSTALAR DRIVERS AMD"
fi;


sleep 5;
clear;


echo "ESCANEANDO HARDWARE INTEL E INSTALANDO DRIVERS INTEL"
if lspci | grep -i intel > /dev/null 2>&1; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel > /dev/null 2>&1
else
echo "ERRO AO INSTALAR DRIVERS INTEL"
fi;


sleep 5;
clear;


echo "ESCANEANDO HARDWARE NVIDIA E INSTALANDO DRIVERS NVIDIA"
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings > /dev/null 2>&1
else
echo "ERRO AO INSTALAR DRIVERS NVIDIA"
fi;


sleep 5;
clear;


echo "ESCANEANDO HARDWARE VIRTUALBOX E INSTALANDO DRIVERS VIRTUALBOX"
if lspci | grep -i virtualbox > /dev/null 2>&1; then
pacman -Sy --noconfirm \
virtualbox-guest-utils \
virtualbox-guest-modules-arch > /dev/null 2>&1
else
echo "ERRO AO INSTALAR DRIVERS VIRTUALBOX"
fi;


sleep 5;
clear;


echo "HABILITANDO DRIVER DE INTERNET NA INICIALIZACAO DO SISTEMA"
if systemctl enable \
NetworkManager > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "DESATIVANDO SERVICOS DESNECESSARIOS NA INICIALIZACAO DO SISTEMA"
if systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "GERANDO IMAGENS NO INICIALIZADOR DO SISTEMA"
if mkinitcpio -P > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "SOBSCREVENDO ARQUIVO grub"
if echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"4RCH\"
GRUB_CMDLINE_LINUX=\"quiet mitigations=off loglevel=0\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "CONFIGURANDO GRUB"
if grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=4RCH --recheck > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO GRUB NA INICIALIZACAO"
if grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO USUARIO NORMAL (4RCH) AO SUDO NO ARQUIVO sudoers"
if echo "4RCH ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO OPÇÕES NOATIME E DISCARD NAS PARTIÇÕES EXT4"
if sed -i "/^UUID=.* \/boot .*$/! s/rw/rw,noatime,discard/" /etc/fstab; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO CONEXAO IPV6 NO SISTEMA"
if echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 4RCH.localdomain 4RCH" > /etc/hosts; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "REMOVENDO LINHAS QUE COMECAM COM JOGO DA VELHA E ESPACOS VAZIOS"
if sed -i "/^\s*#/d; /^\s*$/d" \
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
/etc/fstab; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "HABILITANDO AUTOLOGIN DO TTY1"
if sed -i "s/^ExecStart=.*/ExecStart=-\/sbin\/agetty --autologin 4RCH --noclear \%I \$TERM/" /etc/systemd/system/getty@tty1.service; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "ADICIONANDO AUTOSTART DO XFCE"
if echo "exec startxfce4" > /home/4RCH/.bash_profile; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;'


sleep 5;
clear;


echo "GRAVANDO DADOS DA MEMORIA NO DISCO"
if sync > /dev/null 2>&1; then
echo "PASSOU :)"
else
echo "FALHOU :("
fi;


sleep 5;
clear;


echo "REINICIANDO"
reboot -f;
