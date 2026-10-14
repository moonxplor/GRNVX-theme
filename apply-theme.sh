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
    if [ -d "$SCRIPT_DIR/configs/kwin-scripts/dynamic-workspaces" ]; then
        mkdir -p "$HOME/.local/share/kwin/scripts/dynamic-workspaces"
        cp -r "$SCRIPT_DIR/configs/kwin-scripts/dynamic-workspaces/"* "$HOME/.local/share/kwin/scripts/dynamic-workspaces/" 2>/dev/null || true
    fi
    kwriteconfig6 --file plasmashellrc --group PlasmaViews --group "Panel 2" --key floating 1
    kwriteconfig6 --file plasmashellrc --group PlasmaViews --group "Panel 2" --key panelOpacity 2
    
    # Position Kickoff at top-left corner (index 0) with Garuda icon
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var p = panels();
for (var i = 0; i < p.length; i++) {
    var panel = p[i];
    var widgets = panel.widgets();
    for (var j = 0; j < widgets.length; j++) {
        if (widgets[j].type === 'org.kde.plasma.kickoff') {
            var k = widgets[j];
            k.index = 0;
            k.currentConfigGroup = ['General'];
            k.writeConfig('icon', 'distributor-logo-garuda');
        }
    }
}
" 2>/dev/null || true

    qdbus6 luisbocanegra.panel.colorizer.c2.w10 /preset preset "$HOME/.config/panel-colorizer/presets/Everforest Waybar" 2>/dev/null || true
    qdbus6 luisbocanegra.panel.colorizer.c25.w26 /preset preset "$HOME/.config/panel-colorizer/presets/Everforest Dock" 2>/dev/null || true
}

reconfigure_kwin() {
    echo "✨ Reconfiguring KWin window effects, launcher & dynamic workspace shortcuts..."
    kwriteconfig6 --file kwinrc --group Plugins --key desktopchangeosdEnabled false
    kwriteconfig6 --file kwinrc --group Plugins --key dynamic-workspacesEnabled true
    kwriteconfig6 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell,/PlasmaShell,org.kde.PlasmaShell,activateLauncherMenu"
    
    # Reload dynamic-workspaces KWin script
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "dynamic-workspaces" 2>/dev/null || true
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "$HOME/.local/share/kwin/scripts/dynamic-workspaces/contents/code/main.js" "dynamic-workspaces" 2>/dev/null || true
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.start 2>/dev/null || true
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

    # Clear default shortcuts that conflict with Super+1..9
    for i in {1..9}; do
        kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Switch to Desktop $i" "none,none,Switch to Desktop $i"
        kwriteconfig6 --file kglobalshortcutsrc --group plasmashell --key "activate task manager entry $i" "none,none,Activate Task Manager Entry $i"
        kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "dynamic_workspace_switch_$i" "Meta+$i,Meta+$i,Switch or Create Workspace $i"
        kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "dynamic_workspace_move_$i" "Meta+Shift+$i,Meta+Shift+$i,Move Window to Workspace $i (Dynamic)"
    done

    # Overview shortcut Super + V
    kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "Overview" "Meta+V,Meta+W,Toggle Overview"

    # Screen recording shortcuts (PrtSc chords + Modifier fallbacks)
    kwriteconfig6 --file kglobalshortcutsrc --group "services" --group "org.kde.spectacle.desktop" --key "RecordScreen" "Print, F\tCtrl+Print,Meta+Alt+R,Record Screen"
    kwriteconfig6 --file kglobalshortcutsrc --group "services" --group "org.kde.spectacle.desktop" --key "RecordRegion" "Print, S\tShift+Print,Meta+Shift+R\tMeta+R,Record Rectangular Region"
    kwriteconfig6 --file kglobalshortcutsrc --group "services" --group "org.kde.spectacle.desktop" --key "RecordWindow" "Print, R\tMeta+Print,Meta+Ctrl+R,Record Active Window"

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

    # Super + V for Workspace Overview
    META_BASE = 268435456
    SHIFT_BASE = 33554432
    iface.setForeignShortcutKeys(dbus.Array(['kwin', 'Overview', '', ''], signature='s'), make_key(META_BASE + ord('V')))

    # Super + 1..9 for Dynamic Workspaces & Super + Shift + 1..9 for Move Window
    for i in range(1, 10):
        iface.setForeignShortcutKeys(dbus.Array(['kwin', f'Switch to Desktop {i}', '', ''], signature='s'), empty)
        iface.setForeignShortcutKeys(dbus.Array(['plasmashell', f'activate task manager entry {i}', '', ''], signature='s'), empty)
        iface.setForeignShortcutKeys(dbus.Array(['kwin', f'dynamic_workspace_switch_{i}', '', ''], signature='s'), make_key(META_BASE + ord(str(i))))
        iface.setForeignShortcutKeys(dbus.Array(['kwin', f'dynamic_workspace_move_{i}', '', ''], signature='s'), make_key(META_BASE + SHIFT_BASE + ord(str(i))))
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
