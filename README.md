____________________________________________________________________________________________________

---------------------------------AVISO LEIA COM ATENÇÃO--------------------------------

OI, SEJA BEM VINDO AO MEU PROJETO QUE SE CHAMA "BUX LINUX", É UM PROJETO QUE AUTOMATIZA A INSTALAÇÃO DO ARCH LINUX PARA QUE NÃO PERCA TEMPO DIGITANDO COMANDOS E TAMBÉM FACILITAR O USO TANTO PARA INICIANTES QUANTO PRA PROFISSIONAIS, O PROCESSO APAGARÁ UM DOS DISPOSITIVOS DE ARMAZENAMENTO QUE ESTÃO CONECTADOS A MAQUINA PARA QUE A INSTALAÇÃO/FORMATAÇÃO SEJA BEM-SUCEDIDA, PARA MAIS INFORMAÇÕES LEIA OS TÓPICOS ABAIXO.

-----------------------------RECOMENDAÇÕES----------------------------

PENDRIVE VAZIO FAT32 DE 2 GB

ARQUITETURA: 64 BITS

RAM: 2 GB

ARMAZENAMENTO: 40 GB

CONECÇÃO COM FIO A INTERNET, MAS SEM FIO USE O COMANDO: iwctl

-----------------------------INSTALAÇÃO-----------------------------------

BAIXE A ISO DO ARCH LINUX NO LINK: https://mirror.ufscar.br/archlinux/iso/2025.06.01/archlinux-x86_64.iso

EXTRAIA OS ARQUIVOS DA ISO NO PENDRIVE

REINICIE O PC E INICIE O PENDRIVE COMO UEFI OU GPT (BIOS MBR / LEGACY NÃO FUNCIONA)

APÓS APARECER O "Root@Archiso" TIRE O PENDRIVE DO PC E DIGITE: pacman -Sy git --noconfirm; git clone https://github.com/Divinp12/BUX; mv B*/A* ~; chmod 777 A*; ./A*

ESPERE E DIVIRTA-SE ;)

-----------------------INFORMAÇÕES BASICAS SOBRE O TERMINAL----------------------------------------

NOME DO USUARIO ROOT: 4RCH

SENHA DO USUARIO ROOT: 4RCH

NOME DO USUARIO NORMAL: 4RCH

SENHA DO USUARIO NORMAL: 4RCH

INSTALAR PACOTES: i nome-do-pacote

DESISTALAR PACOTES: d nome-do-pacote

ATUALIZAR PACOTES: a nome-do-pacote ou apenas "a" para todos

MOSTRA TODOS OS PACOTES INSTALADOS: m nome-do-pacote ou apenas "m" para todos

----------------------PACOTES POPULARES (OPCIONAL)--------------------------------

google chrome = i google-chrome

firefox = i firefox

media player (visualizador de audio e videos) = i vlc

libreoffice (visualizador/modificador gratis de pdf, word, etc) = i libreoffice-fresh

visualizador de fotos = i ristretto

(des)compactador de arquivos = i xarchiver tar xz unzip unrar

obs studio = i obs-studio

wine (versão estável) = i wine wine-mono wine-gecko

telegram = i telegram-desktop

discord = i discord

steam = i steam

java (console) = i jdk

minecraft java (pirata) = i sklauncher-bin

minecraft java (original) = i minecraft-launcher

minecraft bedrock (original não oficial) = i mcpelauncher-appimage

mupen64 (emulador de nintendo 64) = i mupen64plus-qt

pcsx2 (emulador de playstation 2) = i pcsx2-git

rpcs3 (emulador de playstation 3) = i rpcs3-git

sober (roblox player {funcionando}) = i flatpak && flatpak install --user https://sober.vinegarhq.org/sober.flatpakref -y

vinegar (roblox player {quebrado} e roblox studio {funcionando}) = i flatpak && flatpak install flathub org.vinegarhq.Vinegar

parsec = i parsec-bin

hidamari (papel de parede animado) = i hidamari

heroic games launcher (launcher nao oficial de epic games, GOG e amazon prime) = i heroic-games-launcher-bin

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
