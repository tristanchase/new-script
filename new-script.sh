#!/usr/bin/env bash
set -euo pipefail
set -o errtrace
#set -x
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
			rm -r $_dir
			fatal ""$(basename $0).$$": script $_name not created."
			;;
	esac
}

#-----------------------------------
# Main script

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	trap traperr ERR
	trap ctrl_c INT
	trap cleanup EXIT
#-----------------------------------
# Script goes here

	getname() {
		printf "Name your new script (blank quits): "
		read _name
		if [[ -z $_name ]]; then
			exit 2
		fi
		_filepath=${HOME}/devel
		_newfile=$_name.sh
		_dir=$_filepath/$_name
		_file=$_dir/$_newfile
		_boilerplate_1=$_filepath/new-script/boilerplate-1.sh
		_boilerplate_3=$_filepath/new-script/boilerplate-3.sh
		_todo_section="${_filepath}/new-script/todo-section.sh"
	}

	getname


	while [[ -e $_file ]]; do
		printf "That script already exists!\n"
		getname
	done

	printf "Describe your new script (optional): "
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

	cat ${_todo_section} >> ${_newfile}

	vim +/start_here $_newfile # open vim on line with "<start_here>"

# Script ends here
#-----------------------------------

fi

# End of main script
#-----------------------------------

exit 0

# TODO
#
# * Update dependencies section
# * Update usage, description, and options section
# * Rename $variables to ${_variables}
# * Insert function before function_name()
# * Modify command substitution to "$(this_style)"
# * Clean up stray ;'s
