#!/usr/bin/env bash
#-----------------------------------
# Section 1.

# Low-tech debug mode
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	set -x
	_debug_file=""${HOME}"/tmp/$(basename "${0}")-debug.$$"
	exec > >(tee "${_debug_file:-}") 2>&1
	shift
fi

# Same as set -euE -o pipefail
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
IFS=$'\n\t'

# End Section 1.
#-----------------------------------
#-----------------------------------
# Section 2.

#/:Usage: new-script [ {-d|--debug} ] [ {-h|--help} ]
#/:Description: Creates a new script in its own devel folder.
#/:Examples: new-script; new-script --debug
#/:Options:
#/:	-d --debug	Enable debug mode
#/:	-h --help	Display this help message

# Created: 2020-01-03
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  vim

# End Section 2.
#-----------------------------------
#-----------------------------------
# Section 3.

# Low-tech logging function

readonly LOG_FILE=""${HOME}"/tmp/$(basename "${0}").log"
function __info()    { echo "[INFO]    $*" | tee -a "${LOG_FILE}" >&2 ; }
function __warning() { echo "[WARNING] $*" | tee -a "${LOG_FILE}" >&2 ; }
function __error()   { echo "[ERROR]   $*" | tee -a "${LOG_FILE}" >&2 ; }
function __fatal()   { echo "[FATAL]   $*" | tee -a "${LOG_FILE}" >&2 ; exit 1 ; }

#-----------------------------------
# Trap functions

function __traperr() {
	__error "${FUNCNAME[1]}: ${BASH_COMMAND}: $?: ${BASH_SOURCE[1]}.$$ at line ${BASH_LINENO[0]}"
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
			__info ""$(basename ${0}).$$": script terminated by user."
			;;
		*) # any other exit number; indicates an error in the script
			rm -r ${_dir}
			__fatal ""$(basename ${0}).$$": script \"${_name}\" not created."
			;;
	esac

	if [[ -n "${_debug_file:-}" ]]; then
		echo "Debug file is: "${_debug_file:-}""
	fi
}

#-----------------------------------
# Main Script Wrapper

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr ERR
	trap __ctrl_c INT
	trap __cleanup EXIT

#-----------------------------------
# Low-tech help option

function __usage() { grep '^#/:' "${0}" | cut -c4- ; exit 0 ; }
expr "$*" : ".*-h\|--help" > /dev/null && __usage

#-----------------------------------
# Main Script goes here

# End Section 3.
#-----------------------------------
#keep_script
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
		_boilerplate_1="${_filepath}/new-script/bp1.sh"
		_boilerplate_3="${_filepath}/new-script/bp3.sh"
		_boilerplate_4="${_filepath}/new-script/bp4.sh"
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
# Section 2.

#//Usage: ${_name} [ {-d|--debug} ] [ {-h|--help} | <options>] [<arguments>]
#//Description: ${_description}
#//Examples: ${_name} foo; ${_name} --debug bar
#//Options:
#//	-d --debug	Enable debug mode
#//	-h --help	Display this help message

# Created: $(date -Iseconds)
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  list
#  of
#  dependencies

# End Section 2.
#-----------------------------------
EOF
	cat ${_boilerplate_3} >> ${_newfile}
	cat ${_boilerplate_4} >> ${_newfile}
	cat ${_todo_section} >> ${_newfile}

	vim +/start_here ${_newfile} # open vim on line with "<start_here>"
#keep_script
#-----------------------------------
# Section 4.

# Main Script ends here
#-----------------------------------

fi

# End of Main Script Wrapper
#-----------------------------------

exit 0

# End Section 4.
#-----------------------------------
#-----------------------------------
# Section 5.

# TODO (bottom up)
#
# * Update dependencies section
# * Update usage, description, and options section
# * Update __cleanup(); add debug lines (copy from ~/devel/new-script/boilerplate-3.sh)
# * Update first section with new debug section (copy from ~/devel/new-script/boilerplate-1.sh)
# * Enhance __traperr() (copy from ~/devel/new-script/boilerplate-3.sh)
# * Check that _variable="variable definition" (make sure it's in quotes)

# End Section 5.
#-----------------------------------
