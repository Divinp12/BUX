use std::process::{Command, Stdio};
use std::thread;
use std::time::Duration;

// thread::sleep(Duration::from_secs(3)); // pausa em 3 segundos. Para muda a duracao da pausa altere o numero depois de from_secs(
// let _ = Command::new("clear")
// .status();

// .stdout(Stdio::null()) redirecionar mensagens para lugar nenhum.
// .stderr(Stdio::null()) redirecionar mensagens de erro para lugar nenhum.
// .stdin(Stdio::null())  redirecionar input de teclado, mouse, etc para lugar nenhum.


// executa formatacao
  
fn main() {


println!("adicionando espelho brasileiro");
let status1 = Command::new("sh")
.arg("-c")
.arg(r#"echo 'Server=https://mirror.ufscar.br/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status1 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar espelho brasileiro");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}

  
println!("sobscrevendo arquivo pacman.conf");
let status2 = Command::new("sh")
.arg("-c")
.arg(r#"echo '[options]
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
Include=/etc/pacman.d/mirrorlist' > /etc/pacman.conf"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status2 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao sobscrever arquivo pacman.conf");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("atualizando repositorios");
let status3 = Command::new("pacman")
.arg("-Sy")
.arg("--noconfirm")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status3 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao atualizar repositorios");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}



println!("formatando 1 disco rigido valido");
let status4 = Command::new("sh")
.arg("-c")
.arg(r#"if dd if=/dev/zero of=/dev/nvme0n1p bs=64M && \
parted /dev/nvme0n1p mklabel gpt && \
parted /dev/nvme0n1p mkpart ESP fat32 1MiB 1025MiB && \
parted /dev/nvme0n1p set 1 esp on && \
parted /dev/nvme0n1p mkpart primary ext4 1025MiB 30721MiB && \
parted /dev/nvme0n1p mkpart primary ext4 30721MiB 100% && \
partprobe && \
mkfs.fat -F32 /dev/nvme0n1p1 && \
mkfs.ext4 -F /dev/nvme0n1p2 && \
mkfs.ext4 -F /dev/nvme0n1p3 && \
mount /dev/nvme0n1p2 /mnt && \
mkdir /mnt/boot && \
mkdir /mnt/boot/EFI && \
mkdir /mnt/home && \
mount /dev/nvme0n1p1 /mnt/boot/EFI && \
mount /dev/nvme0n1p3 /mnt/home
else
dd if=/dev/zero of=/dev/sda bs=64M && \
parted /dev/sda mklabel gpt && \
parted /dev/sda mkpart ESP fat32 1MiB 1025MiB && \
parted /dev/sda set 1 esp on && \
parted /dev/sda mkpart primary ext4 1025MiB 30721MiB && \
parted /dev/sda mkpart primary ext4 30721MiB 100% && \
partprobe && \
mkfs.fat -F32 /dev/sda1 && \
mkfs.ext4 -F /dev/sda2 && \
mkfs.ext4 -F /dev/sda3 && \
mount /dev/sda2 /mnt && \
mkdir /mnt/boot && \
mkdir /mnt/boot/EFI && \
mkdir /mnt/home && \
mount /dev/sda1 /mnt/boot/EFI && \
mount /dev/sda3 /mnt/home
fi"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status4 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao formata 1 disco rigido valido");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}



println!("instalando pacotes do sistema");
let status5 = Command::new("pacstrap")
.arg("/mnt")
.arg("--noconfirm")
.arg("base")
.arg("base-devel")
.arg("linux")
.arg("linux-firmware")
.arg("linux-headers")
.arg("networkmanager")
.arg("sudo")
.arg("git")
.arg("fastfetch")
.arg("mesa")
.arg("plasma")
.arg("wayland")
.arg("lib32-wayland")
.arg("xorg-xwayland")
.arg("foot")
.arg("pulseaudio")
.arg("pavucontrol")
.arg("grub-efi-x86_64")
.arg("efibootmgr")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status5 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao instala pacotes do sistema");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("configurando partições no arquivo fstab");
let status6 = Command::new("sh")
.arg("-c")
.arg("genfstab -U -p /mnt > /mnt/etc/fstab")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status6 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao configura partições no arquivo fstab");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando nome bux ao usuario root no arquivo hostname");
let status7 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo bux > /etc/hostname"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status7 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar nome bux ao usuario root no arquivo hostname");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando senha bux ao usuario root");
let status8 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo -e 'bux\nbux' | passwd root"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status8 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar senha bux ao usuario root");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando usuario normal com nome bux");
let status9 = Command::new("arch-chroot")
.arg("/mnt")
.arg("useradd")
.arg("-m")
.arg("-g")
.arg("users")
.arg("-G")
.arg("wheel")
.arg("bux")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status9 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar usuario normal com nome bux");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando senha bux ao usuario normal");
let status10 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo -e 'bux\nbux' | passwd bux"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status10 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar senha bux ao usuario normal");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando caracteres portugues brasileiro");
let status11 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'pt_BR.UTF-8 UTF-8' > /etc/locale.gen"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status11 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar caracteres portugues brasileiro");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando idioma portugues brasileiro");
let status12 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'LANG=pt_BR.UTF-8' > /etc/locale.conf"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status12 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar idioma portugues brasileiro");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("aplicando caracteres portugues brasileiro");
let status13 = Command::new("arch-chroot")
.arg("/mnt")
.arg("locale-gen")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status13 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao aplica caracteres portugues brasileiro");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("sincronizando relogio");
let status14 = Command::new("arch-chroot")
.arg("/mnt")
.arg("hwclock")
.arg("--systohc")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status14 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao sincroniza relogio");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando espelho brasileiro");
let status15 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'Server=https://mirror.ufscar.br/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status15 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar espelho brasileiro");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("sobscrevendo arquivo .bashrc");
let status16 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'alias i="paru -Sy --noconfirm --quiet";
alias d="sudo pacman -Rsc";
alias a="paru -Syyu --noconfirm --quiet";
alias m="pacman -Q";
alias w="nmtui";
sudo rm -rf /home/bux/.bash_history;
sudo pacman -Scc --noconfirm --quiet;
clear;
sudo sleep 1;
fastfetch;
echo "
INFORMAÇÕES DE PACOTES:
INSTALAR PACOTES (i nome-do-pacote)
DESISTALAR PACOTES (d nome-do-pacote)
ATUALIZAR PACOTES (a nome-do-pacote ou apenas a para todos)
MOSTRA PACOTES INSTALADOS (m nome-do-pacote ou apenas m para todos)
EXEMPLO: i google-chrome

INFORMAÇÕES DE DRIVERS:
CONECTAR A REDE WIFI COM OU SEM FIO (w)
";
sudo rm -rf paru;
clear && \
git clone https://aur.archlinux.org/paru.git && \
clear && \
chmod 777 paru && \
cd paru && \
makepkg -si --noconfirm && \
cd .. && \
sudo rm -rf paru && \
paru -Sy --noconfirm --quiet nano && \
sudo sed -i "22,\$d" /home/bux/.bashrc' > /home/bux/.bashrc"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status16 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao sobscreve arquivo .bashrc");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("sobscrevendo arquivo pacman.conf")
let status17 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo '[options]
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
Include=/etc/pacman.d/mirrorlist' > /etc/pacman.conf"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status17 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao sobscreve arquivo pacman.conf");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("sincronizando repositorios do pacman")
let status18 = Command::new("arch-chroot")
.arg("/mnt")
.arg("pacman")
.arg("-Sy")
.arg("--noconfirm")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status18 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao sincroniza repositorios do pacman");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("escaneando hardware amd e instalando drivers amd")
let status19 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"if lspci | grep -i amd; then
pacman -Sy --noconfirm amd-ucode vulkan-radeon lib32-vulkan-radeon
fi"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status19 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao escanea hardware amd e instala drivers amd");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("escaneando hardware intel e instalando drivers intel")
let status20 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"if lspci | grep -i intel; then
pacman -Sy --noconfirm intel-ucode vulkan-intel lib32-vulkan-intel
fi"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status20 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao escanea hardware intel e instala drivers intel");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("escaneando hardware nvidia e instalando drivers nvidia")
let status21 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"if lspci | grep -i nvidia; then
pacman -Sy --noconfirm nvidia nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
fi"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status21 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao escanea hardware nvidia e instala drivers nvidia");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("habilitando driver wifi na inicialização do sistema")
let status22 = Command::new("arch-chroot")
.arg("/mnt")
.arg("systemctl")
.arg("enable")
.arg("NetworkManager")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status22 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao habilita driver wifi na inicialização do sistema");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("desativando serviços inuteis na inicialização do sistema")
let status23 = Command::new("arch-chroot")
.arg("/mnt")
.arg("systemctl")
.arg("disable")
.arg("NetworkManager-wait-online")
.arg("systemd-networkd")
.arg("systemd-timesyncd")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status23 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao desativa serviços inuteis na inicialização do sistema");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("gerando imagens no inicializador do sistema")
let status24 = Command::new("arch-chroot")
.arg("/mnt")
.arg("mkinitcpio")
.arg("-P")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status24 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao gera imagens no inicializador do sistema");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("sobscrevendo arquivo grub")
let status25 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR="BUX"
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 panic=0 mitigations=off"
GRUB_CMDLINE_LINUX=""
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_GFXMODE=auto
GRUB_GFXPAYLOAD_LINUX=keep
GRUB_DISABLE_RECOVERY=true' > /etc/default/grub"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status25 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao sobscreve arquivo grub");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("configurando grub")
let status26 = Command::new("arch-chroot")
.arg("/mnt")
.arg("grub-install")
.arg("--target=x86_64-efi")
.arg("--efi-directory=/boot/EFI")
.arg("--bootloader-id=.")
.arg("--recheck")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status26 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao configura grub");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando grub na inicialização")
let status27 = Command::new("arch-chroot")
.arg("/mnt")
.arg("grub-mkconfig")
.arg("-o")
.arg("/boot/grub/grub.cfg")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status27 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar grub na inicializacao");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando usuario normal (bux) ao sudo no arquivo sudoers")
let status28 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'bux ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status28 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar usuario normal (bux) ao sudo no arquivo sudoers");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando conexão ipv6 no sistema")
let status29 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo '127.0.0.1 localhost.localdomain localhost
::1 localhost.localdomain localhost
127.0.0.1 bux.localdomain bux' > /etc/hosts"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status29 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adicionar conexão ipv6 no sistema");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("removendo linhas que começam com jogo da velha e espaços vazios")
let status30 = Command::new("arch-chroot")
.arg("/mnt")
.arg(r#"sed -i '/^\s*#/d; /^\s*$/d' /home/bux/.bash_profile /home/bux/.bash_logout /etc/environment /etc/gai.conf /etc/sudoers /etc/sudo.conf /etc/host.conf /etc/healthd.conf /etc/mkinitcpio.conf /etc/libva.conf /etc/vconsole.conf /etc/fuse.conf /etc/ts.conf /etc/fstab"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status30 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao remove linhas que começam com jogo da velha e espaços vazios");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando autostartx do kde plasma")
let status31 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo 'startplasma-wayland > /dev/null 2>&1' > /home/bux/.bash_profile"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status31 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adiciona autostartx do kde plasma");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("adicionando autologin do tty1")
let status32 = Command::new("arch-chroot")
.arg("/mnt")
.arg("sh")
.arg("-c")
.arg(r#"echo '[Unit]
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
WantedBy=multi-user.target' > /etc/systemd/system/L.service"#)
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status32 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao adiciona autologin do tty1");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("habilitando autologin na inicialização")
let status33 = Command::new("arch-chroot")
.arg("/mnt")
.arg("systemctl")
.arg("enable")
.arg("L.service")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status33 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao habilita autologin na inicialização");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("gravando dados da memoria no disco")
let status34 = Command::new("sync")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status34 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao grava dados da memoria no disco");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}


println!("reiniciando")
let status35 = Command::new("reboot")
.arg("-f")
.stdout(Stdio::null())
.stderr(Stdio::null())
.stdin(Stdio::null())
.status();
match status35 {
Ok(status) if status.success() => {println!("sucesso");thread::sleep(Duration::from_secs(3));let _ = Command::new("clear").status();}
Ok(_) => {println!("falha ao reiniciar");}
Err(e) => {eprintln!("erro ao executar o comando: {}", e);}
}

}
