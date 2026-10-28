#!/usr/bin/env bash
# ==============================================================================
# Hyprland Bluetooth Settings Dispatcher
# ==============================================================================

if command -v blueman-manager >/dev/null 2>&1; then
    blueman-manager
elif command -v plasma-open-settings >/dev/null 2>&1; then
    plasma-open-settings kcm_bluetooth
fi
