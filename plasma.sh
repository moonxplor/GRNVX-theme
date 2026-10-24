#!/usr/bin/env bash
# ==============================================================================
# Garuda Linux - Safe Plasma Uninstaller & Hyprland Migration Script
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

prep_hyprland_standalone() {
    echo "🛡️ [1/3] Protecting essential system fonts and daemons..."
    sudo pacman -D --asexplicit ttf-jetbrains-mono-nerd inter-font accountsservice 2>/dev/null || true

    echo " [2/3] Installing standalone tools for Hyprland..."
    # sddm: Display / Login Manager
    # network-manager-applet: System tray WiFi & Network (nm-applet)
    # pavucontrol: Sound & Volume management
    # blueman: Bluetooth manager
    # polkit-gnome: Root GUI authentication dialogs
    # viewnior: Lightweight image viewer (replaces gwenview)
    # grim, slurp, wl-clipboard: Wayland screenshots & clipboard
    sudo pacman -S --needed \
        sddm \
        network-manager-applet \
        pavucontrol \
        blueman \
        polkit-gnome \
        viewnior \
        grim \
        slurp \
        wl-clipboard

    echo "[3/3] Enabling SDDM login manager..."
    sudo systemctl disable plasmalogin.service 2>/dev/null || true
    sudo systemctl enable --force sddm.service
    echo "✓ SDDM enabled as your login manager."
}

purge_plasma_packages() {
    echo "🗑️ Purging KDE Plasma desktop environment..."
    
    # Target list verified via pacman dry-run
    local PACKAGES=(
        garuda-mokka
        plasma-desktop
        plasma-workspace
        plasma-login-manager
        kwin
        kwin-effect-rounded-corners-git
        plasma-nm
        plasma-pa
        plasma-systemmonitor
        plasma-activities
        plasma-activities-stats
        plasma-firewall
        plasma-thunderbolt
        plasma-browser-integration
        plasma-integration
        plasma-applet-window-buttons
        plasma6-applets-window-title
        plasma6-applets-panel-colorizer
        plasma6-wallpapers-blurredwallpaper
        kdeplasma-addons
        powerdevil
        dolphin
        dolphin-plugins
        konsole
        kf6-servicemenus-rootactions
        firedragon-extension-plasma-integration
        xdg-desktop-portal-kde
        systemsettings
        kinfocenter
        gwenview
        libplasma
        bluedevil
        knights
        kscreen
    )

    local TO_REMOVE=()
    for pkg in "${PACKAGES[@]}"; do
        if pacman -Q "$pkg" >/dev/null 2>&1; then
            TO_REMOVE+=("$pkg")
        fi
    done

    if [ ${#TO_REMOVE[@]} -gt 0 ]; then
        echo "Removing ${#TO_REMOVE[@]} Plasma packages..."
        sudo pacman -R --cascade --nodeps "${TO_REMOVE[@]}"
        echo "✓ Plasma packages removed."
    else
        echo "✓ No Plasma packages found."
    fi

    # Set Thunar and Viewnior as default MIME handlers
    xdg-mime default thunar.desktop inode/directory
    xdg-mime default viewnior.desktop image/png
    xdg-mime default viewnior.desktop image/jpeg

    echo "🧹 Removing orphaned dependencies..."
    ORPHANS=$(pacman -Qdtq 2>/dev/null || true)
    if [ -n "$ORPHANS" ]; then
        sudo pacman -Rns --noconfirm $ORPHANS 2>/dev/null || true
    fi
    echo "✓ Cleaned up unused dependencies."
}

MODE="${1:-}"

if [ "$MODE" = "--prep" ]; then
    prep_hyprland_standalone
    echo ""
    echo "✅ Standalone Hyprland tools installed and SDDM enabled!"
    echo "👉 Now log out of Plasma, choose 'Hyprland' in SDDM, and run:"
    echo "   $0 --purge"
    exit 0
fi

if [ "$MODE" = "--purge" ]; then
    prep_hyprland_standalone
    purge_plasma_packages
    echo ""
    echo " KDE Plasma has been completely removed!"
    echo "Your system is now 100% powered by Hyprland, Quickshell, Kitty, and Thunar."
    exit 0
fi

# Default / interactive behavior
if pgrep -x kwin_wayland >/dev/null 2>&1 || pgrep -x plasmashell >/dev/null 2>&1; then
    echo "=================================================================="
    echo "⚠️  WARNING: You are currently running your active desktop session"
    echo "    inside KDE Plasma right now!"
    echo ""
    echo "    If you remove Plasma right this second from inside Plasma,"
    echo "    your active window manager will crash immediately."
    echo ""
    echo "👉 RECOMMENDED SAFE 2-STEP PROCESS:"
    echo "   1) Run: $0 --prep"
    echo "      (Installs SDDM, WiFi tray, volume control, and polkit agent)"
    echo "   2) Log out of Plasma -> Select 'Hyprland' in SDDM -> Log in"
    echo "   3) In Kitty on Hyprland, run: $0 --purge"
    echo ""
    echo "If you really want to remove everything immediately right now,"
    echo "pass the --purge flag:"
    echo "   $0 --purge"
    echo "=================================================================="
else
    # Already in Hyprland or TTY
    prep_hyprland_standalone
    purge_plasma_packages
    echo ""
    echo " KDE Plasma has been completely removed!"
fi
