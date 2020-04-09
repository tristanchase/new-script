#!/usr/bin/env bash
set -euo pipefail
set -o errtrace
#set -x
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

readonly LOG_FILE=""$HOME"/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $*" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $*" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $*" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $*" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

#-----------------------------------
# Trap functions

traperr() {
	info "ERROR: ${BASH_SOURCE[1]}.$$ at line ${BASH_LINENO[0]}"
}

ctrl_c(){
	exit 2
}

cleanup() {
	case "$?" in
		0) # exit 0; success!
			#do nothing
			;;
		2) # exit 2; user termination
			info ""$(basename $0).$$": script terminated by user."
			;;
		*) # any other exit number; indicates an error in the script
			#clean up stray files
			#fatal ""$(basename $0).$$": [error message here]"
			;;
	esac
}

#-----------------------------------
# Main Script Wrapper

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	trap traperr ERR
	trap ctrl_c INT
	trap cleanup EXIT
#-----------------------------------
# Main Script goes here
# <start_here>
# Main Script ends here
#-----------------------------------

fi

# End of Main Script Wrapper
#-----------------------------------

exit 0

# TODO
#
# * Update dependencies section
# * Update usage, description, and options section
# * Update cleanup() function
# * Rename $variables to ${_variables}
# * Insert function before function_name()
# * Modify command substitution to "$(this_style)"
# * Clean up stray ;'s
# * Insert script
