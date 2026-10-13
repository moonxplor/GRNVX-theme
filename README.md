# 🌲 GRNVX-theme

> **A minimal, cohesive Everforest green rice for Garuda Linux & Arch Linux.**  
> Crafted with a Waybar-style pill topbar, custom status icons, smooth workspace navigation, and curated wallpapers for both **KDE Plasma 6** and **Hyprland**.

---

## ✨ Features

- **Everforest Dark Palette**: Deep earthy tones (`#2d353b`, `#232a2e`) balanced with soft sage (`#a7c080`) and calm cyan (`#70c0ba`) accents.
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
  - **Hyprland + Quickshell** mode for lightweight Wayland tiling.
- **Curated Wallpapers**: 6 high-res wallpapers designed to complement the Everforest color scheme.

---

## 📁 Repository Structure

```text
GRNVX-theme/
├── apply-theme.sh       # All-in-one rice applicator for KDE Plasma
├── plasma.sh            # Safe helper to prepare standalone Hyprland or purge Plasma
├── hyprland.sh          # Hyprland + Quickshell standalone installer & config
├── adapt_waybar.py      # Palette extraction script matching bar colors to wallpaper
├── configs/
│   ├── kwin-scripts/    # Dynamic workspaces KWin 6 automation script
│   ├── panel-colorizer/ # 'Everforest Waybar' and 'Everforest Dock' presets
│   ├── hypr/            # Hyprland and Hyprpaper configurations
│   └── quickshell/      # Modern Waybar-like Quickshell bar configuration
├── icons/               # Pixel-crafted SVG icons (audio, battery, bluetooth)
└── wallpapers/          # Curated high-resolution Everforest backgrounds
```

---

## 🚀 Installation & Usage

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
If migrating to standalone Hyprland:

```bash
# Step 1: Install standalone tools & enable SDDM
./plasma.sh --prep

# Step 2: Log out, switch session to Hyprland, and clean up
./plasma.sh --purge
```

---

## ⌨️ Keybindings (Plasma 6)

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

---

## 📜 License
MIT License. Feel free to use, modify, and rice your setup!
# GRNVX-theme
