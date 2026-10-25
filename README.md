# GRNVX-theme

> **A minimal, cohesive green rice for Garuda Linux & Arch Linux.**  
> Crafted with a Waybar-style pill topbar, custom status icons, smooth workspace navigation, and curated wallpapers for both **KDE Plasma 6** and **Hyprland**.

## Features
>>>>>>> 14c8eed (updated)

- ** Dark Palette**: Deep earthy tones (`#2d353b`, `#232a2e`) balanced with soft sage (`#a7c080`) and calm cyan (`#70c0ba`) accents.
- **Waybar Aesthetic on Plasma 6**: Floating top pill bar and dock powered by `panel-colorizer` with subtle borders and shadows.
  - **Top-Left App Launcher**: Sleek Garuda-branded launcher pill anchored at the far top-left corner (`x=0`), triggered by standalone <kbd>Super</kbd>.
  - **Dynamic Workspaces**: Workspaces expand seamlessly on demand; pressing <kbd>Super</kbd> + <kbd>1</kbd>..<kbd>9</kbd> jumps to that workspace and auto-creates it if it doesn't already exist.
  - **Clean Status Tray**: Distraction-free top bar with volume, bluetooth, battery, brightness, and network status pills.
- **Custom Clean Status Icons**:
  - 󰕾 **Audio**: Cyan acoustic-wave speaker icon.
  - 󰂯 **Bluetooth**: Pure white Nordic rune with zero visual clutter.
  - 󰁹 **Battery**: Sleek vertical battery gauge without overlapping percentage numbers.
- **Smooth Workspace Switching**:
  - Seamless navigation using <kbd>Super</kbd> + <kbd>→</kbd> / <kbd>←</kbd>.
  - Overview screen on <kbd>Super</kbd> + <kbd>V</kbd> to inspect, add (`+`), or remove (`✕`) desktops manually.
  - Disabled popup arrow OSD transitions and desktop close buttons for a distraction-free workflow.
- **Dual Desktop Experience**:
  - **KDE Plasma 6** mode with native panel styling.
  - **Hyprland + Quickshell** mode for lightweight Wayland tiling:
    - Native Lua config (`hyprland.lua`) for clean, deprecation-free syntax with Hyprland 0.56+.
    - Modern block-syntax `hyprpaper` setup.
    - Custom QML **Quickshell** pill top bar with live telemetry (Volume, Brightness, Battery, WiFi, Clock, and Workspaces).
- **Curated Wallpapers**: 6 high-res wallpapers designed to complement the Everforest color scheme.

---

##  Repository Structure

```text
GRNVX-theme/
├── apply-theme.sh       # All-in-one rice applicator for KDE Plasma
├── plasma.sh            # Safe helper to prepare standalone Hyprland or purge Plasma
├── hyprland.sh          # Hyprland + Quickshell standalone installer & config
├── adapt_waybar.py      # Palette extraction script matching bar colors to wallpaper
├── bin/
│   ├── hypr-status.sh   # High-speed status telemetry provider for Quickshell
│   ├── hypr-launcher.sh # Application launcher dispatcher (rofi/wofi/krunner fallback)
│   └── hypr-screenshot.sh # Screenshot dispatcher (grim+slurp / spectacle fallback)
├── configs/
│   ├── kwin-scripts/    # Dynamic workspaces KWin 6 automation script
│   ├── panel-colorizer/ # 'Everforest Waybar' and 'Everforest Dock' presets
│   ├── hypr/
│   │   ├── hyprland.lua # Modern native Lua configuration for Hyprland
│   │   ├── hyprland.conf# Legacy configuration backup
│   │   └── hyprpaper.conf # Block-syntax wallpaper configuration (Hyprpaper 0.8+)
│   └── quickshell/
│       └── shell.qml    # Modern Waybar-like Quickshell bar configuration
├── icons/               # Pixel-crafted SVG icons (audio, battery, bluetooth)
└── wallpapers/          # Curated high-resolution Everforest backgrounds
```

---

## Installation & Usage

### 1. Apply the Theme on KDE Plasma 6
To apply the entire rice (wallpapers, panel presets, custom icons, and KWin shortcuts):

```bash
git clone https://github.com/moonxplor/GRNVX-theme.git
cd GRNVX-theme
chmod +x *.sh
./apply-theme.sh all
```

### 2. Switch Wallpapers
Easily cycle through included wallpapers:

```bash
./apply-theme.sh wp city       # Neon City Moon
./apply-theme.sh wp subway     # Neon Subway Trails
./apply-theme.sh wp street     # Street Taxi
./apply-theme.sh wp space      # Space is the Place
./apply-theme.sh wp forest     # Misty Forest
./apply-theme.sh wp futuristic # Futuristic Green
```

### 3. Hyprland + Quickshell Mode (Optional)
To install and deploy the standalone Hyprland and Quickshell rice:

```bash
# Automated installer (packages, defaults, Lua configs, Quickshell bar)
./hyprland.sh
```

Or if migrating from KDE Plasma and purging Plasma completely:

```bash
# Step 1: Install standalone tools & enable SDDM
./plasma.sh --prep

# Step 2: Log out, switch session to Hyprland in SDDM, and clean up Plasma
./plasma.sh --purge
```

---

## Keybindings

### KDE Plasma 6

| Shortcut | Action |
| :--- | :--- |
| <kbd>Super</kbd> | Open App Launcher (Top-Left corner) |
| <kbd>Super</kbd> + <kbd>1</kbd> .. <kbd>9</kbd> | **Open & Dynamically Create** Workspace 1 through 9 |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> .. <kbd>9</kbd> | Move Active Window to Workspace 1 through 9 (Auto-creates if needed) |
| <kbd>Super</kbd> + <kbd>V</kbd> | **Workspace Overview** (View all workspaces, add `+` or remove `✕` manually) |
| <kbd>Super</kbd> + <kbd>→</kbd> | Switch to Next Workspace |
| <kbd>Super</kbd> + <kbd>←</kbd> | Switch to Previous Workspace |
| <kbd>Super</kbd> + <kbd>Return</kbd> | Launch Kitty Terminal |
| <kbd>Super</kbd> + <kbd>E</kbd> | Open File Manager (Thunar) |
| <kbd>Super</kbd> + <kbd>Q</kbd> | **Close Active Window / Tab** |
| <kbd>PrtSc</kbd>, then <kbd>F</kbd> *(or <kbd>Ctrl</kbd> + <kbd>PrtSc</kbd>)* | **Record Full Screen** |
| <kbd>PrtSc</kbd>, then <kbd>S</kbd> *(or <kbd>Shift</kbd> + <kbd>PrtSc</kbd>)* | **Record Selected Region** |
| <kbd>PrtSc</kbd>, then <kbd>R</kbd> *(or <kbd>Super</kbd> + <kbd>PrtSc</kbd>)* | **Record Active Window** |

### Hyprland

| Shortcut | Action |
| :--- | :--- |
| <kbd>Super</kbd> *(Tap)* | **Open / Toggle App Launcher** (Rofi / Wofi / KRunner) |
| <kbd>Super</kbd> + <kbd>Space</kbd> | Open / Toggle App Launcher |
| <kbd>Super</kbd> + <kbd>Return</kbd> | Launch Kitty Terminal |
| <kbd>Super</kbd> + <kbd>E</kbd> | Open File Manager (Thunar) |
| <kbd>Super</kbd> + <kbd>D</kbd> | Open Web Browser (Brave / Firefox) |
| <kbd>Super</kbd> + <kbd>Q</kbd> *(or <kbd>Super</kbd> + <kbd>C</kbd>)* | **Close Active Window** |
| <kbd>Super</kbd> + <kbd>F</kbd> | Toggle Fullscreen |
| <kbd>Super</kbd> + <kbd>V</kbd> | Toggle Floating Mode |
| <kbd>Super</kbd> + <kbd>S</kbd> | Toggle Dwindle Split Layout |
| <kbd>Super</kbd> + <kbd>1</kbd> .. <kbd>7</kbd> | Switch to Workspace 1 through 7 |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> .. <kbd>7</kbd> | Move Active Window to Workspace 1 through 7 |
| <kbd>Super</kbd> + <kbd>→</kbd> / <kbd>←</kbd> | Switch to Next / Previous Workspace |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>→</kbd> / <kbd>←</kbd> | Move Active Window to Next / Previous Workspace |
| <kbd>Super</kbd> + <kbd>H</kbd> / <kbd>J</kbd> / <kbd>K</kbd> / <kbd>L</kbd> | Move Window Focus Left / Down / Up / Right (Vim-style) |
| <kbd>Print</kbd> / <kbd>PrtSc</kbd> | **Capture Region Screenshot** (Interactive selection; copied to clipboard & saved to `~/Pictures/Screenshots/`) |
| <kbd>Shift</kbd> + <kbd>Print</kbd> | **Capture Fullscreen Screenshot** (Copied to clipboard & saved to `~/Pictures/Screenshots/`) |
| <kbd>Volume Up / Down / Mute</kbd> | Adjust or Toggle Audio Volume (`wpctl`) |
| <kbd>Brightness Up / Down</kbd> | Adjust Display Brightness (`brightnessctl`) |

---

## License
MIT License. Feel free to use, modify, and rice your setup!
