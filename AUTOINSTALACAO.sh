#!/bin/bash

clear;

if echo "INICIANDO FORMATACAO EM 15 SEGUNDOS,
ESTEJA CIENTE DO QUE ESTA FAZENDO,
POIS TODOS OS DADOS SERAO APAGADOS
PARA QUE A INSTALACAO SEJA BEM SUCEDIDA..."; then
echo " 1 " && sleep 1 && \
echo " 2 " && sleep 1 && \
echo " 3 " && sleep 1 && \
echo " 4 " && sleep 1 && \
echo " 5 " && sleep 1 && \
echo " 6 " && sleep 1 && \
echo " 7 " && sleep 1 && \
echo " 8 " && sleep 1 && \
echo " 9 " && sleep 1 && \
echo " 10 " && sleep 1 && \
echo " 11 " && sleep 1 && \
echo " 12 " && sleep 1 && \
echo " 13 " && sleep 1 && \
echo " 14 " && sleep 1 && \
echo " 15 " && sleep 1 && clear;
fi;

☆() {
if "$@"; then
echo "PASSOU"
else
echo "FALHOU"
fi;
sleep 3;
clear;
}

echo "ADICIONANDO ESPELHO BRASILEIRO"
☆ echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo "SOBSCREVENDO ARQUIVO pacman.conf"
☆ echo "[options]
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
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf


echo "SINCRONIZANDO REPOSITORIOS DO PACMAN"
☆ pacman -Sy --noconfirm --quiet > /dev/null 2>&1


echo "FORMATANDO DISPOSITIVO DE ARMAZENAMENTO DE DADOS VALIDO"
if parted -s /dev/nvme0n1p mklabel gpt && \
parted -s /dev/nvme0n1p mkpart ESP fat32 1MiB 1025MiB && \
parted -s /dev/nvme0n1p set 1 esp on && \
parted -s /dev/nvme0n1p mkpart primary ext4 1025MiB 30721MiB \
parted -s /dev/nvme0n1p mkpart primary ext4 30721MiB 100% && \
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

parted -s /dev/sda mklabel gpt && \
parted -s /dev/sda mkpart ESP fat32 1MiB 1025MiB && \
parted -s /dev/sda set 1 esp on && \
parted -s /dev/sda mkpart primary ext4 1025MiB 30721MiB && \
parted -s /dev/sda mkpart primary ext4 30721MiB 100% && \
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


sleep 3;
clear;


echo "INSTALANDO PACOTES DO SISTEMA"
☆ pacstrap /mnt --noconfirm --quiet \
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
plasma \
wayland \
lib32-wayland \
xorg-xwayland \
foot \
pulseaudio \
pavucontrol \
grub-efi-x86_64 \
efibootmgr > /dev/null 2>&1


echo "AUTOGERANDO E AUTOCONFIGURANDO PARTICOES NO ARQUIVO fstab"
☆ genfstab -U -p /mnt > /mnt/etc/fstab


echo "ENTRANDO NO AMBIENTE arch-chroot"
arch-chroot /mnt bash -c '

☆() {
if "$@"; then
echo "PASSOU"
else
echo "FALHOU"
fi;
sleep 3;
clear;
}


echo "ADICIONANDO NOME 4RCH AO USUARIO ROOT NO ARQUIVO hostname";
☆ echo 4RCH > /etc/hostname


echo "ADICIONANDO SENHA 4RCH AO USUARIO ROOT"
☆ echo -e "4RCH\n4RCH" | passwd root


echo "ADICIONANDO USUARIO NORMAL COM NOME 4RCH"
☆ useradd -m -g users -G wheel 4RCH


echo "ADICIONANDO SENHA 4RCH AO USUARIO NORMAL"
☆ echo -e "4RCH\n4RCH" | passwd 4RCH


echo "ADICIONANDO CARACTERES PORTUGUES BRASILEIRO"
☆ echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen


echo "APLICANDO IDIOMA PORTUGUES BRASILEIRO NO SISTEMA"
☆ echo "LANG=pt_BR.UTF-8" > /etc/locale.conf


echo "APLICANDO CARACTERES PORTUGUES BRASILEIRO"
☆ locale-gen > /dev/null 2>&1


echo "SINCRONIZANDO RELOGIO DO HARDWARE E DO SISTEMA VIA WIFI"
☆ hwclock --systohc > /dev/null 2>&1


echo "ADICIONANDO ESPELHO BRASILEIRO"
☆ echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist


echo "SOBSCREVENDO ARQUIVO .bashrc"
☆ echo "alias i=\"yay -S --noconfirm --quiet\";
alias d=\"sudo pacman -Rsc\";
alias a=\"sudo pacman -Syyu --noconfirm --quiet\";
alias m=\"pacman -Q\";
alias w=\"nmtui\";
sudo rm -rf /home/4RCH/.bash_history;
sudo pacman -Scc --noconfirm --quiet;
clear;
sudo sleep 1;
fastfetch;
echo \"
INFORMAÇÕES DE PACOTES:
INSTALAR PACOTES (i nome-do-pacote)
DESISTALAR PACOTES (d nome-do-pacote)
ATUALIZAR PACOTES (a nome-do-pacote ou apenas a para todos)
MOSTRA PACOTES INSTALADOS (m nome-do-pacote ou apenas m para todos)
EXEMPLO: i google-chrome

INFORMAÇÕES DE DRIVERS:
CONECTAR A REDE WIFI COM OU SEM FIO (w)
\";
git clone https://aur.archlinux.org/yay.git && \\
chmod 777 yay && \\
cd yay && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf yay && \\
yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake && \\
sudo sed -i \"22,\\\$d\" /home/4RCH/.bashrc" > /home/4RCH/.bashrc


echo "SOBSCREVENDO ARQUIVO pacman.conf"
☆ echo "[options]
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
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf


echo "SINCRONIZANDO REPOSITORIOS DO PACMAN"
☆ pacman -Sy --noconfirm --quiet > /dev/null 2>&1


echo "ESCANEANDO HARDWARE AMD E INSTALANDO DRIVERS AMD"
if lspci | grep -i amd > /dev/null 2>&1; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon > /dev/null 2>&1
else
echo "FALHOU :("
fi;


sleep 3;
clear


echo "ESCANEANDO HARDWARE INTEL E INSTALANDO DRIVERS INTEL"
if lspci | grep -i intel > /dev/null 2>&1; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel > /dev/null 2>&1
else
echo "FALHOU :("
fi;


sleep 3;
clear


echo "ESCANEANDO HARDWARE NVIDIA E INSTALANDO DRIVERS NVIDIA"
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings > /dev/null 2>&1
else
echo "FALHOU :("
fi;


sleep 3;
clear


echo "HABILITANDO DRIVER DE INTERNET NA INICIALIZACAO DO SISTEMA"
☆ systemctl enable NetworkManager > /dev/null 2>&1


echo "DESATIVANDO SERVICOS DESNECESSARIOS NA INICIALIZACAO DO SISTEMA"
☆ systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd > /dev/null 2>&1


echo "GERANDO IMAGENS NO INICIALIZADOR DO SISTEMA"
☆ mkinitcpio -P > /dev/null 2>&1


echo "SOBSCREVENDO ARQUIVO grub"
☆ echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"BUX\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet loglevel=0 panic=0 mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub


echo "CONFIGURANDO GRUB"
☆ grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=. --recheck > /dev/null 2>&1


echo "ADICIONANDO GRUB NA INICIALIZACAO"
☆ grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1


echo "ADICIONANDO USUARIO NORMAL (4RCH) AO SUDO NO ARQUIVO sudoers"
☆ echo "4RCH ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers


echo "ADICIONANDO CONEXAO IPV6 NO SISTEMA"
☆ echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 4RCH.localdomain 4RCH" > /etc/hosts


echo "REMOVENDO LINHAS QUE COMECAM COM JOGO DA VELHA E ESPACOS VAZIOS"
☆ sed -i "/^\s*#/d; /^\s*$/d" \
/home/4RCH/.bash_profile \
/home/4RCH/.bash_logout \
/etc/environment \
/etc/gai.conf \
/etc/sudoers \
/etc/sudo.conf \
/etc/host.conf \
/etc/healthd.conf \
/etc/mkinitcpio.conf \
/etc/libva.conf \
/etc/vconsole.conf \
/etc/fuse.conf \
/etc/ts.conf \
/etc/fstab


echo "ADICIONANDO AUTOSTART DO XFCE"
☆ echo "startplasma-wayland > /dev/null 2>&1" > /home/4RCH/.bash_profile


echo "ADICIONANDO AUTOLOGIN DO TTY1"
☆ echo "[Unit]
After=systemd-user-sessions.service plymouth-quit-wait.service
Before=getty.target

[Service]
ExecStart=-/usr/bin/agetty --autologin 4RCH --noclear tty1 linux
Type=idle
Restart=always
RestartSec=0
UtmpIdentifier=tty1
TTYPath=/dev/tty1
TTYReset=yes
TTYVHangup=yes
StandardInput=tty
StandardOutput=tty

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/L.service


echo "HABILITANDO AUTOLOGIN NA INICIALIZAÇÃO"
☆ systemctl enable L.service'


sleep 3;
clear;


echo "GRAVANDO DADOS DA MEMORIA NO DISCO"
☆ sync > /dev/null 2>&1


echo "REINICIANDO"
reboot -f;
