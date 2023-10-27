#! /bin/bash

function install() {
    which pacman 2>&1 >/dev/null || which yay || return 0
    local package 
    [ $# -eq 2 ] && package="$2" || package="$1"
    which $1 2>&1 >/dev/null || echo sudo pacman -S $1
}

function link() {
    echo ln -s "$PWD/$1" "~/$(echo "$1" | sed 's/^config/.config/')"
}

function link_hidden() {
    link "$(echo "$1" | sed 's/\([^/]*\)$/.\1/')"
}

[ -d ~/.config ] || mkdir "~/.config"

# Wallpapers

link Pictures/wallpaper.png
link Pictures/wallpaper2.png

# Install necessary packages

install nvim neovim
install kitty 
install i3
install picom 
install polybar
install rofi
install discord
install slack

# Config files
link config/nvim
link config/i3
link config/picom.conf
link config/polybar
link_hidden bashrc
link_hidden gitconfig
link_hidden gitignore
