#!/bin/bash

# Extract colors with matugen safely from the output
#~/.cargo/bin/matugen image ~/.config/swww/wall.set --json hex > ~/.config/matugen/templates/colors.json
~/.cargo/bin/matugen image ~/.config/swww/wall.set --json hex 2>/dev/null | grep -v '^ok$' > ~/.config/matugen/templates/colors.json

#Create required templates
~/.cargo/bin/matugen image ~/.config/swww/wall.set

# Generate svg file for Kvantum 
~/.config/matugen/templates/correct_svg.py ~/.config/matugen/templates/colors.json ~/.config/matugen/templates/kvantum-icons.svg ~/.config/Kvantum/EnActors/EnActors.svg

#Spawn Waybar if not spawned
if pgrep -x waybar > /dev/null; then
    pkill -SIGUSR2 waybar  # Reload if running
else
    waybar &               # Start if not running
fi

# Generate Neovim colorscheme
#lua ~/.config/scripts/gencolors.lua

# Reload Neovim if running
if pgrep -x "nvim" > /dev/null; then
    # Send command to reload colorscheme (requires nvim-remote or similar)
    for sock in /tmp/nvimsocket*; do
    	~/.local/bin/nvr --servername "$sock" --nostart -s --remote-send "<Esc>:RegenPalette<CR>" 2>/dev/null
    done
fi
