#!/usr/bin/env python3
"""
Dynamic Wallpaper-Adaptive Transparency and Color Engine
Analyzes the active wallpaper's top & bottom regions to adapt Waybar / Panel
transparency, frosted tint, and borders for seamless visual harmony.
"""

import sys
import os
import json
import subprocess
from PIL import Image, ImageStat

def get_current_wallpaper():
    """Detect current wallpaper from plasma config or fallback."""
    config_path = os.path.expanduser("~/.config/plasma-org.kde.plasma.desktop-appletsrc")
    last_wp = None
    if os.path.exists(config_path):
        with open(config_path, "r", errors="ignore") as f:
            for line in f:
                if "Image=file://" in line:
                    path = line.strip().split("Image=file://")[-1]
                    if os.path.exists(path):
                        last_wp = path
    return last_wp or os.path.expanduser("~/Downloads/garuda-theme/wallpapers/neon_city_moon.png")

def adapt_to_wallpaper(wallpaper_path):
    if not os.path.exists(wallpaper_path):
        print(f"Error: Wallpaper {wallpaper_path} not found.")
        sys.exit(1)

    print(f"🖼️  Analyzing wallpaper: {os.path.basename(wallpaper_path)}...")
    im = Image.open(wallpaper_path).convert("RGB")
    w, h = im.size

    # 1. Top strip analysis (Waybar area: top 6% height)
    top_strip = im.crop((0, 0, w, max(1, int(h * 0.06))))
    top_stat = ImageStat.Stat(top_strip)
    top_avg = [int(v) for v in top_stat.mean]
    top_lum = 0.2126 * top_avg[0] + 0.7152 * top_avg[1] + 0.0722 * top_avg[2]

    # Calculate top background & alpha according to wallpaper luminance
    top_bg_r = max(5, int(top_avg[0] * 0.75))
    top_bg_g = max(10, int(top_avg[1] * 0.75))
    top_bg_b = max(5, int(top_avg[2] * 0.75))
    top_bg_hex = f"#{top_bg_r:02x}{top_bg_g:02x}{top_bg_b:02x}"

    if top_lum < 50:
        top_alpha = 0.18   # Sheer glass (82% transparent) on dark backgrounds
    elif top_lum < 110:
        top_alpha = 0.28   # 72% transparent on medium tones
    else:
        top_alpha = 0.45   # 55% transparent on brighter skies to maintain contrast

    # 2. Bottom strip analysis (Dock area: bottom 7% height)
    bot_strip = im.crop((0, max(0, int(h * 0.93)), w, h))
    bot_stat = ImageStat.Stat(bot_strip)
    bot_avg = [int(v) for v in bot_stat.mean]
    bot_lum = 0.2126 * bot_avg[0] + 0.7152 * bot_avg[1] + 0.0722 * bot_avg[2]

    bot_bg_r = max(5, int(bot_avg[0] * 0.75))
    bot_bg_g = max(10, int(bot_avg[1] * 0.75))
    bot_bg_b = max(5, int(bot_avg[2] * 0.75))
    bot_bg_hex = f"#{bot_bg_r:02x}{bot_bg_g:02x}{bot_bg_b:02x}"

    if bot_lum < 50:
        bot_alpha = 0.20
    elif bot_lum < 110:
        bot_alpha = 0.32
    else:
        bot_alpha = 0.50

    print(f"✨ Top Waybar:   tone={top_bg_hex}, alpha={top_alpha:.2f} ({int((1-top_alpha)*100)}% transparent, lum={top_lum:.1f})")
    print(f"✨ Bottom Dock:  tone={bot_bg_hex}, alpha={bot_alpha:.2f} ({int((1-bot_alpha)*100)}% transparent, lum={bot_lum:.1f})")

    # 3. Update Everforest Waybar preset (both the bar itself and widget pills)
    wb_preset_path = os.path.expanduser("~/.config/panel-colorizer/presets/Everforest Waybar/settings.json")
    if os.path.exists(wb_preset_path):
        with open(wb_preset_path, "r") as f:
            wb_data = json.load(f)

        # Top Panel background: adaptive tone and transparency
        p_norm = wb_data["globalSettings"]["panel"]["normal"]
        p_norm["enabled"] = True
        p_norm["blurBehind"] = True
        p_norm["backgroundColor"]["enabled"] = True
        p_norm["backgroundColor"]["sourceType"] = 0
        p_norm["backgroundColor"]["custom"] = top_bg_hex
        p_norm["backgroundColor"]["alpha"] = top_alpha

        # Widget pills inside top bar: matching adaptive tone and transparency
        w_norm = wb_data["globalSettings"]["widgets"]["normal"]
        w_norm["backgroundColor"]["sourceType"] = 0
        w_norm["backgroundColor"]["custom"] = top_bg_hex
        w_norm["backgroundColor"]["alpha"] = top_alpha
        w_norm["blurBehind"] = True

        if "trayWidgets" in wb_data["globalSettings"] and "normal" in wb_data["globalSettings"]["trayWidgets"]:
            t_norm = wb_data["globalSettings"]["trayWidgets"]["normal"]
            t_norm["backgroundColor"]["sourceType"] = 0
            t_norm["backgroundColor"]["custom"] = top_bg_hex
            t_norm["backgroundColor"]["alpha"] = top_alpha
            t_norm["blurBehind"] = True

        if "nativePanel" in wb_data["globalSettings"]:
            wb_data["globalSettings"]["nativePanel"]["background"]["enabled"] = True
            wb_data["globalSettings"]["nativePanel"]["background"]["opacity"] = 0
            wb_data["globalSettings"]["nativePanel"]["background"]["shadow"] = False

        with open(wb_preset_path, "w") as f:
            json.dump(wb_data, f, indent=2)

    # 4. Update Everforest Dock preset
    dock_preset_path = os.path.expanduser("~/.config/panel-colorizer/presets/Everforest Dock/settings.json")
    if os.path.exists(dock_preset_path):
        with open(dock_preset_path, "r") as f:
            dock_data = json.load(f)

        p_norm = dock_data["globalSettings"]["panel"]["normal"]
        p_norm["backgroundColor"]["custom"] = bot_bg_hex
        p_norm["backgroundColor"]["alpha"] = bot_alpha
        p_norm["blurBehind"] = True

        with open(dock_preset_path, "w") as f:
            json.dump(dock_data, f, indent=2)

    # 5. Update Waybar CSS
    css_path = os.path.expanduser("~/.config/waybar/style.css")
    if os.path.exists(css_path):
        with open(css_path, "r") as f:
            lines = f.readlines()
        with open(css_path, "w") as f:
            for line in lines:
                if "background: rgba(" in line and "/*" not in line:
                    line = f"  background: rgba({top_bg_r}, {top_bg_g}, {top_bg_b}, {top_alpha:.2f});\n"
                f.write(line)

    # 6. Push live updates via DBus
    subprocess.run(
        ["qdbus6", "luisbocanegra.panel.colorizer.c2.w10", "/preset", "preset",
         os.path.expanduser("~/.config/panel-colorizer/presets/Everforest Waybar")],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    subprocess.run(
        ["qdbus6", "luisbocanegra.panel.colorizer.c25.w26", "/preset", "preset",
         os.path.expanduser("~/.config/panel-colorizer/presets/Everforest Dock")],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )
    print("✅ Panels dynamically synchronized to wallpaper!")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        target = sys.argv[1]
    else:
        target = get_current_wallpaper()
    adapt_to_wallpaper(target)
