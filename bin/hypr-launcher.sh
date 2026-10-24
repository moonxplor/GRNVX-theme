#!/usr/bin/env bash
# ==============================================================================
# Hyprland Application Launcher Dispatcher
# Supports rofi, wofi, and krunner fallbacks
# ==============================================================================

if command -v rofi >/dev/null 2>&1; then
    if pgrep -x rofi >/dev/null 2>&1; then
        pkill -x rofi
    else
        rofi -show drun -show-icons
    fi
elif command -v wofi >/dev/null 2>&1; then
    if pgrep -x wofi >/dev/null 2>&1; then
        pkill -x wofi
    else
        wofi --show drun
    fi
elif command -v krunner >/dev/null 2>&1; then
    krunner
fi
