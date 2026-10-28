#!/usr/bin/env bash
# ==============================================================================
# Hyprland Power / Leave Menu
# Provides a fast dialog for Lock, Logout, Suspend, Reboot, and Shutdown
# ==============================================================================

if command -v wlogout >/dev/null 2>&1; then
    wlogout
    exit 0
fi

if command -v zenity >/dev/null 2>&1; then
    CHOICE=$(zenity --list --title="Power Menu" --text="Choose an action:" \
        --column="Action" \
        "Lock Screen" \
        "Log Out" \
        "Suspend" \
        "Reboot" \
        "Shut Down" \
        --height=280 --width=300 2>/dev/null)

    case "$CHOICE" in
        "Lock Screen")
            if command -v hyprlock >/dev/null 2>&1; then
                hyprlock
            elif command -v swaylock >/dev/null 2>&1; then
                swaylock
            elif command -v loginctl >/dev/null 2>&1; then
                loginctl lock-session
            fi
            ;;
        "Log Out")
            hyprctl dispatch exit 2>/dev/null || loginctl terminate-user "$USER"
            ;;
        "Suspend")
            systemctl suspend
            ;;
        "Reboot")
            systemctl reboot
            ;;
        "Shut Down")
            systemctl poweroff
            ;;
    esac
    exit 0
fi

if command -v rofi >/dev/null 2>&1; then
    CHOICE=$(printf "Lock Screen\nLog Out\nSuspend\nReboot\nShut Down" | rofi -dmenu -p "Power Menu")
    case "$CHOICE" in
        "Lock Screen") loginctl lock-session ;;
        "Log Out") hyprctl dispatch exit ;;
        "Suspend") systemctl suspend ;;
        "Reboot") systemctl reboot ;;
        "Shut Down") systemctl poweroff ;;
    esac
    exit 0
fi

# Fallback: confirm logout
hyprctl dispatch exit 2>/dev/null || loginctl terminate-user "$USER"
