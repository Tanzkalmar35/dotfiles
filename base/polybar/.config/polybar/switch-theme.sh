#!/bin/bash
THEME=$(ls ~/dotfiles/themes | rofi -dmenu -p "theme" -i)
[ -n "$THEME" ] && ~/dotfiles/switch-theme.sh "$THEME"
