#!/usr/bin/env bash

# Low-tech debug mode
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	set -x
	exec > >(tee ""${HOME}"/tmp/$(basename "${0}")-debug.$$") 2>&1
	shift
fi

# Same as set -euE -o pipefail
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
IFS=$'\n\t'

#-----------------------------------

#/:Usage: new-script [ {-d|--debug} ] [--help]
#/:Description: Creates a new script in its own devel folder.
#/:Examples: new-script
#/:Options:
#/:	-d --debug	Enable debug mode
#/:	-h --help	Display this help message

# Created: 2020-01-03
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  vim

#-----------------------------------
# Low-tech help option

function __usage() { grep '^#/:' "${0}" | cut -c4- ; exit 0 ; }
expr "$*" : ".*-h\|--help" > /dev/null && __usage

#-----------------------------------
# Low-tech logging function

readonly LOG_FILE=""${HOME}"/tmp/$(basename "${0}").log"
function __info()    { echo "[INFO]    $*" | tee -a "${LOG_FILE}" >&2 ; }
function __warning() { echo "[WARNING] $*" | tee -a "${LOG_FILE}" >&2 ; }
function __error()   { echo "[ERROR]   $*" | tee -a "${LOG_FILE}" >&2 ; }
function __fatal()   { echo "[FATAL]   $*" | tee -a "${LOG_FILE}" >&2 ; exit 1 ; }

#-----------------------------------
# Trap functions

function __traperr() {
	__info "ERROR: ${BASH_SOURCE[1]}.$$ at line ${BASH_LINENO[0]}"
}

function __ctrl_c(){
	exit 2
}

function __cleanup() {
	case "$?" in
		0) # exit 0; success!
			#do nothing
			;;
		2) # exit 2; user termination
			__info ""$(basename $0).$$": script terminated by user."
			;;
		*) # any other exit number; indicates an error in the script
			rm -r ${_dir}
			__fatal ""$(basename $0).$$": script ${_name} not created."
			;;
	esac
}

#-----------------------------------
# Main script

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr ERR
	trap __ctrl_c INT
	trap __cleanup EXIT
#-----------------------------------
# Script goes here

	function __getname() {
		printf "Name your new script (blank quits): "
		read _name
		if [[ -z ${_name} ]]; then
			exit 2
		fi
		_filepath="${HOME}/devel"
		_newfile="${_name}.sh"
		_dir="${_filepath}/${_name}"
		_file="${_dir}/${_newfile}"
		_boilerplate_1="${_filepath}/new-script/boilerplate-1.sh"
		_boilerplate_3="${_filepath}/new-script/boilerplate-3.sh"
		_todo_section="${_filepath}/new-script/todo-section.sh"
	}

	__getname


	while [[ -e ${_file} ]]; do
		printf "That script already exists!\n"
		__getname
	done

	printf "Describe your new script (optional): "
	read _description

	mkdir -p ${_dir}
	cd ${_dir}

	#-----------------------------------
	# Boilerplate
	cat ${_boilerplate_1} > ${_newfile}

	cat >> ${_newfile} << EOF
#-----------------------------------

#//Usage: ${_name} [ {-d|--debug} ] [<options>] [<arguments>]
#//Description: ${_description}
#//Examples:
#//Options:
#//	-d --debug	Enable debug mode
#//	-h --help	Display this help message

# Created: $(date -Iseconds)
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  list
#  of
#  dependencies

EOF
	cat ${_boilerplate_3} >> ${_newfile}

	cat ${_todo_section} >> ${_newfile}

	vim +/start_here ${_newfile} # open vim on line with "<start_here>"

# Script ends here
#-----------------------------------

fi

# End of main script
#-----------------------------------

exit 0

# TODO
#
