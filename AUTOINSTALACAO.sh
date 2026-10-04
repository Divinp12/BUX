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
echo "UUID=$(blkid -s UUID -o value "$BOOT") /boot/EFI vfat rw,noatime 0 2
UUID=$(blkid -s UUID -o value "$ROOT") / ext4 defaults,rw,noatime 0 1
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
linux-firmware \
linux-headers \
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
COMPRESSION=\"zstd\"" > /mnt/etc/mkinitcpio.conf;


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


echo "entrando no ambiente arch-chroot";
arch-chroot /mnt bash -c '

mkdir -p /KERNEL && \
wget -P /KERNEL https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-7.2.8.tar.xz && \
tar xvpf /KERNEL/linux-*.tar.xz -C /KERNEL --xattrs-include="*.*" --numeric-owner && \
rm -rf /KERNEL/linux-*.tar.xz && \
make -C /KERNEL/linux-* defconfig && \
sed -i -E \
-e 's/^(# ?)?(CONFIG_(ZPOOL|SWAP|ZSWAP|ZSMALLOC|ZRAM|MITIGATION|SUSPEND|HIBERNATE|WATCHDOG[A-Z0-9_]*))(=[ymn]| is not set)$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CPU_MITIGATIONS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ARCH_HIBERNATION_HEADER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SOFT_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SOFT_WATCHDOG_PRETIMEOUT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CROS_EC_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DA9052_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DA9055_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DA9063_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DA9062_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LENOVO_SE10_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LENOVO_SE30_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MENF21BMC_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MENZ069_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_WDAT_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_WM831X_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_WM8350_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XILINX_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZIIRAVE_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RAVE_SP_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MLX_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CADENCE_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DW_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TWL4030_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MAX63XX_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RETU_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ACQUIRE_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ADVANTECH_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ADVANTECH_EC_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ALIM1535_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ALIM7101_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CGBC_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_EBC_C384_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_EXAR_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F71808E_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SP5100_TCO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SBC_FITPC2_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_EUROTECH_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IB700_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IBMASR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_WAFER_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_I6300ESB_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IE6XX_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_OC_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ITCO_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ITCO_VENDOR_SUPPORT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IT8712F_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IT87_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HP_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HPWDT_NMI_DECODING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KEMPLD_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SC1200_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PC87413_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NV_TCO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_60XX_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SMSC_SCH311X_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SMSC37B787_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TQMX86_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIA_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_W83627HF_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_W83877F_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_W83977F_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MACHZ_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SBC_EPX_C3_WATCHDOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_MEI_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NI903X_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NIC7018_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SIEMENS_SIMATIC_IPC_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MEN_A21_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_WDT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_EXT2_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_EXT3_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JBD2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JBD2_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_FS_MBCACHE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JFS_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JFS_POSIX_ACL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JFS_SECURITY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JFS_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JFS_STATISTICS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_SUPPORT_V4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_SUPPORT_ASCII_CI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_QUOTA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_POSIX_ACL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_RT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_DRAIN_INTENTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_LIVE_HOOKS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_MEMORY_BUFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_BTREE_IN_MEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_ONLINE_SCRUB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_ONLINE_SCRUB_STATS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_ONLINE_REPAIR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_WARN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XFS_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_GFS2_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_GFS2_FS_LOCKING_DLM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OCFS2_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OCFS2_FS_O2CB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OCFS2_FS_USERSPACE_CLUSTER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OCFS2_FS_STATS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OCFS2_DEBUG_MASKLOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OCFS2_DEBUG_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_FS_POSIX_ACL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_FS_RUN_SANITY_TESTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_ASSERT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_EXPERIMENTAL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BTRFS_FS_REF_VERIFY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NILFS2_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_STAT_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_XATTR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_POSIX_ACL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_SECURITY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_CHECK_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FAULT_INJECTION)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_COMPRESSION)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_LZO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_LZORLE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_LZ4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_LZ4HC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_FS_ZSTD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_IOSTAT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_F2FS_UNFAIR_RWSEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_QUOTA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_ERASURE_CODING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_POSIX_ACL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_TESTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_LOCK_TIME_STATS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_NO_LATENCY_ACCT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_SIX_OPTIMISTIC_SPIN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_PATH_TRACEPOINTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_TRANS_KMALLOC_TRACE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BCACHEFS_ASYNC_OBJECT_LISTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NTFS3_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NTFS3_64BIT_CLUSTER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NTFS3_LZX_XPRESS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NTFS3_FS_POSIX_ACL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NTFS_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RANDOMIZE_BASE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RANDOMIZE_MEMORY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KASAN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERV_VTL_MODE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERV_TIMER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERV_UTILS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERV_BALLOON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MSHV_ROOT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AUDIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SECURITY_SELINUX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SECURITY_SELINUX_BOOTPARAM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SECURITY_SELINUX_DEVELOP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SECURITY_SELINUX_AVC_STATS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SECURITY_SELINUX_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_512GB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PV_SMP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PV_DOM0)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PVHVM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PVHVM_SMP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PVHVM_GUEST)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_SAVE_RESTORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_DEBUG_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PVH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_DOM0)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PV_MSR_SAFE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_BALLOON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_BALLOON_MEMORY_HOTPLUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_SCRUB_PAGES_DEFAULT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_DEV_EVTCHN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_BACKEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XENFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_COMPAT_XENFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_SYS_HYPERVISOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_XENBUS_FRONTEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_GNTDEV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_GNTDEV_DMABUF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_GRANT_DEV_ALLOC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_GRANT_DMA_ALLOC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SWIOTLB_XEN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PCI_STUB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PCIDEV_BACKEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PVCALLS_FRONTEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PVCALLS_BACKEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_SCSI_BACKEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PRIVCMD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_PRIVCMD_EVENTFD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_ACPI_PROCESSOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_MCE_LOG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_HAVE_PVMMU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_EFI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_AUTO_XLATE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_ACPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_SYMS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_HAVE_VPMU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_FRONT_PGDIR_SHBUF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_UNPOPULATED_ALLOC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_GRANT_DMA_OPS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_VIRTIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_XEN_VIRTIO_FORCE_GRANT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_88PM860X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_APU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_AW200XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_CHT_WCOVE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_CROS_EC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM3530)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM3532)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM3533)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM3642)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MT6323)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PCA9532)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PCA9532_GPIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_GPIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LP3944)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LP3952)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LP50XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LP8788)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PCA955X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PCA955X_GPIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PCA963X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PCA995X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_QNAP_MCU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_WM831X_STATUS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_WM8350)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_DA903X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_DA9052)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_DAC124S085)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PWM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_REGULATOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_BD2606MVV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_BD2802)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_INTEL_SS4200)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LT3593)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_ADP5520)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MC13783)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TCA6507)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TLC591XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MAX77705)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MAX8997)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM355x)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MENF21BMC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_IS31FL319X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_UPBOARD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_BLINKM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_BLINKM_MULTICOLOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MLXREG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MLXCPLD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_USER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_NIC78BX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_SPI_BYTE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TI_LMU_COMMON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM36274)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TPS6105X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_AS3645A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_LM3601X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MT6370_FLASH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_RT8515)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_SGM3140)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_KTD202X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_PWM_MULTICOLOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_MT6370_RGB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGERS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_TIMER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_ONESHOT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_DISK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_MTD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_HEARTBEAT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_BACKLIGHT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_CPU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_ACTIVITY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_GPIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_DEFAULT_ON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_TRANSIENT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_CAMERA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_PANIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_NETDEV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_PATTERN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_TTY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_TRIGGER_INPUT_EVENTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_SIEMENS_SIMATIC_IPC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_SIEMENS_SIMATIC_IPC_APOLLOLAKE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_SIEMENS_SIMATIC_IPC_F7188X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LEDS_SIEMENS_SIMATIC_IPC_ELKHARTLAKE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_A11Y_BRAILLE_CONSOLE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_BREDR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_RFCOMM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_RFCOMM_TTY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_BNEP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_BNEP_MC_FILTER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_BNEP_PROTO_FILTER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HIDP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_LE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_LE_L2CAP_ECRED)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_6LOWPAN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_LEDS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_MSFTEXT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_AOSPEXT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_DEBUGFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_SELFTEST)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_INTEL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_BCM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_RTL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_QCA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_MTK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTUSB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTUSB_AUTOSUSPEND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTUSB_POLL_SYNC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTUSB_BCM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTUSB_MTK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTUSB_RTL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBTSDIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_SERDEV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_H4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_NOKIA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_BCSP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_ATH3K)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_LL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_3WIRE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_INTEL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_BCM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_RTL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_QCA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_AG6XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_MRVL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIUART_AML)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBCM203X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBCM4377)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBPA10X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBFUSB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIDTL1)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBT3C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIBLUECARD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIVHCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_MRVL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_MRVL_SDIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_ATH3K)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_MTKSDIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_MTKUART)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_HCIRSI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_VIRTIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_NXPUART)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BT_INTEL_PCIE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ISO9660_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JOLIET)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZISOFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_UDF_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INPUT_TABLET)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TABLET_USB_ACECAD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TABLET_USB_AIPTEK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TABLET_USB_HANWANG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TABLET_USB_KBTAB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TABLET_USB_PEGASUS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TABLET_SERIAL_WACOM4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INPUT_TOUCHSCREEN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_88PM860X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ADS7846)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_AD7877)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_AD7879)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_AD7879_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_AD7879_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ADC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ATMEL_MXT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ATMEL_MXT_T37)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_AUO_PIXCIR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_BU21013)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_BU21029)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CHIPONE_ICN8505)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CY8CTMA140)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CY8CTMG110)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CYTTSP_CORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CYTTSP_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CYTTSP_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_CYTTSP5)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_DA9034)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_DA9052)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_DYNAPRO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_HAMPSHIRE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_EETI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_EGALAX_SERIAL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_EXC3000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_FUJITSU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_GOODIX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_GOODIX_BERLIN_CORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_GOODIX_BERLIN_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_GOODIX_BERLIN_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_HIDEEP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_HYCON_HY46XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_HYNITRON_CSTXXX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ILI210X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ILITEK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_S6SY761)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_GUNZE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_EKTF2127)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ELAN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ELO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WACOM_W8001)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WACOM_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_MAX11801)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_MMS114)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_MELFAS_MIP4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_MSG2638)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_MTOUCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_NOVATEK_NVT_TS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_IMAGIS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_INEXIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_PENMOUNT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_EDT_FT5X06)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TOUCHRIGHT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TOUCHWIN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_PIXCIR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WDT87XX_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WM831X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WM97XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WM9705)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WM9712)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_WM9713)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_COMPOSITE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_MC13783)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_EGALAX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_PANJIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_3M)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_ITM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_ETURBO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_GUNZE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_DMC_TSC10)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_IRTOUCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_IDEALTEK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_GOTOP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_JASTEC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_ELO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_E2I)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_ZYTRONIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_ETT_TC45USB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_NEXIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_USB_EASYTOUCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TOUCHIT213)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TSC_SERIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TSC200X_CORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TSC2004)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TSC2005)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TSC2007)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TSC2007_IIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_PCAP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_RM_TS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_SILEAD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_SIS_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ST1232)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_STMFTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_SUR40)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_SURFACE3_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_SX8654)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_TPS6507X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ZET6223)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ZFORCE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_COLIBRI_VF50)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ROHM_BU21023)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_IQS5XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_IQS7211)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_ZINITIX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TOUCHSCREEN_HIMAX_HX83112B)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AFE4403)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AFE4404)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MAX30100)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MAX30102)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AM2315)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DHT11)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ENS210)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HDC100X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HDC2010)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HDC3020)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HID_SENSOR_HUMIDITY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HTS221)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HTS221_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HTS221_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HTU21)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SI7005)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SI7020)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ACPI_ALS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ADJD_S311)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ADUX1020)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AL3000A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AL3010)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AL3320A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_APDS9160)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_APDS9300)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_APDS9306)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_APDS9960)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AS73211)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BH1745)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BH1750)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BH1780)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CM32181)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CM3232)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CM3323)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CM3605)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CM36651)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IIO_CROS_EC_LIGHT_PROX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_GP2AP002)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_GP2AP020A00F)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IQS621_ALS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SENSORS_ISL29018)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SENSORS_ISL29028)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ISL29125)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ISL76682)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HID_SENSOR_ALS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HID_SENSOR_PROX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_JSA1212)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ROHM_BU27034)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RPR0521)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SENSORS_LM3533)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LTR390)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LTR501)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LTRF216A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LV0104CS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MAX44000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MAX44009)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NOA1305)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OPT3001)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OPT4001)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OPT4060)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PA12203001)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SI1133)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SI1145)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_STK3310)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ST_UVIS25)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ST_UVIS25_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ST_UVIS25_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TCS3414)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TCS3472)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SENSORS_TSL2563)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TSL2583)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TSL2591)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TSL2772)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_TSL4531)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_US5182D)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VCNL4000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VCNL4035)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VEML3235)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VEML6030)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VEML6040)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VEML6070)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VEML6075)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VL6180)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZOPT2201)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ABP060MG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ROHM_BM1390)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BMP280)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BMP280_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BMP280_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IIO_CROS_EC_BARO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DLHL60D)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DPS310)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HID_SENSOR_PRESS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HP03)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HSC030PA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HSC030PA_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HSC030PA_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ICP10100)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPL115)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPL115_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPL115_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPL3115)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPRLS0025PA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPRLS0025PA_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MPRLS0025PA_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MS5611)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MS5611_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MS5611_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MS5637)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SDP500)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IIO_ST_PRESS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IIO_ST_PRESS_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IIO_ST_PRESS_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_T5403)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HP206C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZPA2326)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZPA2326_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZPA2326_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AS3935)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CROS_EC_MKBP_PROXIMITY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_D3323AA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HX9023S)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IRSD200)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ISL29501)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_LIDAR_LITE_V2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MB1232)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RFD77402)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SRF04)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SX_COMMON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SX9310)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SX9324)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SX9360)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SX9500)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SRF08)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VCNL3020)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VL53L0X_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AW96103)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_KERNEL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_FS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DYNAMIC_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DYNAMIC_DEBUG_CORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AS_HAS_NON_CONST_ULEB128)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_NONE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_DWARF4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_DWARF5)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_REDUCED)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_COMPRESSED_NONE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_COMPRESSED_ZLIB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_COMPRESSED_ZSTD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_SPLIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_BTF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PAHOLE_HAS_SPLIT_BTF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PAHOLE_HAS_LANG_EXCLUDE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_INFO_BTF_MODULES)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MODULE_ALLOW_BTF_MISMATCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_GDB_SCRIPTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_FRAME_WARN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_STRIP_ASM_SYMS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_READABLE_ASM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HEADERS_INSTALL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_SECTION_MISMATCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SECTION_MISMATCH_WARN_ONLY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OBJTOOL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_OBJTOOL_WERROR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_RING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_TASK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_IOTLB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_MENU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_NET)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_SCSI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_VSOCK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_VDPA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_CROSS_ENDIAN_LEGACY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_ANCHOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_PCI_LIB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_PCI_LIB_LEGACY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_MENU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_PCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_PCI_ADMIN_LEGACY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_PCI_LEGACY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_VDPA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_PMEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_BALLOON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_MEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_INPUT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_MMIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_DMA_SHARED_BUFFER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_RTC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_RTC_PTP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_RTC_CLASS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_COMMON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_PFNCACHE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_IRQCHIP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_IRQ_ROUTING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_DIRTY_RING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_DIRTY_RING_TSO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_MMIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_ASYNC_PF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_MSI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_READONLY_MEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_VFIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_COMPAT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_IRQ_BYPASS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_NO_POLL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_XFER_TO_GUEST_WORK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_PM_NOTIFIER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_GENERIC_HARDWARE_ENABLING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_GENERIC_MMU_NOTIFIER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_MMU_LOCKLESS_AGING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_PRIVATE_MEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_GENERIC_PRIVATE_MEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTUALIZATION)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_X86)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_INTEL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_X86_SGX_KVM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_AMD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_AMD_SEV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_IOAPIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_SMM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_HYPERV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_XEN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KVM_EXTERNAL_WRITE_TRACKING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERVISOR_GUEST)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PARAVIRT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PARAVIRT_XXL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PARAVIRT_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PARAVIRT_SPINLOCKS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_TRF7970A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MEI_PHY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_SIM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PORT100)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_VIRTUAL_NCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_FDP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_FDP_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN544)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN544_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN544_MEI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN533)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN533_USB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN533_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_PN532_UART)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MICROREAD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MICROREAD_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MICROREAD_MEI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MRVL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MRVL_USB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MRVL_UART)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MRVL_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_MRVL_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_ST21NFCA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_ST21NFCA_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_ST_NCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_ST_NCI_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_ST_NCI_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_NXP_NCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_NXP_NCI_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_S3FWRN5)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_S3FWRN5_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_S3FWRN82_UART)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NFC_ST95HF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_IOVA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_API)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMUFD_DRIVER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_SUPPORT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_IO_PGTABLE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_DEBUGFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_DEFAULT_DMA_STRICT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_DEFAULT_DMA_LAZY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_DEFAULT_PASSTHROUGH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_DMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_SVA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMU_IOPF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_AMD_IOMMU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DMAR_TABLE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_IOMMU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_IOMMU_SVM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_IOMMU_DEFAULT_ON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_IOMMU_FLOPPY_WA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INTEL_IOMMU_PERF_EVENTS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMUFD_DRIVER_CORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IOMMUFD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_IRQ_REMAP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HYPERV_IOMMU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_VIRTIO_IOMMU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_CORE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_NOTIFIER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_PIN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MEDIA_CEC_RC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_PIN_ERROR_INJ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MEDIA_CEC_SUPPORT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_CH7322)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_NXP_TDA9950)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_CROS_EC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_GPIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_SECO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_CEC_SECO_RC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_USB_EXTRON_DA_HD_4K_PLUS_CEC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_USB_PULSE8_CEC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_USB_RAINSHADOW_CEC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KERNEL_GZIP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KERNEL_BZIP2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KERNEL_LZMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KERNEL_XZ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KERNEL_LZO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_KERNEL_LZ4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KERNEL_GZIP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KERNEL_BZIP2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KERNEL_LZMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KERNEL_XZ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KERNEL_LZO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_KERNEL_LZ4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RD_GZIP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RD_BZIP2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RD_LZMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RD_XZ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RD_LZO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RD_LZ4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_737)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_775)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_850)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_852)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_855)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_857)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_860)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_861)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_862)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_863)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_864)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_865)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_866)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_869)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_936)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_950)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_932)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_949)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_874)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_8)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_1250)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_CODEPAGE_1251)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_1)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_3)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_5)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_6)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_7)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_9)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_13)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_14)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_ISO8859_15)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_KOI8_R)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_KOI8_U)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_ROMAN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_CELTIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_CENTEURO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_CROATIAN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_CYRILLIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_GAELIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_GREEK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_ICELAND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_INUIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_ROMANIAN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_MAC_TURKISH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_NLS_UCS2_UTILS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_ALI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_AMD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_ARTOP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_ATIIXP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_ATP867X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_CMD64X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_CYPRESS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_EFAR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_HPT366)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_HPT37X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_HPT3X2N)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_HPT3X3)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_HPT3X3_DMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_IT8213)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_IT821X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_JMICRON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_MARVELL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_NETCELL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_NINJA32)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_NS87415)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_OLDPIIX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_OPTIDMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PDC2027X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PDC_OLD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_RADISYS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_RDC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_SCH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_SERVERWORKS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_SIL680)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_SIS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_TOSHIBA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_TRIFLEX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_VIA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_WINBOND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_CMD640_PCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_MPIIX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_NS87410)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_OPTI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PCMCIA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_RZ1000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_ATEN)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_BPCK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_BPCK6)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_COMM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_DSTR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_FIT2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_FIT3)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_EPAT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_EPATC8)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_EPIA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_FRIQ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_FRPW)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_KBIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_KTTI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_ON20)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_PARPORT_ON26)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_ACPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PATA_LEGACY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_YENTA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_YENTA_O2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_YENTA_RICOH)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_YENTA_TI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_YENTA_ENE_TUNE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_YENTA_TOSHIBA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PD6729)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_I82092)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PCCARD_NONSTATIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RAPIDIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_HFCPCI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_HFCMULTI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_HFCUSB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_AVMFRITZ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_SPEEDFAX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_INFINEON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_W6692)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_NETJET)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_HDLC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_IPAC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MISDN_ISAR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_CLIENT_KTIMER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_CLIENT_LDISC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_CLIENT_PARPORT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_CLIENT_GPIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_GENERATOR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_GENERATOR_DUMMY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PPS_GENERATOR_TIO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_OPTIONAL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DP83640_PHY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_INES)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_KVM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_VMCLOCK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_IDT82P33)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_IDTCM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_FC3W)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_MOCK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_VMW)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_1588_CLOCK_OCP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_DFL_TOD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_PTP_NETC_V4_TIMER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DPLL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZL3073X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZL3073X_I2C)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ZL3073X_SPI)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_ACNTSA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_APOLLO)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_AUDPTR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_BNS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_DECTLK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_DECEXT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_LTLK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_SOFT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_SPKOUT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_TXPRT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SPEAKUP_SYNTH_DUMMY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_USER_MAD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_USER_ACCESS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_USER_MEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_ON_DEMAND_PAGING)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_ADDR_TRANS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_VIRT_DMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_BNXT_RE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_CXGB4)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_EFA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_ERDMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_HFI1)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HFI1_DEBUG_SDMA_ORDER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_SDMA_VERBOSITY)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_IONIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_IRDMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MANA_INFINIBAND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MLX4_INFINIBAND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MLX5_INFINIBAND)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_MTHCA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_MTHCA_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_OCRDMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_QEDR)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_USNIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_VMWARE_PVRDMA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_RDMAVT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RDMA_RXE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_RDMA_SIW)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_IPOIB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_IPOIB_CM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_IPOIB_DEBUG)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_IPOIB_DEBUG_DATA)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_SRP)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_SRPT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_ISER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_ISERT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_RTRS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_RTRS_CLIENT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_RTRS_SERVER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_INFINIBAND_OPA_VNIC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_M88DS3103)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MXL5XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STB0899)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STB6100)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV090x)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV0910)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV6110x)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV6111)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DRXK)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MN88472)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MN88473)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_SI2165)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA18271C2DD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX24110)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX24116)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX24117)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX24120)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX24123)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DS3000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MB86A16)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MT312)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_S5H1420)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_SI21XX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STB6000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV0288)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV0299)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV0900)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV6110)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA10071)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA10086)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA8083)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA8261)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA826X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TS2020)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TUA6100)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TUNER_CX24113)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TUNER_ITD1000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_VES1X93)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ZL10036)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ZL10039)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_AF9013)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_AS102_FE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX22700)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CX22702)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CXD2820R)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CXD2841ER)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DIB3000MB)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DIB3000MC)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DIB7000M)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DIB7000P)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DRXD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_EC100)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_GP8PSK_FE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_L64781)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MT352)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_NXT6000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_RTL2830)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_RTL2832)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_SI2168)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_SP887X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV0367)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA10048)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA1004X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ZD1301_DEMOD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ZL10353)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_STV0297)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA10021)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA10023)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_VES1820)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_AU8522)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_AU8522_DTV)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_AU8522_V4L)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_BCM3510)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LG2160)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LGDT3305)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LGDT3306A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LGDT330X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MXL692)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_NXT200X)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_OR51132)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_OR51211)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_S5H1409)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_S5H1411)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DIB8000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_MB86A20S)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_S921)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TC90522)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_PLL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TUNER_DIB0070)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TUNER_DIB0090)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_A8293)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_AF9033)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ASCOT2E)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ATBM8830)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_HELENE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_HORUS3A)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ISL6405)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ISL6421)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_ISL6423)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_IX2505V)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LGS8GXX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LNBH25)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LNBP21)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_LNBP22)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_M88RS2000)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_TDA665x)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DRX39XYJ)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_CXD2099)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_SP2)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DVB_DUMMY_FE)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_VGEM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_VKMS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_VMWGFX)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_VMWGFX_MKSSTATS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_UDL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_AST)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_MGAG200)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_QXL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_VIRTIO_GPU)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_DRM_VIRTIO_GPU_KMS)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_HAVE_EBPF_JIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_ARCH_WANT_DEFAULT_BPF_JIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_SYSCALL)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_JIT)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_JIT_ALWAYS_ON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_JIT_DEFAULT_ON)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_UNPRIV_DEFAULT_OFF)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_PRELOAD)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_BPF_LSM)(=.*| is not set)?$/\2=n/' \
-e 's/^(# ?)?(CONFIG_MODULES)(=.*| is not set)?$/\2=n/' \
/KERNEL/linux-*/.config && \
make -C /KERNEL/linux-* olddefconfig && \
make -C /KERNEL/linux-* -j$(nproc) && \
cp /KERNEL/linux-*/arch/x86/boot/bzImage /boot/vmlinuz-bux;


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
options root=UUID=$(blkid -s UUID -o value "$ROOT") rw quiet loglevel=3" > /mnt/boot/loader/entries/arch.conf;


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
