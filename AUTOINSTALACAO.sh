#!/bin/bash

clear && sleep 3

echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{=              }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{==             }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{===            }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{====           }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{=====          }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{======         }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{=======        }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{========       }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{=========      }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{==========     }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{===========    }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{============   }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{=============  }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{============== }
" && sleep 1 && clear && \
echo "
iniciando formatação em 15 segundos,
esteja ciente do que esta fazendo,
pois todos os dados serão apagados
para que a instalação seja bem sucedida.

{===============}
" && sleep 1 && clear;

☆() {
if "$@"; then
echo "passou"
else
echo "falhou"
fi;
}

echo "adicionando espelho brasileiro"
☆ echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo "sobscrevendo arquivo pacman.conf"
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


echo "sincronizando repositorios do pacman"
☆ pacman -Sy --noconfirm --quiet > /dev/null 2>&1


echo "formatando 1 disco rigido valido"
if dd if=/dev/zero of=/dev/nvme0n1p bs=64M > /dev/null 2>&1 && \
parted -s /dev/nvme0n1p mklabel gpt && \
parted -s /dev/nvme0n1p mkpart ESP fat32 1MiB 1025MiB && \
parted -s /dev/nvme0n1p set 1 esp on && \
parted -s /dev/nvme0n1p mkpart primary ext4 1025MiB 30721MiB && \
parted -s /dev/nvme0n1p mkpart primary ext4 30721MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 /dev/nvme0n1p1 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/nvme0n1p2 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/nvme0n1p3 > /dev/null 2>&1 && \
mount /dev/nvme0n1p2 /mnt > /dev/null 2>&1 && \
mkdir /mnt/boot > /dev/null 2>&1 && \
mkdir /mnt/boot/EFI > /dev/null 2>&1 && \
mkdir /mnt/home > /dev/null 2>&1 && \
mount /dev/nvme0n1p1 /mnt/boot/EFI > /dev/null 2>&1 && \
mount /dev/nvme0n1p3 /mnt/home > /dev/null 2>&1

else

dd if=/dev/zero of=/dev/sda bs=64M > /dev/null 2>&1 && \
parted -s /dev/sda mklabel gpt && \
parted -s /dev/sda mkpart ESP fat32 1MiB 1025MiB && \
parted -s /dev/sda set 1 esp on && \
parted -s /dev/sda mkpart primary ext4 1025MiB 30721MiB && \
parted -s /dev/sda mkpart primary ext4 30721MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 /dev/sda1 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/sda2 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/sda3 > /dev/null 2>&1 && \
mount /dev/sda2 /mnt > /dev/null 2>&1 && \
mkdir /mnt/boot > /dev/null 2>&1 && \
mkdir /mnt/boot/EFI > /dev/null 2>&1 && \
mkdir /mnt/home > /dev/null 2>&1 && \
mount /dev/sda1 /mnt/boot/EFI > /dev/null 2>&1 && \
mount /dev/sda3 /mnt/home > /dev/null 2>&1
fi;


sleep 3;
clear;


echo "instalando pacotes do sistema"
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


echo "configurando partições no arquivo fstab"
☆ genfstab -U -p /mnt > /mnt/etc/fstab


echo "entrando no ambiente arch-chroot"
arch-chroot /mnt bash -c '

sleep 3;
clear;

☆() {
if "$@"; then
echo "PASSOU"
else
echo "FALHOU"
fi;
sleep 3;
clear;
}


echo "adicionando nome bux ao usuario root no arquivo hostname";
☆ echo bux > /etc/hostname


echo "adicionando senha bux ao usuario root"
☆ echo -e "bux\nbux" | passwd root


echo "adicionando usuario normal com nome bux"
☆ useradd -m -g users -G wheel bux


echo "adicionando senha bux ao usuario normal"
☆ echo -e "bux\nbux" | passwd bux


echo "adicionando caracteres portugues brasileiro"
☆ echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen


echo "adicionando idioma portugues brasileiro"
☆ echo "LANG=pt_BR.UTF-8" > /etc/locale.conf


echo "aplicando caracteres portugues brasileiro"
☆ locale-gen > /dev/null 2>&1


echo "sincronizando relogio"
☆ hwclock --systohc > /dev/null 2>&1


echo "adicionando espelho brasileiro"
☆ echo "Server=https://mirror.ufscar.br/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist


echo "sobscrevendo arquivo .bashrc"
☆ echo "alias i=\"paru -Sy --noconfirm --quiet\";
alias d=\"sudo pacman -Rsc\";
alias a=\"paru -Syyu --noconfirm --quiet\";
alias m=\"pacman -Q\";
alias w=\"nmtui\";
sudo rm -rf /home/bux/.bash_history;
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
git clone https://aur.archlinux.org/paru.git && \\
chmod 777 paru && \\
cd paru && \\
makepkg -si --noconfirm --quiet && \\
cd .. && \\
sudo rm -rf paru && \\
paru -Sy --noconfirm --quiet nano && \\
sudo sed -i \"22,\\\$d\" /home/bux/.bashrc" > /home/bux/.bashrc


echo "sobscrevendo arquivo pacman.conf"
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


echo "sincronizando repositorios do pacman"
☆ pacman -Sy --noconfirm --quiet > /dev/null 2>&1


echo "escaneando hardware amd e instalando drivers amd"
if lspci | grep -i amd > /dev/null 2>&1; then
pacman -Sy --noconfirm \
amd-ucode \
vulkan-radeon \
lib32-vulkan-radeon > /dev/null 2>&1
else
echo "falhou"
fi;


sleep 3;
clear


echo "escaneando hardware intel e instalando drivers intel"
if lspci | grep -i intel > /dev/null 2>&1; then
pacman -Sy --noconfirm \
intel-ucode \
vulkan-intel \
lib32-vulkan-intel > /dev/null 2>&1
else
echo "falhou"
fi;


sleep 3;
clear


echo "escaneando hardware nvidia e instalando drivers nvidia"
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacman -Sy --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
lib32-nvidia-utils \
nvidia-settings > /dev/null 2>&1
else
echo "falhou"
fi;


sleep 3;
clear


echo "habilitando driver de wifi na inicialização do sistema"
☆ systemctl enable NetworkManager > /dev/null 2>&1


echo "desativando serviços inuteis na inicialização do sistema"
☆ systemctl disable \
NetworkManager-wait-online \
systemd-networkd \
systemd-timesyncd > /dev/null 2>&1


echo "gerando imagens no inicializador do sistema"
☆ mkinitcpio -P > /dev/null 2>&1


echo "sobscrevendo arquivo grub"
☆ echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"BUX\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet loglevel=0 panic=0 mitigations=off\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub


echo "configurando grub"
☆ grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=. --recheck > /dev/null 2>&1


echo "adicionando grub na inicialização"
☆ grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1


echo "adicionando usuario normal (bux) ao sudo no arquivo sudoers"
☆ echo "bux ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers


echo "adicionando conexão ipv6 no sistema"
☆ echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 bux.localdomain bux" > /etc/hosts


echo "removendo linhas que começam com jogo da velha e espaços vazios"
☆ sed -i "/^\s*#/d; /^\s*$/d" \
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
/etc/fstab


echo "adicionando autostartx do kde plasma"
☆ echo "startplasma-wayland > /dev/null 2>&1" > /home/bux/.bash_profile


echo "adicionando autologin do tty1"
☆ echo "[Unit]
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
WantedBy=multi-user.target" > /etc/systemd/system/L.service


echo "habilitando autologin na inicialização"
☆ systemctl enable L.service'


sleep 3;
clear;


echo "gravando dados da memoria no disco"
☆ sync > /dev/null 2>&1


echo "reiniciando"
reboot -f;
