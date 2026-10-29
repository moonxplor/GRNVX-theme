#!/usr/bin/env bash
# ==============================================================================
# Hyprland Power / Leave Menu
# Provides a fast dialog for Lock, Logout, Suspend, Reboot, and Shutdown
# ==============================================================================

export PATH="/home/moonxplor/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

if command -v wlogout >/dev/null 2>&1; then
    wlogout
    exit 0
fi

do_action() {
    local action="$1"
    case "$action" in
        *"Lock"*)
            if command -v hyprlock >/dev/null 2>&1; then
                hyprlock
            elif command -v swaylock >/dev/null 2>&1; then
                swaylock
            else
                loginctl lock-session
            fi
            ;;
        *"Log Out"*|*"Logout"*)
            hyprctl dispatch exit 2>/dev/null || loginctl terminate-user "$USER"
            ;;
        *"Suspend"*)
            systemctl suspend
            ;;
        *"Reboot"*)
            systemctl reboot
            ;;
        *"Shut Down"*|*"Shutdown"*|*"Power"*)
            systemctl poweroff
            ;;
    esac
}

if command -v zenity >/dev/null 2>&1; then
    CHOICE=$(zenity --list --title="Power Menu" --text="Choose an action:" \
        --column="Action" \
        "Lock Screen" \
        "Log Out" \
        "Suspend" \
        "Reboot" \
        "Shut Down" \
        --height=280 --width=300 2>/dev/null)
    [ -n "$CHOICE" ] && do_action "$CHOICE"
    exit 0
fi

if command -v yad >/dev/null 2>&1; then
    CHOICE=$(yad --list --title="Power Menu" --text="Choose an action:" \
        --column="Action" \
        "Lock Screen" \
        "Log Out" \
        "Suspend" \
        "Reboot" \
        "Shut Down" \
        --height=280 --width=300 --center --on-top 2>/dev/null)
    [ -n "$CHOICE" ] && do_action "$CHOICE"
    exit 0
fi

if command -v rofi >/dev/null 2>&1; then
    CHOICE=$(printf "Lock Screen\nLog Out\nSuspend\nReboot\nShut Down" | rofi -dmenu -p "Power Menu")
    [ -n "$CHOICE" ] && do_action "$CHOICE"
    exit 0
fi

# Fallback: exit Hyprland session
hyprctl dispatch exit 2>/dev/null || loginctl terminate-user "$USER"
