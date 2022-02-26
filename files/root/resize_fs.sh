#!/bin/sh

ROOT_SIZE="$( df | awk '/^\/dev\/root/ { print $2 }' )"

[ "${ROOT_SIZE}" -ne "104816" ] && exit 0

sync
BOOT="$( sed -n -e "/\s\/boot\s.*$/{s///p;q}" /etc/mtab )"
DISK="${BOOT%%[0-9]*}"
PART="$(( ${BOOT##*[^0-9]}+1 ))"
ROOT="${DISK}${PART}"
LOOP="$( losetup -f )"
losetup "${LOOP}" "${ROOT}"
fsck.ext4 -y "${LOOP}"
resize2fs "${LOOP}"
sync
reboot

