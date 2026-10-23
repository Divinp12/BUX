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
RemoteFileSigLevel=Never
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
NoExtract=usr/lib/modules/*
NoExtract=usr/lib/firmware/*
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
mkfs.ext4 "$ROOT" > /dev/null 2>&1 && \
mount -o rw,noatime "$ROOT" /mnt > /dev/null 2>&1 && \
mount --mkdir -t tmpfs -o rw,nosuid,nodev,noatime,size=100%,nr_inodes=819200,mode=755,inode64,huge=advise tmpfs /mnt/run && \
mount --mkdir -t tmpfs -o defaults,nosuid,nodev,noatime,mode=1777,size=100% tmpfs /mnt/tmp && \
mount --mkdir -t tmpfs -o defaults,nosuid,nodev,noatime,size=100% tmpfs /mnt/var/cache && \
mount --mkdir -t tmpfs -o defaults,nosuid,nodev,noatime,mode=1777,size=100% tmpfs /mnt/var/tmp && \
mount --mkdir -t tmpfs -o defaults,nosuid,nodev,noatime,size=100% tmpfs /mnt/var/log && \
mount --mkdir -t tmpfs -o rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% tmpfs /mnt/var/lib/systemd/coredump && \
mount --mkdir -t tmpfs -o rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% tmpfs /mnt/var/lib/systemd/catalog && \
mount --mkdir -t tmpfs -o rw,nosuid,nodev,noexec,noatime,mode=0755,size=100% tmpfs /mnt/var/lib/pacman/sync && \
mount --mkdir "$BOOT" /mnt/boot > /dev/null 2>&1 && \
mkdir -p /mnt/etc && \
echo "PARTUUID=$(blkid -s PARTUUID -o value "$BOOT") /boot/EFI vfat rw,noatime,iocharset=ascii 0 2
PARTUUID=$(blkid -s PARTUUID -o value "$ROOT") / ext4 defaults,rw,noatime 0 1
tmpfs /run tmpfs rw,nosuid,nodev,noatime,size=100%,nr_inodes=819200,mode=755,inode64,huge=advise 0 0
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
gcc \
glibc \
networkmanager \
sudo \
git \
mesa \
sway \
wayland \
pulseaudio \
wget \
bc > /dev/null 2>&1;


echo "escaneando hardware amd, sincronizando repositorios do pacman e instalando drivers amd";
if lspci | grep -i amd > /dev/null 2>&1; then
pacstrap /mnt --noconfirm vulkan-radeon > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "escaneando hardware intel, sincronizando repositorios do pacman e instalando drivers intel";
if lspci | grep -i intel > /dev/null 2>&1; then
pacstrap /mnt --noconfirm vulkan-intel > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "escaneando hardware nvidia, sincronizando repositorios do pacman e instalando drivers nvidia";
if lspci | grep -i nvidia > /dev/null 2>&1; then
pacstrap /mnt --noconfirm vulkan-nouveau > /dev/null 2>&1;
else
echo "Ñ ENCONTRADO";
fi;


echo "adicionando espelho brasileiro";
cp -a /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist;


echo "sobscrevendo arquivo pacman.conf";
cp -a /etc/pacman.conf /mnt/etc/pacman.conf


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
COMPRESSION=\"\"" > /mnt/etc/mkinitcpio.conf;


echo "adicionando arquivo linux.preset no diretorio /etc/mkinitcpio.d";
echo "ALL_kver=\"/boot/vmlinuz-bux\"
PRESETS=('default')
default_image=\"\"" > /etc/mkinitcpio.d/linux.preset;


echo "sobrescrevendo arquivo vconsole.conf no diretorio /etc";
echo "KEYMAP=us
FONT=lat9w-16" > /mnt/etc/vconsole.conf;


echo "adicionando caracteres portugues brasileiro";
echo "pt_BR.UTF-8 UTF-8" > /mnt/etc/locale.gen;


echo "adicionando idioma portugues brasileiro";
echo "LANG=pt_BR.UTF-8" > /mnt/etc/locale.conf;


echo "adicionando nome bux ao usuario root no arquivo hostname";
echo bux > /mnt/etc/hostname;


echo "adicionando particao tmpfs com diretorio /mnt/KERNEL";
mount --mkdir -t tmpfs -o defaults,nosuid,nodev,noatime,size=100% tmpfs /mnt/KERNEL;


echo "entrando no ambiente arch-chroot";
arch-chroot /mnt bash -c "

wget -P /KERNEL https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.2.11.tar.xz && \
tar xvpf /KERNEL/linux-*.tar.xz -C /KERNEL --xattrs-include="*.*" --numeric-owner > /dev/null 2>&1 && \
rm -rf /KERNEL/linux-*.tar.xz && \
make -C /KERNEL/linux-* mrproper > /dev/null 2>&1 && \
make -C /KERNEL/linux-* clean > /dev/null 2>&1 && \
make -C /KERNEL/linux-* tinyconfig > /dev/null 2>&1 && \
cd /KERNEL/linux-*;
# Base do sistema
scripts/config -e EXPERT -e 64BIT -e SMP -e SCHED_SMT -e SCHED_MC -e X86_X2APIC -e MTRR -e X86_PAT && \
scripts/config -e HIGH_RES_TIMERS -e NO_HZ_IDLE -e HZ_250 -e CC_OPTIMIZE_FOR_PERFORMANCE && \
scripts/config -d MODULES -d SLUB_TINY -d BLK_DEV_INITRD --set-val NR_CPUS 32 && \
scripts/config -e PRINTK -e BUG -e BLOCK -e TTY -e VT -e VT_CONSOLE -e UNIX98_PTYS -e MAGIC_SYSRQ && \
scripts/config -e DEVTMPFS -e DEVTMPFS_MOUNT -e BINFMT_ELF -e BINFMT_SCRIPT -e MULTIUSER && \
scripts/config -e PROC_FS -e PROC_SYSCTL -e SYSFS -e TMPFS -e TMPFS_POSIX_ACL -e TMPFS_XATTR -e SHMEM -e SYSVIPC && \
scripts/config -e FUTEX -e EPOLL -e SIGNALFD -e TIMERFD -e EVENTFD -e AIO -e FILE_LOCKING -e ADVISE_SYSCALLS && \
scripts/config -e POSIX_TIMERS -e INOTIFY_USER -e FHANDLE -e AUTOFS_FS;

# systemd, Steam, namespaces
scripts/config -e CGROUPS -e MEMCG -e CGROUP_SCHED -e FAIR_GROUP_SCHED -e CGROUP_PIDS && \
scripts/config -e NAMESPACES -e UTS_NS -e TIME_NS -e IPC_NS -e USER_NS -e PID_NS -e NET_NS && \
scripts/config -e SECCOMP -e SECCOMP_FILTER -e IA32_EMULATION -e NTSYNC && \
scripts/config -e CRYPTO -e CRYPTO_HMAC -e CRYPTO_SHA256 -e CRYPTO_USER_API_HASH;

# Hardware base
scripts/config -e FW_LOADER -e RTC_CLASS -e RTC_DRV_CMOS -e RTC_HCTOSYS -e RTC_SYSTOHC && \
scripts/config -e ACPI -e ACPI_PROCESSOR -e ACPI_BUTTON -e PCI -e PCI_MSI -e DMI -e DMIID && \
scripts/config -e CPU_FREQ -e X86_INTEL_PSTATE -e X86_AMD_PSTATE -e CPU_IDLE -e INTEL_IDLE && \
scripts/config -e HWMON -e SENSORS_CORETEMP -e SENSORS_K10TEMP;

# Disco: NVMe, SATA, USB
scripts/config -e BLK_DEV_NVME -e ATA -e SATA_AHCI -e SCSI -e BLK_DEV_SD && \
scripts/config -e PARTITION_ADVANCED -e EFI_PARTITION && \
scripts/config -e USB_SUPPORT -e USB -e USB_PCI -e USB_XHCI_HCD -e USB_XHCI_PCI -e USB_EHCI_HCD -e USB_EHCI_PCI && \
scripts/config -e USB_STORAGE -e USB_UAS;

# Sistemas de arquivos
scripts/config -e EXT4_FS -e FAT_FS -e VFAT_FS -e NLS -e NLS_CODEPAGE_437 -e NLS_ASCII -e NLS_UTF8 && \
scripts/config --set-str FAT_DEFAULT_IOCHARSET ascii;

# EFI e vídeo (framebuffer é necessário para o sway subir)
scripts/config -e EFI -e EFI_STUB -e EFIVAR_FS -e FB -e FB_EFI -e FB_DEVICE -e FRAMEBUFFER_CONSOLE && \
scripts/config -e DRM -e DRM_KMS_HELPER -e DRM_FBDEV_EMULATION -e DRM_CLIENT_DEFAULT_FBDEV && \
scripts/config -e DRM_I915;        # AMD: -e DRM_AMDGPU -e DRM_AMD_DC (precisa de EXTRA_FIRMWARE)

# Entrada
scripts/config -e INPUT -e INPUT_EVDEV -e INPUT_KEYBOARD -e KEYBOARD_ATKBD -e INPUT_MOUSE -e MOUSE_PS2 && \
scripts/config -e SERIO -e SERIO_I8042 -e INPUT_MISC -e INPUT_UINPUT && \
scripts/config -e HID_SUPPORT -e HID -e HID_GENERIC -e USB_HID -e HIDRAW;

# Áudio
scripts/config -e SOUND -e SND -e SND_PCI -e SND_HDA_INTEL -e SND_HDA_CODEC_REALTEK -e SND_HDA_CODEC_HDMI -e SND_USB_AUDIO;

# Rede
scripts/config -e NET -e INET -e IPV6 -e UNIX -e PACKET -e NETDEVICES -e NET_CORE -e IP_MULTIPLE_TABLES -e RFKILL && \
scripts/config -e ETHERNET -e NET_VENDOR_REALTEK -e R8169 -e REALTEK_PHY && \
scripts/config -e WIRELESS -e CFG80211 -e MAC80211 -e WLAN -e WLAN_VENDOR_INTEL -e IWLWIFI -e IWLMVM;

make -C /KERNEL/linux-* olddefconfig -j$(nproc) > /dev/null 2>&1;
make -C /KERNEL/linux-* -j$(nproc) && \
cp /KERNEL/linux-*/arch/x86/boot/bzImage /boot/vmlinuz-bux && \
cd /;


mkdir -p /FIRMWARE && \
git clone --filter=blob:none --no-checkout --depth=1 https://gitlab.com/kernel-firmware/linux-firmware.git /FIRMWARE && \
git -C /FIRMWARE sparse-checkout set --no-cone '/*' \
'!/ath3k-1.fw' \
'!/ath6k' \
'!/ath9k_htc' \
'!/ath10k' \
'!/ath11k' \
'!/ath12k' \
'!/mediatek' \
'!/rtw88' \
'!/rtw89' \
'!/bnx2x' \
'!/cxgb3' \
'!/cxgb4' \
'!/wil6210.*' \
'!/ti-connectivity' \
'!/dvb-*' \
'!/dvb_*' \
'!/tigon' \
'!/dpaa2' \
'!/nxp' \
'!/dabusb' \
'!/3com' \
'!/go7007' \
'!/keyspan' \
'!/keyspan_pda' \
'!/mellanox' \
'!/qcom' \
'!/netronome' \
'!/brcm' \
'!/qed' \
'!/mrvl' \
'!/intel/iwlwifi' \
'!/agere_*' \
'!/ar5523.bin' \
'!/ar7010*.fw' \
'!/ar9170-*.fw' \
'!/ar9271.fw' \
'!/htc_*.fw' \
'!/carl9170*' \
'!/atmel' \
'!/cypress' \
'!/lbtf_usb.bin' \
'!/libertas' \
'!/morsemicro' \
'!/mwl8k' \
'!/mwlwifi' \
'!/rsi' \
'!/rsi_91x.fw' \
'!/rt[0-9]*.bin' \
'!/rtlwifi' \
'!/sdd_sagrad_*.bin' \
'!/vntwusb.fw' \
'!/wfx' \
'!/wsm_22.bin' && \
git -C /FIRMWARE checkout && \
mkdir -p /usr/lib/firmware && \
mv /FIRMWARE/* /usr/lib/firmware;
"

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
hwclock --systohc > /dev/null 2>&1;'


echo "configurando systemd-boot";
bootctl --esp-path=/mnt/boot install > /dev/null 2>&1;


echo "adicionando diretorio /mnt/boot/EFI/loader/entries";
mkdir -p /mnt/boot/loader/entries;


echo "adicionando arquivo de configuração do systemd-boot em /mnt/boot/EFI/loader/entries/arch.conf";
echo "title BUX
linux /vmlinuz-bux
options root=PARTUUID=$(blkid -s PARTUUID -o value "$ROOT") rootfstype=ext4 rootwait rw quiet loglevel=3" > /mnt/boot/loader/entries/arch.conf;


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
export GOFLAGS="-buildvcs=false" && \\
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
sudo sed -i \"45,\\\$d\" /home/bux/.bash_profile" > /mnt/home/bux/.bash_profile;


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


echo "deletando diretorios tmpfs";
rm -rf /mnt/home/bux/.cache || true


echo "desmontando diretorios tmpfs";
umount -R /mnt/home/bux/.cache || true;


echo "deletando diretorios tmpfs novamente";
rm -rf /mnt/home/bux/.cache || true


echo "gravando dados da memoria no disco";
sync > /dev/null 2>&1;


echo "desmontando diretorio /mnt";
umount -R /mnt || true;


echo "reiniciando forcadamente";
reboot;
