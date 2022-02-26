#!/bin/sh

SECTORS="$( fdisk -l | head -n 1 | sed -Ee 's/^.+, ([0-9]+) sectors$/\1/' )"
VDA2_END="$( fdisk -l | awk '/^\/dev\/vda2/ { print $3 }' )"

[ "${VDA2_END}" -ne "246783" ] && exit 0

BOOT="$( sed -n -e "/\s\/boot\s.*$/{s///p;q}" /etc/mtab )"
DISK="${BOOT%%[0-9]*}"
PART="$(( ${BOOT##*[^0-9]}+1 ))"
ROOT="${DISK}${PART}"
OFFS="$( fdisk "${DISK}" -l -o device,start | sed -n -e "\|^${ROOT}\s*|s///p" )"
echo -e "p\nd\n${PART}\nn\np\n${PART}\n${OFFS}\n\nn\np\nw" | fdisk "${DISK}"

