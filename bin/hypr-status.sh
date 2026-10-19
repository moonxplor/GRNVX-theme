#!/usr/bin/env bash
V=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 1.00")
VOL=$(echo "$V" | awk '{print int($2 * 100)}')
[ -z "$VOL" ] && VOL=100
echo "$V" | grep -q "MUTED" && MUTED="true" || MUTED="false"

BRIGHT=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%' || echo "100")
[ -z "$BRIGHT" ] && BRIGHT=100

BAT_CAP=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1 || echo "100")
BAT_STAT=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1 || echo "Discharging")

WIFI=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -n1)
[ -z "$WIFI" ] && WIFI="Offline"

echo "${VOL}|${MUTED}|${BRIGHT}|${BAT_CAP}|${BAT_STAT}|${WIFI}"
