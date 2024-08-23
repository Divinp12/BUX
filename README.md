OI, SEJA BEM VINDO AO MEU PROJETO QUE SE CHAMA "4RCH LINUX", É UM PROJETO QUE AUTOMATIZA A INSTALAÇÃO DO ARCH LINUX PARA QUE NÃO PERCA TEMPO DIGITANDO COMANDOS E TAMBÉM FACILITAR O USO TANTO PARA INICIANTES QUANTO PRA PROFISSIONAIS, PARA MAIS INFORMAÇÕES LEIA OS TÓPICOS ABAIXO.

---------------------------------AVISO--------------------------------

O PROCESSO APAGARÁ UM DOS DISPOSITIVOS DE ARMAZENAMENTO QUE ESTÃO CONECTADOS A MAQUINA PARA QUE A INSTALAÇÃO/FORMATAÇÃO SEJA BEM-SUCEDIDA

-----------------------------RECOMENDAÇÕES----------------------------

PENDRIVE VAZIO FAT32 DE 2 GB

ARQUITETURA: 64 BITS

RAM: 1 GB

ARMAZENAMENTO: 40 GB

CONECÇÃO COM FIO A INTERNET, MAS SEM FIO USE O COMANDO: iwctl

-----------------------------INSTALAÇÃO-----------------------------------

BAIXE A ISO DO ARCH LINUX NO LINK: https://mirror.ufscar.br/archlinux/iso/2024.08.01/archlinux-x86_64.iso

EXTRAIA OS ARQUIVOS DA ISO NO PENDRIVE

REINICIE O PC E INICIE O PENDRIVE COMO UEFI OU GPT (BIOS LEGACY NÃO FUNCIONA)

APÓS APARECER O "Root@Archiso" TIRE O PENDRIVE DO PC E DIGITE: pacman -Sy git --noconfirm; git clone https://github.com/Divinp12/4RCH-LINUX.git; mv 4RCH*/1* ~; chmod 777 1*; ./1*

ESPERE E DIVIRTA-SE ;)

-----------------------INFORMAÇÕES BASICAS----------------------------------------

NOME DO USUARIO ROOT: 4RCH

SENHA DO USUARIO ROOT: 4RCH

NOME DO USUARIO NORMAL: 4RCH

SENHA DO USUARIO NORMAL: 4RCH

INSTALAR PACOTES PELO TERMINAL: i NOME-DO-PACOTE

DESISTALAR PACOTES PELO TERMINAL: d NOME-DO-PACOTE

----------------------PACOTES POPULARES (OPCIONAL)--------------------------------

google chrome = google-chrome

visualizador de fotos = ristretto

(des)compactador de arquivos = xarchiver

obs studio = obs-studio

media player = vlc

wine (versão estável) = wine

telegram = telegram-desktop

discord = discord

steam = steam

java (console) = jdk

minecraft java (pirata) = sklauncher-bin

minecraft java (original) = minecraft-launcher

minecraft bedrock (original não oficial) = mcpelauncher-appimage

mupen64 (emulador de nintendo 64) = mupen64plus-qt

pcsx2 (emulador de playstation 2) = pcsx2-git

rpcs3 (emulador de playstation 3) = rpcs3-git

grapejuice (roblox player e roblox studio) = grapejuice

parsec = parsec-bin

hidamari (papel de parede animado) = hidamari

heroic games launcher = heroic-games-launcher

lutris = lutris

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
GAMEMODE (OPCIONAL)

Uma ferramenta com objetivo principal de otimizar o desempenho do sistema enquanto você joga, priorizando recursos do sistema para garantir uma experiência de jogo mais suave...

Instalar: i gamemode lib32-gamemode

Use na steam na “opções de inicialização”:

gamemoderun %command%

Use em jogos “executáveis”:

gamemoderun NOME_DO_JOGO OU COMANDO_DE_EXECUÇÃO

PARA MAIS INFORMAÇÕES ACESSE: https://github.com/FeralInteractive/gamemode

____________________________________________________________________________________________________
BLUETOOTH (OPCIONAL)

Para usar o Bluetooth é preciso ter o chip Bluetooth no seu hardware ou ter um dispositivo externo como USB Bluetooth. Porém pode haver uma imcompatibilidade dependendo da versão do Bluetooth.

instalar: i bluez bluez-tools bluez-utils blueman && sudo systemctl start bluetooth && sudo systemctl enable bluetooth && echo "[Policy]" > /etc/bluetooth/main.conf && echo "AutoEnable=true" >> /etc/bluetooth/main.conf
_________________________________________________________________________________________________________________________

CASO NÃO TENHA O PACOTE QUE QUEIRA POR AQUI NESTA PÁGINA, PROCURE PELO SITE OFICIAL DO ARCH LINUX:

https://aur.archlinux.org/packages

