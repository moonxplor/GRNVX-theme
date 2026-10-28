#!/usr/bin/env bash
# ==============================================================================
# Hyprland Network Settings Dispatcher
# ==============================================================================

if command -v nm-connection-editor >/dev/null 2>&1; then
    nm-connection-editor
elif command -v plasma-open-settings >/dev/null 2>&1; then
    plasma-open-settings kcm_networkmanagement
elif [ -x "$HOME/.local/bin/kitty" ] && command -v nmtui >/dev/null 2>&1; then
    "$HOME/.local/bin/kitty" --class="nmtui-floating" -e nmtui
elif command -v nmtui >/dev/null 2>&1; then
    kitty -e nmtui
fi
