#!/bin/bash

set -eo pipefail
shopt -s lastpipe

log() {
	echo ":: $*" >&2
}

err() {
	echo "E: $*" >&2
}

die() {
	err "$@"
	exit 1
}

usage() {
	if (( $# )); then
		echo "${0##*/}: $*" >&2
		echo >&2
	fi
	_usage >&2
	exit 1
}

_usage() {
	cat <<EOF
Usage: ${0##*/}
EOF
}


#
# defaults
#

LIB_DIR="$(dirname "$(realpath -qe "$BASH_SOURCE")")"
BUSYBOX=(/usr/lib/initcpio/busybox)
CMDLINE="root=zfs"


#
# args
#

if args=$(getopt -o 'c:' --long 'cmdline:' -n "${0##*/}" -- "$@"); then
	eval set -- "$args"
else
	usage
fi
unset args

while :; do
	case "$1" in
	-c|--cmdline) shift; CMDLINE="$1" ;;
	--) shift; break ;;
	*) die "getopt error" ;;
	esac
	shift
done


#
# main
#

log "\$LIB_DIR: ${LIB_DIR@Q}"
log "busybox: ${BUSYBOX@Q}"
log "kernel cmdline: ${CMDLINE@Q}"

<<<"$CMDLINE" xargs printf "%s\n" | "${BUSYBOX[@]}" awk -f "$LIB_DIR/zfs-parse-cmdline" | readarray -t VARS
for v in "${VARS[@]}"; do
	log "vars: - ${v@Q}"
done

set -x
sudo \
	LIB_DIR="$LIB_DIR" \
	DRY_RUN=1 \
	"${VARS[@]}" \
	"${BUSYBOX[@]}" sh \
	"$@"
