#!/usr/bin/env bash
# ==============================================================================
# Hyprland Screenshot Dispatcher
# Supports region and fullscreen modes with grim/slurp or spectacle fallback
# ==============================================================================

MODE="${1:-region}"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"
FILE="$SAVE_DIR/Screenshot_${TIMESTAMP}.png"

notify_shot() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -a "Screenshot" -i "$FILE" "Screenshot Taken" "Saved to $FILE and copied to clipboard" 2>/dev/null || true
    fi
}

if [ "$MODE" = "full" ]; then
    if command -v grim >/dev/null 2>&1; then
        grim "$FILE"
        if [ -f "$FILE" ]; then
            command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILE"
            notify_shot
        fi
    elif command -v spectacle >/dev/null 2>&1; then
        spectacle -f -b -o "$FILE" -c
        notify_shot
    fi
else
    # Region selection mode
    if command -v grim >/dev/null 2>&1 && command -v slurp >/dev/null 2>&1; then
        GEOM=$(slurp 2>/dev/null)
        if [ -n "$GEOM" ]; then
            grim -g "$GEOM" "$FILE"
            if [ -f "$FILE" ]; then
                command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILE"
                notify_shot
            fi
        fi
    elif command -v spectacle >/dev/null 2>&1; then
        spectacle -r
    fi
fi
