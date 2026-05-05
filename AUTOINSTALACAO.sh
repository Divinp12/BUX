#!/bin/bash
set -e
trap 'echo "FALHOU no comando: $BASH_COMMAND"' ERR
clear;

echo "adicionando espelho brasileiro";
echo "Server=https://archlinux.c3sl.ufpr.br/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist;


echo "sobscrevendo arquivo pacman.conf";
echo "[options]
Architecture=auto
CheckSpace
ParallelDownloads=1
SigLevel=Required DatabaseOptional
LocalFileSigLevel=Optional
NoExtract=usr/share/man/*
NoExtract=usr/share/doc/*
NoExtract=usr/share/info/*
NoExtract=usr/share/locale/a*
NoExtract=usr/share/locale/b*
NoExtract=usr/share/locale/c*
NoExtract=usr/share/locale/d*
NoExtract=usr/share/locale/ee/*
NoExtract=usr/share/locale/el/*
NoExtract=usr/share/locale/en@*/*
NoExtract=usr/share/locale/en_AU/*
NoExtract=usr/share/locale/en_CA/*
NoExtract=usr/share/locale/en_GB/*
NoExtract=usr/share/locale/en_NZ/*
NoExtract=usr/share/locale/eo/*
NoExtract=usr/share/locale/es/*
NoExtract=usr/share/locale/es_419/*
NoExtract=usr/share/locale/et/*
NoExtract=usr/share/locale/eu/*
NoExtract=usr/share/locale/eu_ES/*
NoExtract=usr/share/locale/f*
NoExtract=usr/share/locale/g*
NoExtract=usr/share/locale/h*
NoExtract=usr/share/locale/i*
NoExtract=usr/share/locale/j*
NoExtract=usr/share/locale/k*
NoExtract=usr/share/locale/l*
NoExtract=usr/share/locale/m*
NoExtract=usr/share/locale/n*
NoExtract=usr/share/locale/o*
NoExtract=usr/share/locale/pa/*
NoExtract=usr/share/locale/pap/*
NoExtract=usr/share/locale/pa_PK/*
NoExtract=usr/share/locale/pi/*
NoExtract=usr/share/locale/pl/*
NoExtract=usr/share/locale/pl_PL/*
NoExtract=usr/share/locale/ps/*
NoExtract=usr/share/locale/pt_PT/*
NoExtract=usr/share/locale/q*
NoExtract=usr/share/locale/r*
NoExtract=usr/share/locale/s*
NoExtract=usr/share/locale/t*
NoExtract=usr/share/locale/u*
NoExtract=usr/share/locale/v*
NoExtract=usr/share/locale/w*
NoExtract=usr/share/locale/x*
NoExtract=usr/share/locale/y*
NoExtract=usr/share/locale/z*
NoExtract=usr/share/gtk-doc/*
NoExtract=usr/share/backgrounds/*
NoExtract=usr/share/metainfo/*
NoExtract=usr/share/bash-completion/*
NoExtract=usr/share/fish/*
NoExtract=usr/share/zsh/*
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf;


echo "sincronizando repositorios do pacman";
pacman -Sy --noconfirm > /dev/null 2>&1;


echo "formatando 1 disco rigido valido";
if wipefs -a /dev/nvme0n1p > /dev/null 2>&1; then
parted -s /dev/nvme0n1p mklabel gpt && \
parted -s /dev/nvme0n1p mkpart ESP fat32 1MiB 90MiB && \
parted -s /dev/nvme0n1p set 1 esp on && \
parted -s /dev/nvme0n1p mkpart primary ext4 90MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 /dev/nvme0n1p1 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/nvme0n1p2 > /dev/null 2>&1 && \
mount /dev/nvme0n1p2 /mnt > /dev/null 2>&1 && \
mkdir /mnt/boot > /dev/null 2>&1 && \
mkdir /mnt/boot/EFI > /dev/null 2>&1 && \
mount /dev/nvme0n1p1 /mnt/boot/EFI > /dev/null 2>&1 && \
echo "UUID=$(blkid -s UUID -o value /dev/nvme0n1p1) /boot/EFI vfat rw,noatime 0 2
UUID=$(blkid -s UUID -o value /dev/nvme0n1p2) / ext4 rw,noatime 0 1
tmpfs /tmp tmpfs defaults,nosuid,nodev,noatime,mode=1777,size=100% 0 0
tmpfs /var/cache tmpfs defaults,nosuid,nodev,noatime,size=100% 0 0
tmpfs /var/tmp tmpfs defaults,nosuid,nodev,noatime,mode=1777,size=100% 0 0
tmpfs /var/log tmpfs defaults,nosuid,nodev,noatime,size=100% 0 0
tmpfs /var/lib/systemd/coredump tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /var/lib/systemd/catalog tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /var/lib/pacman/sync tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /home/bux/.cache tmpfs defaults,nosuid,nodev,noatime,uid=1000,gid=1000,mode=700,size=100% 0 0" > /mnt/etc/fstab && \
mount -a -v;

else

wipefs -a /dev/sda > /dev/null 2>&1 && \
parted -s /dev/sda mklabel gpt && \
parted -s /dev/sda mkpart ESP fat32 1MiB 90MiB && \
parted -s /dev/sda set 1 esp on && \
parted -s /dev/sda mkpart primary ext4 90MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 /dev/sda1 > /dev/null 2>&1 && \
mkfs.ext4 -F /dev/sda2 > /dev/null 2>&1 && \
mount /dev/sda2 /mnt > /dev/null 2>&1 && \
mkdir /mnt/boot > /dev/null 2>&1 && \
mkdir /mnt/boot/EFI > /dev/null 2>&1 && \
mount /dev/sda1 /mnt/boot/EFI > /dev/null 2>&1 && \
mkdir -p /mnt/etc && \
echo "UUID=$(blkid -s UUID -o value /dev/sda1) /boot/EFI vfat rw,noatime 0 2
UUID=$(blkid -s UUID -o value /dev/sda2) / ext4 rw,noatime 0 1
tmpfs /tmp tmpfs defaults,nosuid,nodev,noatime,mode=1777,size=100% 0 0
tmpfs /var/cache tmpfs defaults,nosuid,nodev,noatime,size=100% 0 0
tmpfs /var/tmp tmpfs defaults,nosuid,nodev,noatime,mode=1777,size=100% 0 0
tmpfs /var/log tmpfs defaults,nosuid,nodev,noatime,size=100% 0 0
tmpfs /var/lib/systemd/coredump tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /var/lib/systemd/catalog tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /var/lib/pacman/sync tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /home/bux/.cache tmpfs defaults,nosuid,nodev,noatime,uid=1000,gid=1000,mode=700,size=100% 0 0" > /mnt/etc/fstab && \
mount -a -v;
fi;


echo "instalando pacotes do sistema";
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
sway \
wayland \
xorg-xwayland \
pulseaudio \
grub \
efibootmgr > /dev/null 2>&1;


echo "escaneando hardware amd, sincronizando repositorios do pacman e instalando drivers amd";
if lspci | grep -i amd > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
amd-ucode \
vulkan-radeon > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "escaneando hardware intel, sincronizando repositorios do pacman e instalando drivers intel";
if lspci | grep -i intel > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
intel-ucode \
vulkan-intel > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "escaneando hardware nvidia, sincronizando repositorios do pacman e instalando drivers nvidia";
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
nvidia \
nvidia-dkms \
nvidia-utils \
nvidia-settings > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "adicionando espelho brasileiro";
echo "Server=https://archlinux.c3sl.ufpr.br/\$repo/os/\$arch" > /mnt/etc/pacman.d/mirrorlist;


echo "sobscrevendo arquivo pacman.conf";
echo "[options]
Architecture=auto
CheckSpace
ParallelDownloads=1
SigLevel=Required DatabaseOptional
LocalFileSigLevel=Optional
NoExtract=usr/share/man/*
NoExtract=usr/share/doc/*
NoExtract=usr/share/info/*
NoExtract=usr/share/locale/a*
NoExtract=usr/share/locale/b*
NoExtract=usr/share/locale/c*
NoExtract=usr/share/locale/d*
NoExtract=usr/share/locale/ee/*
NoExtract=usr/share/locale/el/*
NoExtract=usr/share/locale/en@*/*
NoExtract=usr/share/locale/en_AU/*
NoExtract=usr/share/locale/en_CA/*
NoExtract=usr/share/locale/en_GB/*
NoExtract=usr/share/locale/en_NZ/*
NoExtract=usr/share/locale/eo/*
NoExtract=usr/share/locale/es/*
NoExtract=usr/share/locale/es_419/*
NoExtract=usr/share/locale/et/*
NoExtract=usr/share/locale/eu/*
NoExtract=usr/share/locale/eu_ES/*
NoExtract=usr/share/locale/f*
NoExtract=usr/share/locale/g*
NoExtract=usr/share/locale/h*
NoExtract=usr/share/locale/i*
NoExtract=usr/share/locale/j*
NoExtract=usr/share/locale/k*
NoExtract=usr/share/locale/l*
NoExtract=usr/share/locale/m*
NoExtract=usr/share/locale/n*
NoExtract=usr/share/locale/o*
NoExtract=usr/share/locale/pa/*
NoExtract=usr/share/locale/pap/*
NoExtract=usr/share/locale/pa_PK/*
NoExtract=usr/share/locale/pi/*
NoExtract=usr/share/locale/pl/*
NoExtract=usr/share/locale/pl_PL/*
NoExtract=usr/share/locale/ps/*
NoExtract=usr/share/locale/pt_PT/*
NoExtract=usr/share/locale/q*
NoExtract=usr/share/locale/r*
NoExtract=usr/share/locale/s*
NoExtract=usr/share/locale/t*
NoExtract=usr/share/locale/u*
NoExtract=usr/share/locale/v*
NoExtract=usr/share/locale/w*
NoExtract=usr/share/locale/x*
NoExtract=usr/share/locale/y*
NoExtract=usr/share/locale/z*
NoExtract=usr/share/gtk-doc/*
NoExtract=usr/share/backgrounds/*
NoExtract=usr/share/metainfo/*
NoExtract=usr/share/bash-completion/*
NoExtract=usr/share/fish/*
NoExtract=usr/share/zsh/*
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist" > /mnt/etc/pacman.conf;


echo "adicionando nome bux ao usuario root no arquivo hostname";
echo bux > /mnt/etc/hostname;


echo "entrando no ambiente arch-chroot";
arch-chroot /mnt bash -c '


echo "adicionando senha bux ao usuario root";
echo -e "bux\nbux" | passwd root > /dev/null 2>&1;


echo "adicionando usuario normal com nome bux";
useradd -m -g users -G wheel bux;


echo "adicionando senha bux ao usuario normal";
echo -e "bux\nbux" | passwd bux > /dev/null 2>&1;


echo "adicionando caracteres portugues brasileiro";
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen;


echo "adicionando idioma portugues brasileiro";
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf;


echo "aplicando caracteres portugues brasileiro";
locale-gen > /dev/null 2>&1;


echo "sincronizando relogio";
hwclock --systohc > /dev/null 2>&1;


echo "gerando imagens no inicializador do sistema";
mkinitcpio -P > /dev/null 2>&1;


echo "sobscrevendo arquivo grub";
echo "GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=\"bux\"
GRUB_CMDLINE_LINUX_DEFAULT=\"quiet loglevel=0 mitigations=off nospectre_v1 nospectre_v2 spectre_v2=off spectre_bhi=off nopti pti=off nospec_store_bypass_disable l1tf=off mds=off tsx_async_abort=off srbds=off mmio_stale_data=off retbleed=off split_lock_detect=off split_lock_mitigate=0 bpf_jit_harden=0 nokaslr panic=0 debugfs=off audit=0 nowatchdog nmi_watchdog=0 softlockup_panic=0 hardlockup_panic=0 modprobe.blacklist=pcspkr,iTCO_wdt,iTCO_vendor_support,intel_oc_wdt\"
GRUB_CMDLINE_LINUX=\"\"
GRUB_PRELOAD_MODULES=\"part_gpt part_msdos\"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true" > /etc/default/grub;


echo "configurando grub";
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=bux --recheck > /dev/null 2>&1;


echo "adicionando grub na inicialização";
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1;'


echo "adicionando conexão ipv6 no sistema";
echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 bux.localdomain bux" > /mnt/etc/hosts;


echo "sobrescrevendo arquivo vconsole.conf no diretorio /etc";
echo "KEYMAP=us
FONT=lat9w-16" > /mnt/etc/vconsole.conf;


echo "adicionando usuario normal (bux) ao sudo no arquivo sudoers";
echo "bux ALL=(ALL:ALL) NOPASSWD: ALL" >> /mnt/etc/sudoers;


echo "criando autostartx do sway";
echo "if [ \"\$(tty)\" = \"/dev/tty1\" ]; then
exec sway > /dev/null 2>&1
fi;
alias i=\"yay -Sy --noconfirm\";
alias d=\"sudo pacman -Rsc\";
alias a=\"yay -Syyu --noconfirm\";
alias m=\"pacman -Q\";
alias w=\"nmtui\";
alias p=\"sudo poweroff -f\";
alias r=\"sudo reboot -f\";
e() {
SWAYSOCK=\$(ls /run/user/1000/sway-ipc.*.sock) swaymsg exec \"sh -c \\\"\$*\\\"\"
};
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
EXEMPLO: i firefox

INFORMAÇÕES DE DRIVERS:
CONECTAR A REDE WIFI COM OU SEM FIO (w)

INFORMAÇÕES EXTRAS:
DESLIGAR MAQUINA (p)
REINICIAR MAQUINA (r)
EXECUTAR PACOTE (e nome-do-pacote ou comando-especifico-de-execução)
EXEMPLO 1: e firefox
EXEMPLO 2: e flatpak run com.valvesoftware.Steam
\";
clear && \\
echo \"POR FAVOR ESTEJA CONECTADO A INTERNET E AGUARDE 10 SEGUNDOS,
CASO NAO ESTEJA, CANCELE ESSA INSTALACAO COM CTRL + C
E EXECUTE O COMANDO w\" && \\
sudo sleep 11 && \\
cd /home/bux/ && \\
sudo rm -rf yay;
git clone https://aur.archlinux.org/yay.git && \\
sudo chmod 777 yay && \\
cd yay && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf yay && \\
yay -Sy --noconfirm nano --answerclean All --answerdiff None --answeredit None --save && \\
sudo sed -i \"37,\\\$d\" /home/bux/.bash_profile" > /mnt/home/bux/.bash_profile;


echo "criando diretorio /home/bux/.config";
mkdir -p /mnt/home/bux/.config;


echo "adicionando permissões de usuario normal no diretorio /home/bux/.config";
chown -R 1000:1000 /mnt/home/bux/.config;


echo "alterando permissões de leitura e escrita no diretorio /home/bux/.config";
chmod -R u+rwX /mnt/home/bux/.config;


echo "criando diretorio /home/bux/.config/sway";
mkdir -p /mnt/home/bux/.config/sway;


echo "criando arquivo de configuração do sway";
echo "set \$mod Mod4
default_border pixel 1
default_floating_border none
input * { pointer_accel 0 }
output * bg #000000 solid_color
output * { compositor none }
bindsym \$mod+z kill
bindsym \$mod+x reload
bindsym \$mod+c fullscreen toggle
bindsym \$mod+v exec pactl set-sink-volume @DEFAULT_SINK@ +1%
bindsym \$mod+b exec pactl set-sink-volume @DEFAULT_SINK@ -1%
bindsym \$mod+n exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
include /etc/sway/config.d/*" > /mnt/home/bux/.config/sway/config;


echo "adicionando diretorio de configuração extra do sway";
mkdir -p /mnt/etc/sway;


echo "adicionando arquivo de configuração extra do sway";
echo "set \$mod Mod4
default_border pixel 1
default_floating_border none
input * { pointer_accel 0 }
output * bg #000000 solid_color
output * { compositor none }
bindsym \$mod+z kill
bindsym \$mod+x reload
bindsym \$mod+c fullscreen toggle
bindsym \$mod+v exec pactl set-sink-volume @DEFAULT_SINK@ +1%
bindsym \$mod+b exec pactl set-sink-volume @DEFAULT_SINK@ -1%
bindsym \$mod+n exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
include /etc/sway/config.d/*" > /mnt/etc/sway/config;


echo "adicionando autologin do tty1";
echo "[Unit]
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
WantedBy=multi-user.target" > /mnt/etc/systemd/system/multi-user.target.wants/autologin.service;


echo "criando diretorio do systemd";
mkdir -p /mnt/etc/systemd/system/multi-user.target.wants;


echo "adicionando serviço NetworkManager na inicialização";
ln -s /usr/lib/systemd/system/NetworkManager.service \
/mnt/etc/systemd/system/multi-user.target.wants/NetworkManager.service


echo "desativando serviços inuteis na inicialização do sistema";
rm -rf /mnt/etc/systemd/system/*.wants/NetworkManager-wait-online.service \
/mnt/etc/systemd/system/*.wants/systemd-networkd.service \
/mnt/etc/systemd/system/*.wants/systemd-timesyncd.service


echo "removendo linhas que começam com jogo da velha e espaços vazios";
sed -i "/^\s*#/d; /^\s*$/d" \
/mnt/home/bux/.bash_logout \
/mnt/etc/sudoers \
/mnt/etc/sudo.conf \
/mnt/etc/environment \
/mnt/etc/gai.conf \
/mnt/etc/host.conf \
/mnt/etc/healthd.conf \
/mnt/etc/mkinitcpio.conf \
/mnt/etc/libva.conf \
/mnt/etc/vconsole.conf \
/mnt/etc/fuse.conf \
/mnt/etc/ts.conf \
/mnt/etc/fstab || true;


echo "gravando dados da memoria no disco";
sync > /dev/null 2>&1;


echo "desmontando diretorios tmpfs";
umount -R \
/mnt/tmp \
/mnt/var/cache \
/mnt/var/tmp \
/mnt/var/log \
/mnt/home/bux/.cache || true;


echo "deletando diretorios tmpfs";
rm -rf \
/mnt/tmp \
/mnt/var/cache \
/mnt/var/tmp \
/mnt/var/log \
/mnt/home/bux/.cache;


echo "desmontando diretorio /mnt";
umount -R /mnt;


echo "reiniciando forcadamente";
reboot;
