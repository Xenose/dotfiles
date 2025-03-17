#!/bin/sh

set -e

HOSTNAME="uknown"

BOOT_DISK="/dev/sda"
BOOT_SIZE="512"

SWAP_DISK="/dev/sda"
SWAP_SIZE="16384"

ROOT_FILE="ext4"
ROOT_DISK="/dev/sda"
ROOT_SIZE="-1"

TIME_REGION="Asia/Japan"


while true; do
	clear
	printf "\n\t[ Xenose Arch Install Script ]\n"

	printf "\n\t\tCurrent location of boot is [ %s ]" "$BOOT_DISK"

	printf "\n\n\tCommand: "
	read -r INPUT

	case $INPUT in
		"start")
			#break
			;;
		"exit")
			exit 0
			;;
		"part")
			;;
	esac
done

if command -v parted > /dev/null; then
	echo "parted"
	parted -s ${BOOT_DISK} mklabel gpt

	parted -s ${BOOT_DISK} mkpart ESP fat32 1MiB "${BOOT_SIZE}MiB"
	parted -s ${BOOT_DISK} set 1 boot on

	if [ ${SWAP_SIZE} -gt 0 ]; then
		parted -s ${SWAP_DISK} mkpart primary linux-swap 513MiB "${SWAP_SIZE}MiB"
	fi

	parted -s ${ROOT_DISK} mkpart primary ${ROOT_FILE} 16897MiB 100%
else
	printf "No formatting tool installed exiting..."
	exit 1
fi

mkdir /mnt/arch
mount "${ROOT_DISK}" /mnt/arch

if [ ${SWAP_SIZE} -gt 0 ]; then
	mkswap "${SWAP_DISK}"
fi

if command -v wget > /dev/null; then
	echo "wget"
	wget "https://mirror.aria-on-the-planet.es/archlinux/iso/latest/archlinux-bootstrap-x86_64.tar.zst"
else
	exit 1
fi

if command -v tar > /dev/null; then
	echo "tar"
	tar xpvf "archlinux-bootstrap-x86_64.tar.zst" --xattrs-include='*.*' --numeric-owner
else
	exit 1
fi

mv root.x86_64/* /mnt/arch/
rmdir root.x86_64

cp /etc/resolv.conf /mnt/arch/etc/resolv.conf
cp packages.txt /mnt/arch/

mount "${BOOT_DISK}" /mnt/arch/boot
mount --types			proc					/proc /mnt/arch/proc
mount --rbind			/sys					/mnt/arch/sys
mount --make-rslave	/mnt/arch/sys
mount --rbind			/dev					/mnt/arch/dev
mount --make-rslave	/mnt/arch/dev
mount --bind			/run					/mnt/arch/run
mount --make-slave	/mnt/arch/run

chroot /mnt/arch /bin/sh -x << EOF
	pacman-key	--init
	pacman-key	--populate
	pacman		--Syu

	pacman		--S base base-devel linux linux-firmware
	pacman		--S $(cut '\n' < /packages.txt)
	
	ln -sf /usr/share/zoneinfo/${TIME_REGION} /etc/localtime
	echo "${HOSTNAME}" > /etc/hostname
EOF
