#! /bin/bash

this_path="$(dirname $(realpath $0))"
home_path="$(echo ~)"

[ ! -d "$home_path/.config" ] && mkdir "$home_path/.config"

set -x

#

ln -s $this_path/Pictures/wallpaper.png $home_path/Pictures/wallpaper.png

# Config files
ln -s $this_path/config/nvim $home_path/.config/nvim
ln -s $this_path/config/i3 $home_path/.config/i3
ln -s $this_path/bashrc $home_path/.bashrc
ln -s $this_path/config/picom.conf $home_path/.config/picom.conf
ln -s $this_path/config/polybar $home_path/.config/polybar
