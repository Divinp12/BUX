____________________________________________________________________________________________________

---------------------------------AVISO LEIA COM ATENÇÃO--------------------------------

OI, SEJA BEM VINDO AO MEU PROJETO QUE SE CHAMA "BUX LINUX", É UM PROJETO QUE AUTOMATIZA A INSTALAÇÃO DO ARCH LINUX PARA QUE NÃO PERCA TEMPO DIGITANDO COMANDOS E TAMBÉM FACILITAR O USO TANTO PARA INICIANTES QUANTO PRA PROFISSIONAIS, O PROCESSO APAGARÁ UM DOS DISPOSITIVOS DE ARMAZENAMENTO QUE ESTÃO CONECTADOS A MAQUINA PARA QUE A INSTALAÇÃO/FORMATAÇÃO SEJA BEM-SUCEDIDA, PARA MAIS INFORMAÇÕES LEIA OS TÓPICOS ABAIXO.

-----------------------------RECOMENDAÇÕES----------------------------

PENDRIVE VAZIO FAT32 DE 2 GB.

BOOT: UEFI ou GPT.

CPU: qualquer um que seja x86_64 ou AMD64.

RAM: 512MB.

ARMAZENAMENTO: 31 GB.

CONECÇÃO COM FIO A INTERNET, MAS SEM FIO USE O COMANDO: iwctl

-----------------------------INSTALAÇÃO-----------------------------------

BAIXE A ISO DO ARCH LINUX NO LINK: https://mirror.ufscar.br/archlinux/iso/2026.01.01/archlinux-x86_64.iso

EXTRAIA OS ARQUIVOS DA ISO NO PENDRIVE

REINICIE O PC E INICIE O PENDRIVE COMO UEFI OU GPT (BIOS MBR / LEGACY NÃO FUNCIONA)

APÓS APARECER O "Root@Archiso" TIRE O PENDRIVE DO PC E DIGITE: pacman -Sy --noconfirm git; git clone https://github.com/Divinp12/BUX; mv B*/A* ~; chmod 777 A*; ./A*

ESPERE E DIVIRTA-SE ;)


-----------------------INFORMAÇÕES BASICAS DO DESKTOP----------------------------------------

ABRIR/TROCAR TERMINAIS (TTY1, TTY2, TTY3, ....): CTRL + ALT + F1 ou F2 ou F3 .... POR PADRÃO O SWAY É EXECUTADO EM TTY1

FECHAR PROGRAMA: SUPER + Z "O CURSOR DO MOUSE PRECISA ESTA DENTRO DO ESPAÇO DO PROGRAMA"

REINICIAR CONFIGURAÇÕES DO SWAY: SUPER + X

ABRIR WOFI (MENU DE PROGRAMAS): SUPER + C

ENTRA OU SAIR NO MODO TELA CHEIA: SUPER + V "O CURSOR DO MOUSE PRECISA ESTA DENTRO DO ESPAÇO DO PROGRAMA"

AUMENTAR VOLUME DO SOM: SUPER + B

DIMINUIR VOLUME DO SOM: SUPER + N

MUTAR MICROFONE: SUPER + M

-----------------------INFORMAÇÕES BASICAS DO TERMINAL----------------------------------------

NOME DO USUARIO ROOT: bux

SENHA DO USUARIO ROOT: bux

NOME DO USUARIO NORMAL: bux

SENHA DO USUARIO NORMAL: bux

INSTALAR PACOTES: i nome-do-pacote

DESISTALAR PACOTES: d nome-do-pacote

ATUALIZAR PACOTES: a nome-do-pacote ou apenas "a" para todos

MOSTRA PACOTES INSTALADOS: m nome-do-pacote ou apenas "m" para todos

CONECTAR A REDE WIFI COM/SEM FIO: w

PARAR/DESLIGAR MAQUINA: p

REINICIAR MAQUINA: r


----------------------PACOTES POPULARES (OPCIONAL)--------------------------------

google chrome (PACOTE QUEBRADO) = git clone https://aur.archlinux.org/google-chrome.git && cd google-chrome && makepkg -si --noconfirm && cd .. && sudo rm -rf google-chrome


firefox = i firefox


VLC (visualizador de audio e video) = i vlc


onlyoffice (visualizador/modificador gratis de pdf, word, etc) = git clone https://aur.archlinux.org/onlyoffice.git && cd onlyoffice && makepkg -si --noconfirm && cd .. && sudo rm -rf onlyoffice


visualizador de fotos = i ristretto


(des)compactador de arquivos = i xarchiver tar xz unzip unrar


obs studio = i obs-studio


wine (versão estável) = i wine wine-mono wine-gecko


telegram = i telegram-desktop


discord = i discord


steam = i steam


java (console) = git clone https://aur.archlinux.org/jdk.git && cd jdk && makepkg -si --noconfirm && cd .. && sudo rm -rf jdk


minecraft java (pirata) = git clone https://aur.archlinux.org/sklauncher-bin.git && cd sklauncher-bin && makepkg -si --noconfirm && cd .. && sudo rm -rf sklauncher-bin


minecraft java (original) = git clone https://aur.archlinux.org/minecraft-launcher.git && cd minecraft-launcher && makepkg -si --noconfirm && cd .. && sudo rm -rf minecraft-launcher


minecraft bedrock (original não oficial, precisa ter comprado pela play store) = git clone https://aur.archlinux.org/mcpelauncher-linux.git && cd mcpelauncher-linux && makepkg -si --noconfirm && cd .. && sudo rm -rf mcpelauncher-linux


mupen64 (emulador de nintendo 64) = git clone https://aur.archlinux.org/mupen64plus-qt.git && cd mupen64plus-qt && makepkg -si --noconfirm && cd .. && sudo rm -rf mupen64plus-qt


pcsx2 (emulador de playstation 2) = git clone https://aur.archlinux.org/pcsx2-git.git && cd pcsx2-git && makepkg -si --noconfirm && cd .. && sudo rm -rf pcsx2-git


rpcs3 (emulador de playstation 3) = git clone https://aur.archlinux.org/rpcs3-git.git && cd rpcs3-git && makepkg -si --noconfirm && cd .. && sudo rm -rf rpcs3-git


sober (roblox player {funcionando}) = i flatpak && flatpak install --user https://sober.vinegarhq.org/sober.flatpakref -y


vinegar (roblox player {quebrado} e roblox studio {funcionando}) = i flatpak && flatpak install flathub org.vinegarhq.Vinegar -y


parsec = git clone https://aur.archlinux.org/parsec-bin.git && cd parsec-bin && makepkg -si --noconfirm && cd .. && sudo rm -rf parsec-bin


heroic games launcher (launcher nao oficial de epic games, GOG e amazon prime) = git clone https://aur.archlinux.org/heroic-games-launcher-bin.git && cd heroic-games-launcher-bin && makepkg -si --noconfirm && cd .. && sudo rm -rf heroic-games-launcher-bin


lutris = i lutris

____________________________________________________________________________________________________
MANGOHUD (OPCIONAL)

Uma ferramenta de monitoramento de desempenho para jogos no Linux...

Instalar: i mangohud lib32-mangohud

Use na steam na “opções de inicialização”:

PARA OPENGL É mangohud --dlsym %command%

PARA VULKAN OU DXVK É mangohud %command%

Use em jogos “executáveis”:

PARA OPENGL É mangohud --dlsym NOME_DO_JOGO OU COMANDO_DE_EXECUÇÃO

PARA VULKAN OU DXVK É mangohud NOME_DO_JOGO OU COMANDO_DE_EXECUÇÃO

PARA MAIS INFORMAÇÕES ACESSE: https://github.com/flightlessmango/MangoHud

____________________________________________________________________________________________________
BLUETOOTH (OPCIONAL)

Para usar o Bluetooth é preciso ter o chip Bluetooth no seu hardware ou ter um dispositivo externo como USB Bluetooth. Porém pode haver uma imcompatibilidade dependendo da versão do Bluetooth.

instalar: i bluez bluez-tools bluez-utils blueman && sudo systemctl start bluetooth && sudo systemctl enable bluetooth && echo "[Policy]" > /etc/bluetooth/main.conf && echo "AutoEnable=true" >> /etc/bluetooth/main.conf

_________________________________________________________________________________________________________________________

CASO NÃO TENHA O PACOTE QUE QUEIRA POR AQUI NESTA PÁGINA, PROCURE PELO SITE OFICIAL DO ARCH LINUX:

https://aur.archlinux.org/packages

____________________________________________________________________________________________________

VEJA SE OS JOGOS SÃO COMPATIVEIS NAS DISTROS LINUX NO SITE PROTONDB

https://www.protondb.com/explore
____________________________________________________________________________________________________
