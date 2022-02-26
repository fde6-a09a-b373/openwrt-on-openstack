#!/usr/bin/env bash

declare -a PACKAGES
declare -a DISABLED_SERVICES

PACKAGES+=( "-ppp" )
PACKAGES+=( "-ppp-mod-pppoe" )
PACKAGES+=( "-dnsmasq" )
PACKAGES+=( "-odhcpd-ipv6only" )

PACKAGES+=( "ip-full" )
PACKAGES+=( "ip-bridge" )
PACKAGES+=( "tmux" )

PACKAGES+=( "fdisk" )
PACKAGES+=( "losetup" )
PACKAGES+=( "resize2fs" )

DISABLED_SERVICES+=( "firewall" )

test -z "${DISABLED_SERVICES:-}" && DISABLED_SERVICES=""

make image \
	PACKAGES="${PACKAGES[*]}" \
	DISABLED_SERVICES="${DISABLED_SERVICES[*]}" \
	FILES="./files/"

