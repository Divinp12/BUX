#!/bin/bash

clear;

echo "adicionando espelho brasileiro";
if echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "sobscrevendo arquivo pacman.conf";
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
echo ""
else
echo "FALHOU" && exit
fi;


echo "sincronizando repositorios do pacman";
if pacman -Sy --noconfirm > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "formatando 1 disco rigido valido";
if wipefs -a /dev/nvme0n1p > /dev/null 2>&1; then
parted -s /dev/nvme0n1p mklabel gpt && \
parted -s /dev/nvme0n1p mkpart ESP fat32 1MiB 500MiB && \
parted -s /dev/nvme0n1p set 1 esp on && \
parted -s /dev/nvme0n1p mkpart primary ext4 500MiB 30000MiB && \
parted -s /dev/nvme0n1p mkpart primary ext4 30000MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 /dev/nvme0n1p1 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/nvme0n1p2 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/nvme0n1p3 > /dev/null 2>&1 && \
mount /dev/nvme0n1p2 /mnt > /dev/null 2>&1 && \
mkdir /mnt/boot > /dev/null 2>&1 && \
mkdir /mnt/boot/EFI > /dev/null 2>&1 && \
mkdir /mnt/home > /dev/null 2>&1 && \
mount /dev/nvme0n1p1 /mnt/boot/EFI > /dev/null 2>&1 && \
mount /dev/nvme0n1p3 /mnt/home > /dev/null 2>&1 && \
echo ""

else

wipefs -a /dev/sda > /dev/null 2>&1 && \
parted -s /dev/sda mklabel gpt && \
parted -s /dev/sda mkpart ESP fat32 1MiB 500MiB && \
parted -s /dev/sda set 1 esp on && \
parted -s /dev/sda mkpart primary ext4 500MiB 30000MiB && \
parted -s /dev/sda mkpart primary ext4 30000MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 /dev/sda1 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/sda2 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/sda3 > /dev/null 2>&1 && \
mount /dev/sda2 /mnt > /dev/null 2>&1 && \
mkdir /mnt/boot > /dev/null 2>&1 && \
mkdir /mnt/boot/EFI > /dev/null 2>&1 && \
mkdir /mnt/home > /dev/null 2>&1 && \
mount /dev/sda1 /mnt/boot/EFI > /dev/null 2>&1 && \
mount /dev/sda3 /mnt/home > /dev/null 2>&1 && \
echo ""
fi;


echo "instalando pacotes do sistema";
if pacstrap /mnt --noconfirm \
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
sway \
wayland \
xorg-xwayland \
foot \
pulseaudio \
pavucontrol \
grub-efi-x86_64 \
efibootmgr > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "escaneando hardware amd, sincronizando repositorios do pacman e instalando drivers amd";
if lspci | grep -i amd > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon > /dev/null 2>&1
else
echo "NÃO ENCONTRADO" && echo ""
fi;


echo "escaneando hardware intel, sincronizando repositorios do pacman e instalando drivers intel";
if lspci | grep -i intel > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel > /dev/null 2>&1
else
echo "NÃO ENCONTRADO" && echo ""
fi;


echo "escaneando hardware nvidia, sincronizando repositorios do pacman e instalando drivers nvidia";
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings > /dev/null 2>&1
else
echo "NÃO ENCONTRADO" && echo ""
fi;


echo "configurando partições no arquivo fstab";
if genfstab -U -p /mnt > /mnt/etc/fstab; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "entrando no ambiente arch-chroot";
arch-chroot /mnt bash -c '
echo "";

echo "adicionando nome bux ao usuario root no arquivo hostname";
if echo bux > /etc/hostname; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando senha bux ao usuario root";
if echo -e "bux\nbux" | passwd root > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando usuario normal com nome bux";
if useradd -m -g users -G wheel bux; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando senha bux ao usuario normal";
if echo -e "bux\nbux" | passwd bux > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando caracteres portugues brasileiro";
if echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando idioma portugues brasileiro";
if echo "LANG=pt_BR.UTF-8" > /etc/locale.conf; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "aplicando caracteres portugues brasileiro";
if locale-gen > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "sincronizando relogio";
if hwclock --systohc > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando espelho brasileiro";
if echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "sobscrevendo arquivo .bashrc";
if echo "alias i=\"paru -Sy --noconfirm\";
alias d=\"sudo pacman -Rsc\";
alias a=\"paru -Syyu --noconfirm\";
alias m=\"pacman -Q\";
alias w=\"nmtui\";
sudo rm -rf /home/bux/.bash_history;
sudo pacman -Scc --noconfirm;
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
git clone https://aur.archlinux.org/paru.git && \\
sudo chmod 777 paru && \\
cd paru && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf paru && \\
paru -Sy --noconfirm nano && \\
sudo sed -i \"22,\\\$d\" /home/bux/.bashrc" > /home/bux/.bashrc; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "sobscrevendo arquivo pacman.conf";
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
echo ""
else
echo "FALHOU" && exit
fi;


echo "habilitando driver de wifi na inicialização do sistema";
if systemctl enable NetworkManager > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "desativando serviços inuteis na inicialização do sistema";
if systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "gerando imagens no inicializador do sistema";
if mkinitcpio -P > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "sobscrevendo arquivo grub";
if echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"BUX\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet loglevel=0 panic=0 mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "configurando grub";
if grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=. --recheck > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando grub na inicialização";
if grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando conexão ipv6 no sistema";
if echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 bux.localdomain bux" > /etc/hosts; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando usuario normal (bux) ao sudo no arquivo sudoers";
if echo "bux ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "removendo linhas que começam com jogo da velha e espaços vazios";
if sed -i "/^\s*#/d; /^\s*$/d" \
/home/bux/.bash_profile \
/home/bux/.bash_logout \
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
/etc/fstab; then
echo ""
fi;


echo "adicionando autostartx do kde plasma";
if echo "sway > /dev/null 2>&1" > /home/bux/.bash_profile; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "adicionando autologin do tty1";
if echo "[Unit]
After=systemd-user-sessions.service plymouth-quit-wait.service
Before=getty.target

[Service]
ExecStart=-/usr/bin/agetty --autologin bux --noclear tty1 linux
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
WantedBy=multi-user.target" > /etc/systemd/system/autologin.service; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "habilitando autologin na inicialização";
if systemctl enable autologin.service; then
echo ""
else
echo "FALHOU" && exit
fi;'


echo "gravando dados da memoria no disco";
if sync > /dev/null 2>&1; then
echo ""
else
echo "FALHOU" && exit
fi;


echo "reiniciando";
reboot -f;
