#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

#-----------------------------------

#/ Usage: new-script [--help]
#/ Description: Creates a new script in its own devel folder.
#/ Examples:
#/ Options:
#/   --help: Display this help message

# Created: 2020-01-03
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
	if [[ "$?" -ne "0" ]]; then
		rm -r $_dir
		fatal ""$(basename $0)": $_name: script not created."
	fi
}

#-----------------------------------
# Main script

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	trap cleanup EXIT
	# Script goes here
	# ...

	getname() {
		printf "Enter the name of your new script: "
		read _name
		_filepath=${HOME}/devel
		_newfile=$_name.sh
		_dir=$_filepath/$_name
		_file=$_dir/$_newfile
		_boilerplate_1=$_filepath/new-script/boilerplate-1.sh
		_boilerplate_3=$_filepath/new-script/boilerplate-3.sh
	}

	getname


	while [[ -e $_file ]]; do
		printf "That file already exists!\n"
		getname
	done

	printf "Enter a description of your new script: "
	read _description

	mkdir -p $_dir
	cd $_dir

	#-----------------------------------
	# Boilerplate
	cat $_boilerplate_1 > $_newfile

	cat >> $_newfile << EOF
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

EOF
	cat $_boilerplate_3 >> $_newfile

	vim + $_newfile

fi # End of main script

exit 0
