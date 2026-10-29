-- ==============================================================================
-- Garuda Linux - Everforest Hyprland Lua Configuration
-- Styled with Everforest Dark palette & smooth sliding animations
-- ==============================================================================

-- Monitors
hl.monitor({
    output   = "eDP-1",
    mode     = "1366x768@60",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Default Applications
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = (os.getenv("HOME") or "/home/moonxplor") .. "/.local/bin/hypr-launcher.sh"
local browser     = "brave"
local screenshot  = (os.getenv("HOME") or "/home/moonxplor") .. "/.local/bin/hypr-screenshot.sh"

-- Autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("/home/moonxplor/Downloads/garuda-theme/apply-theme.sh wallpaper subway")
end)

-- Environment Variables
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("TERMINAL", "kitty")
hl.env("PATH", (os.getenv("HOME") or "/home/moonxplor") .. "/.local/bin:" .. (os.getenv("PATH") or "/usr/local/bin:/usr/bin:/bin"))

-- Input & Gestures
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            scroll_factor = 0.4,
        },
    },
    gestures = {
        workspace_swipe_distance = 300,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- General Styling & Decorations (Everforest Dark Palette)
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = { colors = {"rgb(a7c080)", "rgb(83c092)"}, angle = 45 },
            inactive_border = "rgb(2d353b)",
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.97,
        inactive_opacity = 0.88,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            new_optimizations = true,
            xray = false,
        },
        shadow = {
            enabled = true,
            range = 14,
            render_power = 3,
            color = "rgba(00000066)",
        },
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        background_color = 0x1e2326,
    },
})

-- Animations
hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "myBezier", style = "slide" })

-- Window Rules
hl.window_rule({
    name = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "float-pavucontrol-blueman",
    match = { class = "^(pavucontrol|blueman-manager|zenity|yad)$" },
    float = true,
})

hl.window_rule({
    name = "center-dialogs",
    match = { class = "^(zenity|yad)$" },
    center = true,
})

hl.window_rule({
    name = "opacity-kitty",
    match = { class = "^(kitty)$" },
    opacity = "1.0 1.0",
})

hl.window_rule({
    name = "opacity-thunar",
    match = { class = "^(thunar)$" },
    opacity = "0.95 0.90",
})

-- Keybindings
local mainMod = "SUPER"

-- App Launcher (Tap Super or Super+Space)
hl.bind("SUPER + SUPER_L",      hl.dsp.exec_cmd(menu), { release = true })
hl.bind("SUPER + SUPER_R",      hl.dsp.exec_cmd(menu), { release = true })
hl.bind(mainMod .. " + Space",  hl.dsp.exec_cmd(menu))

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + C",      hl.dsp.window.close())
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen(0))
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mainMod .. " + S",      hl.dsp.layout("togglesplit"))

-- Workspaces switching
hl.bind(mainMod .. " + right",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + left",   hl.dsp.focus({ workspace = "e-1" }))

for i = 1, 7 do
    hl.bind(mainMod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

-- Move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + ALT + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.focus({ direction = "down" }))

-- Move active window across workspaces
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "e-1" }))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set +5%"),                           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 5%-"),                            { locked = true, repeating = true })

-- Screenshots (Print = selection, SHIFT+Print = fullscreen)
hl.bind("Print",         hl.dsp.exec_cmd(screenshot .. " region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(screenshot .. " full"))

-- Power & Session Management (Physical Power key + Super+Escape)
hl.bind("XF86PowerOff",         hl.dsp.exec_cmd("/home/moonxplor/.local/bin/hypr-power.sh"), { locked = true })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("/home/moonxplor/.local/bin/hypr-power.sh"))
