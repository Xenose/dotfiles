#!/bin/sh

update() {
	if command -v pacman > /dev/null; then
		su -c "pacman -Syu"
	fi

	if command -v nix-env > /dev/null; then
		nix profile upgrade
	fi

	if command -v flatpak > /dev/null; then
		flatpak update
	fi
}
