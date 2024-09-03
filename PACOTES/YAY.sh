#!/bin/bash

git clone https://aur.archlinux.org/yay.git && \
sudo chmod 777 yay && \
cd yay && \
makepkg -si --noconfirm && \
cd .. && \
sudo rm -rf yay && \
yay -S --noconfirm nano --save --answerdiff None --answerclean None --removemake;
