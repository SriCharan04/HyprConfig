#!/bin/bash

# Extract colors with matugen safely from the output
#~/.cargo/bin/matugen image ~/.config/swww/wall.set --json hex > ~/.config/matugen/templates/colors.json
~/.cargo/bin/matugen image ~/.config/swww/wall.set --json hex 2>/dev/null | grep -v '^ok$' > ~/.config/matugen/templates/colors.json

#Create required templates
~/.cargo/bin/matugen image ~/.config/swww/wall.set

# Generate svg file for Kvantum 
~/.config/matugen/templates/correct_svg.py ~/.config/matugen/templates/colors.json ~/.config/matugen/templates/kvantum-icons.svg ~/.config/Kvantum/EnActors/EnActors.svg

# Generate Neovim colorscheme
#lua ~/.config/scripts/gencolors.lua

# Reload Neovim if running
if pgrep -x "nvim" > /dev/null; then
    # Send command to reload colorscheme (requires nvim-remote or similar)
    ~/.local/bin/nvr --remote-send "<Esc>:RegenPalette<CR>"
fi
