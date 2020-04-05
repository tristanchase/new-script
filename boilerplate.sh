#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#-----------------------------------

#/ Usage: $_name [<options>] [<arguments>]
#/ Description: $_description
#/ Examples:
#/ Options:
#/   --help: Display this help message

# Created: $(date -Iseconds)
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  list
#  of
#  dependencies

#-----------------------------------
# Low-tech help option

usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

#-----------------------------------
# Low-tech logging function

readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

#-----------------------------------

cleanup() {
	# Remove temporary files
	# Restart services
	info "...cleaned up."
}

#-----------------------------------
# Main script

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	trap cleanup EXIT
	# Script goes here
	# ...
fi # End of main script

exit 0

