#!/bin/bash
# Update system
sudo pacman -Syu --noconfirm

# Install the Niri ecosystem and core tools
sudo pacman -S --noconfirm niri waybar fuzzel swaync swaybg hyprlock hypridle xwayland-satellite xdg-desktop-portal-gnome wl-clipboard kitty ttf-jetbrains-mono-nerd papirus-icon-theme

# Install the Shell ecosystem
sudo pacman -S --noconfirm nushell starship atuin stow git

# Change default shell
chsh -s /usr/bin/nu

# Deploy dotfiles
cd ~/dotfiles
stow niri waybar kitty nushell fuzzel backgrounds

echo "System perfectly restored. Log out and boot into Niri."
