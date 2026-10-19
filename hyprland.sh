#!/usr/bin/env bash
# ==============================================================================
# Garuda Linux - Everforest Hyprland & Quickshell Rice Installer
# Installs Hyprland, Quickshell, Hyprpaper, Thunar
# Removes Dolphin and Konsole
# Sets Kitty & Thunar as system defaults
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🌲 [1/4] Installing Hyprland, Quickshell, Hyprpaper, and Thunar..."
sudo pacman -S --needed \
    hyprland \
    quickshell \
    hyprpaper \
    thunar \
    thunar-archive-plugin \
    tumbler \
    xdg-desktop-portal-hyprland

echo "🗑️ [2/4] Removing Dolphin and Konsole..."
# Remove dolphin and its plugins/service menus, and konsole
if pacman -Q dolphin >/dev/null 2>&1 || pacman -Q konsole >/dev/null 2>&1; then
    sudo pacman -R --cascade --nodeps dolphin dolphin-plugins konsole 2>/dev/null || \
    sudo pacman -R --nodeps dolphin konsole 2>/dev/null || true
    echo "✓ Konsole and Dolphin removed successfully."
else
    echo "✓ Konsole and Dolphin already removed."
fi

echo "📁 [3/4] Setting Thunar and Kitty as system defaults..."
xdg-mime default thunar.desktop inode/directory
xdg-settings set default-web-browser "${BROWSER:-firefox.desktop}" 2>/dev/null || true

# Update mimeapps.list
MIMEAPPS="$HOME/.config/mimeapps.list"
if [ -f "$MIMEAPPS" ]; then
    sed -i '/inode\/directory=/d' "$MIMEAPPS"
    sed -i '/\[Default Applications\]/a inode/directory=thunar.desktop;' "$MIMEAPPS"
fi

# Set bash environment defaults
if ! grep -q 'export TERMINAL="kitty"' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export TERMINAL="kitty"' >> "$HOME/.bashrc"
fi
if ! grep -q 'export FILEMANAGER="thunar"' "$HOME/.bashrc" 2>/dev/null; then
    echo 'export FILEMANAGER="thunar"' >> "$HOME/.bashrc"
fi

echo "⚙️ [3.5/4] Deploying Hyprland and Quickshell configurations..."
mkdir -p "$HOME/.config/hypr" "$HOME/.config/quickshell"
cp -r "$SCRIPT_DIR/configs/hypr/"* "$HOME/.config/hypr/"
cp -r "$SCRIPT_DIR/configs/quickshell/"* "$HOME/.config/quickshell/"

echo "✨ [4/4] Verifying Configuration..."
echo "  • Hyprland config:  $HOME/.config/hypr/hyprland.conf"
echo "  • Quickshell bar:   $HOME/.config/quickshell/shell.qml"
echo "  • Hyprpaper config: $HOME/.config/hypr/hyprpaper.conf"
echo "  • Default terminal: $(xdg-mime query default x-scheme-handler/terminal 2>/dev/null || echo 'kitty')"
echo "  • Default files:    $(xdg-mime query default inode/directory 2>/dev/null)"

echo ""
echo "=================================================================="
echo "🎉 Hyprland + Quickshell Everforest Rice is fully installed!"
echo "👉 To start Hyprland now:"
echo "   1. Log out of Plasma (Super -> Leave -> Log Out, or SDDM)"
echo "   2. In the bottom-left of the SDDM login screen, select 'Hyprland'"
echo "   3. Log in to enter your new smooth Everforest Hyprland desktop!"
echo "=================================================================="
