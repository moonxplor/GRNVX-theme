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
        echo " Applying wallpaper: $(basename "$wp")..."
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
    echo " Applying Everforest Dark color scheme..."
    plasma-apply-colorscheme EverforestDark
}

apply_panels() {
    echo " Applying Everforest Waybar top pill preset and dock..."
    mkdir -p "$HOME/.config/panel-colorizer/presets"
    if [ -d "$SCRIPT_DIR/configs/panel-colorizer" ]; then
        cp -r "$SCRIPT_DIR/configs/panel-colorizer/"* "$HOME/.config/panel-colorizer/presets/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/icons" ]; then
        mkdir -p "$HOME/.local/share/plasma/desktoptheme/default/icons"
        cp "$SCRIPT_DIR/icons/"*.svg "$HOME/.local/share/plasma/desktoptheme/default/icons/" 2>/dev/null || true
        mkdir -p "$HOME/.local/share/icons/Tela-circle-dracula-dark/scalable/apps"
        mkdir -p "$HOME/.local/share/icons/hicolor/512x512/apps"
        cp "$SCRIPT_DIR/icons/garuda-eagle.svg" "$HOME/.local/share/icons/Tela-circle-dracula-dark/scalable/apps/garuda-eagle.svg" 2>/dev/null || true
        cp "$SCRIPT_DIR/icons/garuda-eagle.svg" "$HOME/.local/share/icons/Tela-circle-dracula-dark/scalable/apps/distributor-logo-garuda.svg" 2>/dev/null || true
        cp "$SCRIPT_DIR/icons/garuda-eagle.png" "$HOME/.local/share/icons/garuda-eagle.png" 2>/dev/null || true
        cp "$SCRIPT_DIR/icons/garuda-eagle.png" "$HOME/.local/share/icons/hicolor/512x512/apps/distributor-logo-garuda.png" 2>/dev/null || true
        cp "$SCRIPT_DIR/icons/garuda-eagle.png" "$HOME/.local/share/icons/hicolor/512x512/apps/garuda-eagle.png" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/kwin-scripts/dynamic-workspaces" ]; then
        mkdir -p "$HOME/.local/share/kwin/scripts/dynamic-workspaces"
        cp -r "$SCRIPT_DIR/configs/kwin-scripts/dynamic-workspaces/"* "$HOME/.local/share/kwin/scripts/dynamic-workspaces/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/desktoptheme" ]; then
        mkdir -p "$HOME/.local/share/plasma/desktoptheme/default"
        cp -r "$SCRIPT_DIR/configs/desktoptheme/"* "$HOME/.local/share/plasma/desktoptheme/default/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/panel-colorizer" ]; then
        mkdir -p "$HOME/.config/panel-colorizer/presets/Everforest Waybar"
        cp -r "$SCRIPT_DIR/configs/panel-colorizer/Everforest Waybar/"* "$HOME/.config/panel-colorizer/presets/Everforest Waybar/" 2>/dev/null || true
        if [ -f "$SCRIPT_DIR/configs/panel-colorizer/forceForegroundColor.json" ]; then
            cp -f "$SCRIPT_DIR/configs/panel-colorizer/forceForegroundColor.json" "$HOME/.config/panel-colorizer/" 2>/dev/null || true
            FORCE_FG=$(cat "$SCRIPT_DIR/configs/panel-colorizer/forceForegroundColor.json")
            kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 10 --group Configuration --group General --key forceForegroundColor "$FORCE_FG" 2>/dev/null || true
        fi
    fi
    if [ -d "$SCRIPT_DIR/configs/waybar" ]; then
        mkdir -p "$HOME/.config/waybar"
        cp -r "$SCRIPT_DIR/configs/waybar/"* "$HOME/.config/waybar/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/kitty" ]; then
        mkdir -p "$HOME/.config/kitty"
        cp -r "$SCRIPT_DIR/configs/kitty/"* "$HOME/.config/kitty/" 2>/dev/null || true
        killall -SIGUSR1 kitty 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/fastfetch" ]; then
        mkdir -p "$HOME/.config/fastfetch"
        cp -r "$SCRIPT_DIR/configs/fastfetch/"* "$HOME/.config/fastfetch/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/plasmoids" ]; then
        mkdir -p "$HOME/.local/share/plasma/plasmoids"
        cp -r "$SCRIPT_DIR/configs/plasmoids/"* "$HOME/.local/share/plasma/plasmoids/" 2>/dev/null || true
    fi
    if [ -d "$SCRIPT_DIR/configs/qml" ]; then
        mkdir -p "$HOME/.local/lib/qt6/qml/org/kde/plasma/core"
        mkdir -p "$HOME/.local/lib/qt6/qml/org/kde/plasma/workspace/calendar"
        cp -r "$SCRIPT_DIR/configs/qml/"* "$HOME/.local/lib/qt6/qml/" 2>/dev/null || true
        ln -sf /usr/lib/qt6/qml/org/kde/plasma/core/libcorebindingsplugin.so "$HOME/.local/lib/qt6/qml/org/kde/plasma/core/libcorebindingsplugin.so" 2>/dev/null || true
        cp -u /usr/lib/qt6/qml/org/kde/plasma/core/corebindingsplugin.qmltypes "$HOME/.local/lib/qt6/qml/org/kde/plasma/core/" 2>/dev/null || true
        ln -sf /usr/lib/qt6/qml/org/kde/plasma/workspace/calendar/libcalendarplugin.so "$HOME/.local/lib/qt6/qml/org/kde/plasma/workspace/calendar/libcalendarplugin.so" 2>/dev/null || true
        cp -u /usr/lib/qt6/qml/org/kde/plasma/workspace/calendar/calendarplugin.qmltypes "$HOME/.local/lib/qt6/qml/org/kde/plasma/workspace/calendar/" 2>/dev/null || true
        cp -u /usr/lib/qt6/qml/org/kde/plasma/workspace/calendar/kde-qmlmodule.version "$HOME/.local/lib/qt6/qml/org/kde/plasma/workspace/calendar/" 2>/dev/null || true
    fi
    
    # Configure System Tray compact sizing (~5cm x 5cm / 224x224 px) & Display Adjustments
    if [ -d "$SCRIPT_DIR/configs/systemtray-compact" ] && [ -f "$SCRIPT_DIR/src/libplasma_rcc_hook.cpp" ]; then
        echo " Compiling System Tray compact popup overrides & Display Adjuster..."
        mkdir -p "$HOME/.local/share/plasma" "$HOME/.local/lib" "$HOME/.config/environment.d" "$HOME/.local/bin" "$HOME/.config/autostart"
        
        # Install display adjustment script and autostart
        if [ -f "$SCRIPT_DIR/bin/plasma-apply-display-adjustments" ]; then
            cp -f "$SCRIPT_DIR/bin/plasma-apply-display-adjustments" "$HOME/.local/bin/"
            chmod +x "$HOME/.local/bin/plasma-apply-display-adjustments"
        fi
        if [ -f "$SCRIPT_DIR/configs/plasma-display-adjustments.desktop" ]; then
            cp -f "$SCRIPT_DIR/configs/plasma-display-adjustments.desktop" "$HOME/.config/autostart/"
        fi

        # Compile RCC binary overrides
        /usr/lib/qt6/rcc --binary "$SCRIPT_DIR/configs/systemtray-compact/overrides.qrc" -o "$HOME/.local/share/plasma/overrides.rcc" 2>/dev/null || true
        
        # Compile C++ QML DisplayAdjuster & RCC hook
        /usr/lib/qt6/moc "$SCRIPT_DIR/src/libplasma_rcc_hook.cpp" -o "$SCRIPT_DIR/src/libplasma_rcc_hook.moc" 2>/dev/null || true
        g++ -shared -fPIC -O2 $(pkg-config --cflags --libs Qt6Core Qt6Qml 2>/dev/null) "$SCRIPT_DIR/src/libplasma_rcc_hook.cpp" -o "$HOME/.local/lib/libplasma_rcc_hook.so" 2>/dev/null || true
        
        cat << 'ENVEOF' > "$HOME/.config/environment.d/10-plasma.conf"
QML2_IMPORT_PATH=/home/moonxplor/.local/lib/qt6/qml:/usr/lib/qt6/qml
QML_IMPORT_PATH=/home/moonxplor/.local/lib/qt6/qml:/usr/lib/qt6/qml
LD_PRELOAD=/home/moonxplor/.local/lib/libplasma_rcc_hook.so
QV4_FORCE_INTERPRETER=1
QML_DISABLE_DISK_CACHE=1
ENVEOF
        systemctl --user import-environment LD_PRELOAD QV4_FORCE_INTERPRETER QML_DISABLE_DISK_CACHE 2>/dev/null || true
    fi

    kwriteconfig6 --file plasmashellrc --group PlasmaViews --group "Panel 2" --key floating 1
    kwriteconfig6 --file plasmashellrc --group PlasmaViews --group "Panel 2" --key panelOpacity 2
    
    # Configure compact popup dimensions in appletsrc (Calendar & Tray Applets: 224x224 px ~ 5cm x 5cm)
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 37 --key popupWidth 480
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 37 --key popupHeight 400
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 8 --key plugin org.kde.plasma.compactclock
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 8 --key popupWidth 225
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 8 --key popupHeight 225
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 8 --group Configuration --key popupWidth 225
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 8 --group Configuration --key popupHeight 225
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 11 --key popupWidth 224
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 2 --group Applets --group 11 --key popupHeight 224

    # Configure Kickoff (icon, index, size) & Applets live
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var p = panels();
for (var i = 0; i < p.length; i++) {
    var panel = p[i];
    var widgets = panel.widgets();
    for (var j = 0; j < widgets.length; j++) {
        var w = widgets[j];
        if (w.type === 'org.kde.plasma.kickoff') {
            w.index = 0;
            w.globalShortcut = 'Alt+F1';
            w.currentConfigGroup = ['General'];
            w.writeConfig('icon', 'garuda-eagle');
            w.currentConfigGroup = [];
            w.writeConfig('popupWidth', 480);
            w.writeConfig('popupHeight', 400);
            w.reloadConfig();
        } else if (w.type === 'org.kde.plasma.digitalclock' || w.type === 'org.kde.plasma.compactclock') {
            w.currentConfigGroup = [];
            w.writeConfig('popupWidth', 225);
            w.writeConfig('popupHeight', 225);
            w.currentConfigGroup = ['Configuration'];
            w.writeConfig('popupWidth', 225);
            w.writeConfig('popupHeight', 225);
            w.reloadConfig();
        } else if (w.type === 'org.kde.plasma.systemtray') {
            w.currentConfigGroup = [];
            w.writeConfig('popupWidth', 224);
            w.writeConfig('popupHeight', 224);
            w.reloadConfig();
        }
    }
}
" 2>/dev/null || true


    qdbus6 luisbocanegra.panel.colorizer.c2.w10 /preset preset "$HOME/.config/panel-colorizer/presets/Everforest Waybar" 2>/dev/null || true
    qdbus6 luisbocanegra.panel.colorizer.c25.w26 /preset preset "$HOME/.config/panel-colorizer/presets/Everforest Dock" 2>/dev/null || true
}

reconfigure_kwin() {
    echo " Reconfiguring KWin window effects, launcher & dynamic workspace shortcuts..."
    kwriteconfig6 --file kwinrc --group Plugins --key desktopchangeosdEnabled false
    kwriteconfig6 --file kwinrc --group Plugins --key dynamic-workspacesEnabled true
    # Configure standalone Meta key to open Application Launcher (Plasma 6 native shortcut)
    kwriteconfig6 --file kglobalshortcutsrc --group plasmashell --key "activate application launcher" "Meta\tAlt+F1,Meta\tAlt+F1,Activate Application Launcher"
    
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

    # Standalone Super (Meta) & Alt+F1 for Application Launcher
    KEY_META = 16777250
    ALT_BASE = 134217728
    KEY_F1 = 16777264
    iface.setForeignShortcutKeys(
        dbus.Array(['plasmashell', 'activate application launcher', '', ''], signature='s'),
        dbus.Array([
            dbus.Struct((dbus.Array([dbus.Int32(KEY_META), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),)),
            dbus.Struct((dbus.Array([dbus.Int32(ALT_BASE + KEY_F1), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),))
        ], signature='(ai)')
    )

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

    # Super + Q to Close Window/Tab
    KEY_F4 = 16777267
    iface.setForeignShortcutKeys(dbus.Array(['plasmashell', 'manage activities', '', ''], signature='s'), empty)
    iface.setForeignShortcutKeys(
        dbus.Array(['kwin', 'Window Close', '', ''], signature='s'),
        dbus.Array([
            dbus.Struct((dbus.Array([dbus.Int32(META_BASE + ord('Q')), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),)),
            dbus.Struct((dbus.Array([dbus.Int32(ALT_BASE + KEY_F4), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),))
        ], signature='(ai)')
    )
    # Super + Enter to Open Terminal
    KEY_RETURN = 16777220
    KEY_ENTER = 16777221
    iface.setForeignShortcutKeys(
        dbus.Array(['org.kde.konsole.desktop', '_launch', 'Konsole', 'Konsole'], signature='s'),
        dbus.Array([
            dbus.Struct((dbus.Array([dbus.Int32(META_BASE + KEY_RETURN), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),)),
            dbus.Struct((dbus.Array([dbus.Int32(META_BASE + KEY_ENTER), dbus.Int32(0), dbus.Int32(0), dbus.Int32(0)], signature='i'),))
        ], signature='(ai)')
    )
except Exception:
    pass
" 2>/dev/null || true
}

restart_shell() {
    echo "Refreshing Plasma Shell..."
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
