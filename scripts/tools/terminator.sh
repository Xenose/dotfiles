#!/bin/sh

_ps=$(ps -ao comm)
_app=$(echo "$_ps" | tail -n +2 | sort -u | grep -ve '^ps$' | rofi -dmenu -p "Select application to kill")


[ -z "$_app" ] && exit

# Confirm before killing
confirm=$(printf "No\nYes" | rofi -dmenu -p "Kill all '$_app' processes?")

[ "$confirm" != "Yes" ] && exit

pkill -SIGKILL "$_app"
