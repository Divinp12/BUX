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
SigLevel=Never
LocalFileSigLevel=Never
NoExtract=usr/lib32/*
NoExtract=usr/bin/mkfs.ext2/*
NoExtract=usr/bin/mkfs.ext3/*
NoExtract=usr/bin/fsck.ext2/*
NoExtract=usr/bin/fsck.ext3/*
NoExtract=usr/share/clang-doc/*
NoExtract=usr/share/help/*
NoExtract=usr/share/licenses/*
NoExtract=usr/share/pixmaps/*
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
NoExtract=usr/share/icons/*
NoExtract=usr/lib/debug/*
NoExtract=usr/lib/modules/*/build/include/xen/*
NoExtract=usr/lib/modules/*/build/include/kvm/*
NoExtract=usr/lib/modules/*/build/include/hyperv/*
NoExtract=usr/lib/modules/*/kernel/drivers/infiniband/*
NoExtract=usr/lib/modules/*/kernel/drivers/xen/*
NoExtract=usr/lib/modules/*/kernel/drivers/watchdog/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/xen/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/hyperv/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vboxvideo/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vmwgfx/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/virtio/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/qxl/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vkms/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vgem/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/ast/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/mgag200/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/gma500/*
NoExtract=usr/lib/modules/*/kernel/drivers/media/radio/*
NoExtract=usr/lib/modules/*/kernel/drivers/ata/pata_*
NoExtract=usr/lib/modules/*/kernel/drivers/macintosh/*
NoExtract=usr/lib/modules/*/kernel/drivers/firewire/*
NoExtract=usr/lib/modules/*/kernel/drivers/isdn/*
NoExtract=usr/lib/modules/*/kernel/drivers/nfc/*
NoExtract=usr/lib/modules/*/kernel/drivers/virtio/*
NoExtract=usr/lib/modules/*/kernel/drivers/virt/*
NoExtract=usr/lib/modules/*/kernel/drivers/vhost/*
NoExtract=usr/lib/modules/*/kernel/drivers/vfio/*
NoExtract=usr/lib/modules/*/kernel/fs/9p/*
NoExtract=usr/lib/modules/*/kernel/fs/a*
NoExtract=usr/lib/modules/*/kernel/fs/c*
NoExtract=usr/lib/modules/*/kernel/fs/d*
NoExtract=usr/lib/modules/*/kernel/fs/g*
NoExtract=usr/lib/modules/*/kernel/fs/h*
NoExtract=usr/lib/modules/*/kernel/fs/i*
NoExtract=usr/lib/modules/*/kernel/fs/j*
NoExtract=usr/lib/modules/*/kernel/fs/k*
NoExtract=usr/lib/modules/*/kernel/fs/l*
NoExtract=usr/lib/modules/*/kernel/fs/m*
NoExtract=usr/lib/modules/*/kernel/fs/n*
NoExtract=usr/lib/modules/*/kernel/fs/ocfs2/*
NoExtract=usr/lib/modules/*/kernel/fs/omfs/*
NoExtract=usr/lib/modules/*/kernel/fs/orangefs/*
NoExtract=usr/lib/modules/*/kernel/fs/p*
NoExtract=usr/lib/modules/*/kernel/fs/q*
NoExtract=usr/lib/modules/*/kernel/fs/r*
NoExtract=usr/lib/modules/*/kernel/fs/smb/*
NoExtract=usr/lib/modules/*/kernel/fs/t*
NoExtract=usr/lib/modules/*/kernel/fs/u*
NoExtract=usr/lib/modules/*/kernel/fs/v*
NoExtract=usr/lib/modules/*/kernel/fs/w*
NoExtract=usr/lib/modules/*/kernel/fs/x*
NoExtract=usr/lib/modules/*/kernel/fs/y*
NoExtract=usr/lib/modules/*/kernel/fs/z*
NoExtract=usr/lib/firmware/bnx2x/*
NoExtract=usr/lib/firmware/cxgb3/*
NoExtract=usr/lib/firmware/cxgb4/*
NoExtract=usr/lib/firmware/wil6210.*
NoExtract=usr/lib/firmware/ath3k-1.*
NoExtract=usr/lib/firmware/ath6k/*
NoExtract=usr/lib/firmware/ti-connectivity/*
NoExtract=usr/lib/firmware/dvb-*
NoExtract=usr/lib/firmware/tigon/*
NoExtract=usr/lib/firmware/dpaa2/*
NoExtract=usr/lib/firmware/nxp/*
NoExtract=usr/lib/firmware/dabusb/*
NoExtract=usr/lib/firmware/3com/*
NoExtract=usr/lib/firmware/go7007/*
NoExtract=usr/lib/firmware/keyspan/*
NoExtract=usr/lib/firmware/keyspan_pda/*
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist" > /etc/pacman.conf;


echo "sincronizando repositorios do pacman";
pacman -Sy --noconfirm > /dev/null 2>&1;


echo "formatando 1 disco rigido valido";
if wipefs -a /dev/nvme0n1 > /dev/null 2>&1; then
DISC="/dev/nvme0n1"
BOOT="/dev/nvme0n1p1"
ROOT="/dev/nvme0n1p2"
else
wipefs -a /dev/sda > /dev/null 2>&1;
DISC="/dev/sda"
BOOT="/dev/sda1"
ROOT="/dev/sda2"
fi && \
parted -s "$DISC" mklabel gpt && \
parted -s "$DISC" mkpart ESP fat32 1MiB 70MiB && \
parted -s "$DISC" set 1 esp on && \
parted -s "$DISC" mkpart primary ext4 70MiB 100% && \
partprobe > /dev/null 2>&1 && \
mkfs.fat -F32 "$BOOT" > /dev/null 2>&1 && \
mkfs.btrfs -f "$ROOT" > /dev/null 2>&1 && \
mount -o rw,compress-force=zstd:22,noatime "$ROOT" /mnt > /dev/null 2>&1 && \
mkdir -p /mnt/tmp && \
mount -t tmpfs -o defaults,nosuid,nodev,noatime,mode=1777,size=100% tmpfs /mnt/tmp && \
mkdir -p /mnt/var/cache && \
mount -t tmpfs -o defaults,nosuid,nodev,noatime,size=100% tmpfs /mnt/var/cache && \
mkdir -p /mnt/var/tmp && \
mount -t tmpfs -o defaults,nosuid,nodev,noatime,mode=1777,size=100% tmpfs /mnt/var/tmp && \
mkdir -p /mnt/var/log && \
mount -t tmpfs -o defaults,nosuid,nodev,noatime,size=100% tmpfs /mnt/var/log && \
mkdir -p /mnt/var/lib/systemd/coredump && \
mount -t tmpfs -o rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% tmpfs /mnt/var/lib/systemd/coredump && \
mkdir -p /mnt/var/lib/systemd/catalog && \
mount -t tmpfs -o rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% tmpfs /mnt/var/lib/systemd/catalog && \
mkdir -p /mnt/var/lib/pacman/sync && \
mount -t tmpfs -o rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% tmpfs /mnt/var/lib/pacman/sync && \
mkdir -p /mnt/home/bux/.cache && \
mount -t tmpfs -o defaults,nosuid,nodev,noatime,uid=1000,gid=1000,mode=700,size=100% tmpfs /mnt/home/bux/.cache && \
mkdir -p /mnt/boot > /dev/null 2>&1 && \
mount "$BOOT" /mnt/boot > /dev/null 2>&1 && \
mkdir -p /mnt/etc && \
echo "UUID=$(blkid -s UUID -o value "$BOOT") /boot/EFI vfat rw,noatime 0 2
UUID=$(blkid -s UUID -o value "$ROOT") / btrfs rw,compress-force=zstd:22,noatime 0 1
tmpfs /tmp tmpfs defaults,nosuid,nodev,noatime,mode=1777,size=100% 0 0
tmpfs /var/cache tmpfs defaults,nosuid,nodev,noatime,size=100% 0 0
tmpfs /var/tmp tmpfs defaults,nosuid,nodev,noatime,mode=1777,size=100% 0 0
tmpfs /var/log tmpfs defaults,nosuid,nodev,noatime,size=100% 0 0
tmpfs /var/lib/systemd/coredump tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /var/lib/systemd/catalog tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /var/lib/pacman/sync tmpfs rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% 0 0
tmpfs /home/bux/.cache tmpfs defaults,nosuid,nodev,noatime,uid=1000,gid=1000,mode=700,size=100% 0 0" > /mnt/etc/fstab && \
mount -a -v;


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
mesa \
sway \
wayland \
pulseaudio > /dev/null 2>&1;


echo "escaneando hardware amd, sincronizando repositorios do pacman e instalando drivers amd";
if lspci | grep -i amd > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
vulkan-radeon > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "escaneando hardware intel, sincronizando repositorios do pacman e instalando drivers intel";
if lspci | grep -i intel > /dev/null 2>&1; then
pacstrap /mnt --noconfirm \
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
SigLevel=Never
LocalFileSigLevel=Never
NoExtract=usr/lib32/*
NoExtract=usr/bin/mkfs.ext2/*
NoExtract=usr/bin/mkfs.ext3/*
NoExtract=usr/bin/fsck.ext2/*
NoExtract=usr/bin/fsck.ext3/*
NoExtract=usr/share/clang-doc/*
NoExtract=usr/share/help/*
NoExtract=usr/share/licenses/*
NoExtract=usr/share/pixmaps/*
NoExtract=usr/share/man/*
NoExtract=usr/share/doc/*
NoExtract=usr/share/info/*
NoExtract=usr/share/locale/a*
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
NoExtract=usr/share/icons/*
NoExtract=usr/lib/debug/*
NoExtract=usr/lib/modules/*/build/include/xen/*
NoExtract=usr/lib/modules/*/build/include/kvm/*
NoExtract=usr/lib/modules/*/build/include/hyperv/*
NoExtract=usr/lib/modules/*/kernel/drivers/infiniband/*
NoExtract=usr/lib/modules/*/kernel/drivers/xen/*
NoExtract=usr/lib/modules/*/kernel/drivers/watchdog/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/xen/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/hyperv/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vboxvideo/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vmwgfx/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/virtio/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/qxl/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vkms/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/vgem/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/ast/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/mgag200/*
NoExtract=usr/lib/modules/*/kernel/drivers/gpu/drm/gma500/*
NoExtract=usr/lib/modules/*/kernel/drivers/media/radio/*
NoExtract=usr/lib/modules/*/kernel/drivers/ata/pata_*
NoExtract=usr/lib/modules/*/kernel/drivers/macintosh/*
NoExtract=usr/lib/modules/*/kernel/drivers/firewire/*
NoExtract=usr/lib/modules/*/kernel/drivers/isdn/*
NoExtract=usr/lib/modules/*/kernel/drivers/nfc/*
NoExtract=usr/lib/modules/*/kernel/drivers/virtio/*
NoExtract=usr/lib/modules/*/kernel/drivers/virt/*
NoExtract=usr/lib/modules/*/kernel/drivers/vhost/*
NoExtract=usr/lib/modules/*/kernel/drivers/vfio/*
NoExtract=usr/lib/modules/*/kernel/fs/9p/*
NoExtract=usr/lib/modules/*/kernel/fs/a*
NoExtract=usr/lib/modules/*/kernel/fs/b*
NoExtract=usr/lib/modules/*/kernel/fs/c*
NoExtract=usr/lib/modules/*/kernel/fs/d*
NoExtract=usr/lib/modules/*/kernel/fs/g*
NoExtract=usr/lib/modules/*/kernel/fs/h*
NoExtract=usr/lib/modules/*/kernel/fs/i*
NoExtract=usr/lib/modules/*/kernel/fs/j*
NoExtract=usr/lib/modules/*/kernel/fs/k*
NoExtract=usr/lib/modules/*/kernel/fs/l*
NoExtract=usr/lib/modules/*/kernel/fs/m*
NoExtract=usr/lib/modules/*/kernel/fs/n*
NoExtract=usr/lib/modules/*/kernel/fs/ocfs2/*
NoExtract=usr/lib/modules/*/kernel/fs/omfs/*
NoExtract=usr/lib/modules/*/kernel/fs/orangefs/*
NoExtract=usr/lib/modules/*/kernel/fs/p*
NoExtract=usr/lib/modules/*/kernel/fs/q*
NoExtract=usr/lib/modules/*/kernel/fs/r*
NoExtract=usr/lib/modules/*/kernel/fs/smb/*
NoExtract=usr/lib/modules/*/kernel/fs/t*
NoExtract=usr/lib/modules/*/kernel/fs/u*
NoExtract=usr/lib/modules/*/kernel/fs/v*
NoExtract=usr/lib/modules/*/kernel/fs/w*
NoExtract=usr/lib/modules/*/kernel/fs/x*
NoExtract=usr/lib/modules/*/kernel/fs/y*
NoExtract=usr/lib/modules/*/kernel/fs/z*
NoExtract=usr/lib/firmware/bnx2x/*
NoExtract=usr/lib/firmware/cxgb3/*
NoExtract=usr/lib/firmware/cxgb4/*
NoExtract=usr/lib/firmware/wil6210.*
NoExtract=usr/lib/firmware/ath3k-1.*
NoExtract=usr/lib/firmware/ath6k/*
NoExtract=usr/lib/firmware/ti-connectivity/*
NoExtract=usr/lib/firmware/dvb-*
NoExtract=usr/lib/firmware/tigon/*
NoExtract=usr/lib/firmware/dpaa2/*
NoExtract=usr/lib/firmware/nxp/*
NoExtract=usr/lib/firmware/dabusb/*
NoExtract=usr/lib/firmware/3com/*
NoExtract=usr/lib/firmware/go7007/*
NoExtract=usr/lib/firmware/keyspan/*
NoExtract=usr/lib/firmware/keyspan_pda/*
[core]
Include=/etc/pacman.d/mirrorlist
[extra]
Include=/etc/pacman.d/mirrorlist" > /mnt/etc/pacman.conf;


echo "criando pasta systemd no diretorio /mnt/etc";
mkdir -p /mnt/etc/systemd;


echo "desativando geração de arquivos em /var/lib/systemd/coredump";
echo "[Coredump]
Storage=none
ProcessSizeMax=0" > /mnt/etc/systemd/coredump.conf;


echo "desativando armazenamento de logs";
echo "[Journal]
Storage=none" > /mnt/etc/systemd/journald.conf;


echo "adicionando arquivo mkinitcpio.conf no diretorio /mnt/etc";
echo "MODULES=()
BINARIES=()
FILES=()
HOOKS=(base systemd autodetect modconf kms keyboard sd-vconsole block filesystems)
COMPRESSION=\"zstd\"" > /mnt/etc/mkinitcpio.conf;


echo "adicionando arquivo linux.preset no diretorio /etc/mkinitcpio.d";
echo "ALL_kver=\"/boot/vmlinuz-linux\"
PRESETS=('default')
default_image=\"/boot/initramfs-linux.img\"" > /etc/mkinitcpio.d/linux.preset;


echo "sobrescrevendo arquivo vconsole.conf no diretorio /etc";
echo "KEYMAP=us
FONT=lat9w-16" > /mnt/etc/vconsole.conf;


echo "adicionando caracteres portugues brasileiro";
echo "pt_BR.UTF-8 UTF-8" > /mnt/etc/locale.gen;


echo "adicionando idioma portugues brasileiro";
echo "LANG=pt_BR.UTF-8" > /mnt/etc/locale.conf;


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


echo "aplicando caracteres portugues brasileiro";
locale-gen > /dev/null 2>&1;


echo "sincronizando relogio";
hwclock --systohc > /dev/null 2>&1;


echo "gerando imagens no inicializador do sistema";
mkinitcpio -P > /dev/null 2>&1;'


echo "configurando systemd-boot";
bootctl --esp-path=/mnt/boot install > /dev/null 2>&1;


echo "adicionando diretorio /mnt/boot/EFI/loader/entries";
mkdir -p /mnt/boot/loader/entries;


echo "adicionando arquivo de configuração do systemd-boot em /mnt/boot/EFI/loader/entries/arch.conf";
echo "title BUX
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=UUID=$(blkid -s UUID -o value "$ROOT") rw quiet loglevel=3 systemd.show_status=false rd.systemd.show_status=false mitigations=off nospectre_v1 nospectre_v2 spectre_v2=off spectre_bhi=off nopti pti=off nospec_store_bypass_disable l1tf=off mds=off tsx_async_abort=off srbds=off mmio_stale_data=off retbleed=off split_lock_detect=off split_lock_mitigate=0 bpf_jit_harden=0 nokaslr panic=0 debugfs=off audit=0 nowatchdog nmi_watchdog=0 softlockup_panic=0 hardlockup_panic=0 modprobe.blacklist=pcspkr,iTCO_wdt,iTCO_vendor_support,intel_oc_wdt" > /mnt/boot/loader/entries/arch.conf;


echo "adicionando arquivo de configuração do systemd-boot em /mnt/boot/EFI/loader/loader.conf";
echo "default arch.conf
timeout 0
editor no" > /mnt/boot/loader/loader.conf


echo "adicionando conexão ipv6 no sistema";
echo "127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 bux.localdomain bux" > /mnt/etc/hosts;


echo "adicionando usuario normal (bux) ao sudo no arquivo sudoers";
echo "bux ALL=(ALL:ALL) NOPASSWD: ALL" >> /mnt/etc/sudoers;


echo "criando autostartx do sway";
echo "export HISTSIZE=0;
export HISTFILESIZE=0;
unset HISTFILE;
if [ \"\$(tty)\" = \"/dev/tty1\" ]; then
exec sway > /dev/null 2>&1
fi;
alias i=\"yay -Sy --noconfirm\";
alias d=\"sudo pacman -Rsc\";
alias a=\"yay -Syyu --noconfirm\";
alias m=\"pacman -Q\";
alias q=\"pacman -Q | wc -l\";
alias w=\"nmtui\";
sudo rm -rf /home/bux/.bash_history;
sudo pacman -Scc --noconfirm;
clear;
echo \"
INFORMAÇÕES DE PACOTES:
INSTALAR PACOTES (i nome-do-pacote)
DESISTALAR PACOTES (d nome-do-pacote)
ATUALIZAR PACOTES (a nome-do-pacote ou apenas a para todos)
MOSTRA PACOTES INSTALADOS (m nome-do-pacote ou apenas m para todos)
EXEMPLO: i firefox

INFORMAÇÕES DE DRIVERS:
CONECTAR A REDE WIFI COM OU SEM FIO (w)

INFORMAÇÕES DO SWAY (INTERFACE GRAFICA):
ABRIR/TROCAR TERMINAIS (TTY1, TTY2, TTY3, ...): CTRL + ALT + F1 ATÉ F12, POR PADRÃO O SWAY É EXECUTADO EM TTY1
FECHAR PROGRAMA: SUPER + Z "CURSOR PRECISA ESTA NO ESPAÇO DA JANELA"
REINICIAR CONFIGURAÇÕES DO SWAY: SUPER + X
ENTRA OU SAIR NO MODO TELA CHEIA: SUPER + C "CURSOR PRECISA ESTA NO ESPAÇO DA JANELA"
AUMENTAR VOLUME DO SOM: SUPER + V
DIMINUIR VOLUME DO SOM: SUPER + B
MUTAR MICROFONE: SUPER + N
DESLIGAR MAQUINA: SUPER + 1
REINICIAR MAQUINA: SUPER + 2

ADICIONE ATALHOS DO SWAY NO ARQUIVO DE CONFIGURAÇÃO
NO DIRETÓRIO /home/bux/.config/sway/config,
EXEMPLO DE ATALHO PARA ABRIR FIREFOX:
bindsym \$mod+f firefox
AO RECARREGAR COM SUPER + X E EXECUTAR SUPER + F,
IRÁ ABRIR O FIREFOX CASO ESTEJA INSTADO NO SISTEMA.
\";
clear && \\
echo \"POR FAVOR ESTEJA CONECTADO A INTERNET E AGUARDE 10 SEGUNDOS,
CASO NAO ESTEJA, CANCELE ESSA INSTALACAO COM CTRL + C
E EXECUTE O COMANDO w\" && \\
sudo sleep 11 && \\
cd /home/bux/ && \\
sudo pacman -Sy && \
sudo rm -rf /home/bux/yay;
sudo git clone https://aur.archlinux.org/yay.git && \\
sudo chmod 777 yay && \\
cd yay && \\
sudo pacman -Sy --noconfirm go && \\
makepkg -si --noconfirm && \\
cd .. && \\
sudo rm -rf yay && \\
yay -Sy --noconfirm nano --answerclean All --answerdiff None --answeredit None --save && \\
sudo sed -i \"44,\\\$d\" /home/bux/.bash_profile" > /mnt/home/bux/.bash_profile;


echo "criando diretorio /home/bux/.config";
mkdir -p /mnt/home/bux/.config;


echo "adicionando permissões de usuario normal no diretorio /home/bux/.config";
chown -R 1000:1000 /mnt/home/bux/.config;


echo "alterando permissões de leitura e escrita no diretorio /home/bux/.config";
chmod -R u+rwX /mnt/home/bux/.config;


echo "criando diretorio /home/bux/.config/sway";
mkdir -p /mnt/home/bux/.config/sway;


echo "adicionando diretorio de configuração extra do sway";
mkdir -p /mnt/etc/sway;


echo "criando arquivo de configuração do sway nos diretorios /mnt/home/bux/.config/sway/config e /mnt/etc/sway/config";
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
bindsym \$mod+1 poweroff
bindsym \$mod+2 reboot
include /etc/sway/config.d/*" | tee \
/mnt/home/bux/.config/sway/config \
/mnt/etc/sway/config > /dev/null 2>&1;


echo "criando diretorio do systemd";
mkdir -p /mnt/etc/systemd/system/multi-user.target.wants;


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
WantedBy=multi-user.target" > /mnt/etc/systemd/system/autologin.service


echo "adicionando autologin na inicialização";
ln -s /mnt/etc/systemd/system/autologin.service \
/mnt/etc/systemd/system/multi-user.target.wants/autologin.service;


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


echo "desmontando diretorio /mnt";
umount -R /mnt || true;


echo "reiniciando forcadamente";
reboot;
