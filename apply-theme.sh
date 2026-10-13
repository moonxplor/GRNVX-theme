#!/usr/bin/env bash
# ==============================================================================
# Garuda Linux Everforest / Green Rice Switcher & Applicator
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_DIR="$SCRIPT_DIR/wallpapers"

apply_wallpaper() {
    local target="$1"
    local wp=""

    case "$target" in
        city|moon)
            wp="$WALLPAPER_DIR/neon_city_moon.png"
            ;;
        subway|train|tunnel)
            wp="$WALLPAPER_DIR/neon_subway_trails.png"
            ;;
        street|taxi)
            wp="$WALLPAPER_DIR/neon_street_taxi.png"
            ;;
        space|alien)
            wp="$WALLPAPER_DIR/space_is_the_place.png"
            ;;
        valley)
            wp="$WALLPAPER_DIR/foggy_valley.png"
            ;;
        forest|mist)
            wp="$WALLPAPER_DIR/mist_forest.png"
            ;;
        succulent)
            wp="$WALLPAPER_DIR/succulent.png"
            ;;
        futuristic)
            wp="$WALLPAPER_DIR/futuristic_green.png"
            ;;
        *)
            if [ -n "$target" ] && [ -f "$target" ]; then
                wp="$target"
            elif [ -n "$target" ] && [ -f "$WALLPAPER_DIR/$target" ]; then
                wp="$WALLPAPER_DIR/$target"
            else
                wp="$WALLPAPER_DIR/neon_city_moon.png"
            fi
            ;;
    esac

    if [ -f "$wp" ]; then
        echo "🌲 Applying wallpaper: $(basename "$wp")..."
        if pgrep -x Hyprland >/dev/null 2>&1; then
            hyprctl hyprpaper preload "$wp" 2>/dev/null || true
            hyprctl hyprpaper wallpaper "eDP-1,$wp" 2>/dev/null || true
            hyprctl hyprpaper wallpaper ",$wp" 2>/dev/null || true
        elif command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
            plasma-apply-wallpaperimage "$wp" 2>/dev/null || true
        fi
        if [ -f "$SCRIPT_DIR/adapt_waybar.py" ]; then
            python3 "$SCRIPT_DIR/adapt_waybar.py" "$wp" 2>/dev/null || true
        fi
    else
        echo "❌ Wallpaper not found: $wp"
    fi
}

apply_colorscheme() {
    echo "🎨 Applying Everforest Dark color scheme..."
    plasma-apply-colorscheme EverforestDark
}

apply_panels() {
    echo "🌿 Applying Everforest Waybar top pill preset and dock..."
    mkdir -p "$HOME/.config/panel-colorizer/presets"
    if [ -d "$SCRIPT_DIR/configs/panel-colorizer" ]; then
        cp -r "$SCRIPT_DIR/configs/panel-colorizer/"* "$HOME/.config/panel-colorizer/presets/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/icons" ]; then
        mkdir -p "$HOME/.local/share/plasma/desktoptheme/default/icons"
        cp "$SCRIPT_DIR/icons/"*.svg "$HOME/.local/share/plasma/desktoptheme/default/icons/" 2>/dev/null || true
    fi
    kwriteconfig6 --file plasmashellrc --group PlasmaViews --group "Panel 2" --key floating 1
    kwriteconfig6 --file plasmashellrc --group PlasmaViews --group "Panel 2" --key panelOpacity 2
    qdbus6 luisbocanegra.panel.colorizer.c2.w10 /preset preset "$HOME/.config/panel-colorizer/presets/Everforest Waybar" 2>/dev/null || true
    qdbus6 luisbocanegra.panel.colorizer.c25.w26 /preset preset "$HOME/.config/panel-colorizer/presets/Everforest Dock" 2>/dev/null || true
}

reconfigure_kwin() {
    echo "✨ Reconfiguring KWin window effects & workspace shortcuts..."
    kwriteconfig6 --file kwinrc --group Plugins --key desktopchangeosdEnabled false
    kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
    python3 -c "
import dbus
try:
    bus = dbus.SessionBus()
    kg = bus.get_object('org.kde.kglobalaccel', '/kglobalaccel')
    iface = dbus.Interface(kg, 'org.kde.KGlobalAccel')
    empty = dbus.Array([], signature='(ai)')
    left = dbus.Array([dbus.Struct((dbus.Array([dbus.Int32(285212690), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),))], signature='(ai)')
    right = dbus.Array([dbus.Struct((dbus.Array([dbus.Int32(285212692), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),))], signature='(ai)')
    def make_key(code):
        return dbus.Array([dbus.Struct((dbus.Array([dbus.Int32(code), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),))], signature='(ai)')

    # Clear conflicting shortcuts
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Window Quick Tile Left', '', ''], signature='s'), empty)
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Window Quick Tile Right', '', ''], signature='s'), empty)
    iface.setForeignShortcutKeys(dbus.Array(['plasmashell', 'show-on-mouse-pos', '', ''], signature='s'), empty)

    # Super + Arrows
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Switch One Desktop to the Left', '', ''], signature='s'), left)
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Switch One Desktop to the Right', '', ''], signature='s'), right)
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Switch to Previous Desktop', '', ''], signature='s'), left)
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Switch to Next Desktop', '', ''], signature='s'), right)

    # Super + 1..9 for Workspaces 1..9
    META_BASE = 268435456
    for i in range(1, 10):
        iface.setForeignShortcutKeys(dbus.Array(['plasmashell', f'activate task manager entry {i}', '', ''], signature='s'), empty)
        iface.setForeignShortcutKeys(dbus.Array(['kwin', f'Switch to Desktop {i}', '', ''], signature='s'), make_key(META_BASE + ord(str(i))))

    # Super + V for Workspace Overview
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Overview', '', ''], signature='s'), make_key(META_BASE + ord('V')))

    # Ensure 9 Virtual Desktops exist and are named 1..9
    vdm = bus.get_object('org.kde.KWin', '/VirtualDesktopManager')
    vdm_iface = dbus.Interface(vdm, 'org.kde.KWin.VirtualDesktopManager')
    prop_iface = dbus.Interface(vdm, 'org.freedesktop.DBus.Properties')
    desktops = prop_iface.Get('org.kde.KWin.VirtualDesktopManager', 'desktops')
    count = len(desktops)
    for pos, id_str, _ in sorted(desktops, key=lambda x: x[0]):
        vdm_iface.setDesktopName(id_str, str(pos + 1))
    while count < 9:
        vdm_iface.createDesktop(count, str(count + 1))
        count += 1
except Exception:
    pass
" 2>/dev/null || true
}

restart_shell() {
    echo "🔄 Refreshing Plasma Shell..."
    systemctl --user restart plasma-plasmashell.service
    sleep 1.5
    apply_panels
}

case "$1" in
    wp|wallpaper)
        apply_wallpaper "$2"
        ;;
    panel|panels)
        apply_panels
        ;;
    colors|color)
        apply_colorscheme
        ;;
    restart|reload)
        restart_shell
        ;;
    all|"")
        apply_wallpaper "${2:-city}"
        apply_colorscheme
        reconfigure_kwin
        restart_shell
        echo "✅ Everforest Green rice successfully applied and refreshed!"
        ;;
    *)
        echo "Usage: $0 [all [theme_name]|wallpaper <city|subway|street|space|valley|forest>|panels|colors|restart]"
        exit 1
        ;;
esac
