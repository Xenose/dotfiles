#!/bin/sh

# List of terminal emulators in preferred order
TERMINALS="foot alacritty kitty st konsol"

for term in $TERMINALS; do
	if command -v "$term" >/dev/null 2>&1; then
		exec "$term"
	fi
done
