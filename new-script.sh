#!/usr/bin/env bash

_script_name=$(basename -s .sh "$0")
#-----------------------------------
# Usage Section

#//Usage: new-script [ {-d|--debug} ] [ {-h|--help} | {-t|--template} ]
#//Description: Creates a new script in its own devel folder.
#//Examples: new-script; new-script --debug
#//Options:
#//	-d --debug	Enable debug mode
#//	-h --help	Display this help message
#//	-t --template	Make a new script template in current directory

# Created: 2020-01-03
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  vim

#-----------------------------------
# TODO Section
# * Create -c|--convert option
#   * Update usage section
# * Update README.md file

# DONE

#-----------------------------------

# Initialize variables
#_temp="file.$$"
_filepath="${HOME}/devel" && mkdir -p "${_filepath}"

_script_path=""${_filepath}"/"${_script_name}"" && mkdir -p "${_script_path}"
_license="${_script_path}/license.sh" && touch "${_license}"
_runtime_section="${_script_path}/runtime-section.sh" && touch "${_runtime_section}"
_todo_section="${_script_path}/todo-section.sh" && touch "${_todo_section}"
#_usage_section="${_script_path}/usage-section.sh" && touch "${_usage_section}"
_usage_section_1="${_script_path}/usage-section-1.sh" && touch "${_usage_section_1}"
_usage_section_2="${_script_path}/usage-section-2.sh" && touch "${_usage_section_2}"

# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script__ {

	# Get the name of the new script (exit if empty).
	if [[ -n "${_arg:-}" ]]; then
		__getname_arg__
	else
		__getname__
	fi

	# Check to see if the script already exists.
	while [[ -e "${_file}" ]]; do
		printf "%b\n" "That script already exists!"
		__getname__
	done

	# Get an optional description of the new script.
	printf "Describe your new script (optional): "
	read _description

	# Create the directory for the new script.
	mkdir -p "${_dir}"
	cd "${_dir}"

	# Put it together.
	__create_script__

} #end __main_script__

# Local functions

function __convert_script__ {
	# Back up original file (cp file file.orig)
	# Add tags to file (<usage> <created> <depends> <todo> <license> <main> <functions> <options> <settings>)
	:
}

function __create_script__ {
	cat "${_usage_section_1}" >> "${_newfile}"
	__desc_section__
	cat "${_usage_section_2}" >> "${_newfile}"
	__created_section__
	cat "${_todo_section}" >> "${_newfile}"
	cat "${_license}" >> "${_newfile}"
	cat "${_runtime_section}" >> "${_newfile}"

	vim +/start_here "${_newfile}" # open vim on line with "<start_here>"
}

function __created_section__ {
	cat >> "${_newfile}" << EOF
#<created>
# Created: $(date -Iseconds)
# Tristan M. Chase <tristan.m.chase@gmail.com>
#</created>

#<depends>
# Depends on:
#  list
#  of
#  dependencies
#</depends>

EOF
}

function __desc_section__ {
	cat >> "${_newfile}" << EOF
Description: ${_description}
EOF
}

function __getname__ {
	printf "Name your new script (blank quits): "
	read _name
	if [[ -z "${_name}" ]]; then
		exit 1
	fi
	_newfile="${_name}.sh"
	_dir="${_filepath}/${_name}"
	_file="${_dir}/${_newfile}"
}

function __getname_arg__ {
	printf "Use \""${_arg}"\" for script name (y/N)? "
	read _response
	if [[ ! "${_response}" =~ (y|Y) ]]; then
		exit 1
	fi
	_name="${_arg}"
	_newfile="${_name}.sh"
	_dir="${_filepath}/${_name}"
	_file="${_dir}/${_newfile}"
}

function __make_template__ {
	_newfile="template.$$.sh"
	_name="template.$$"
	_description="This is a template file."
	__create_script__
	exit 0
}


# Source helper functions
for _helper_file in functions colors git-prompt; do
	if [[ ! -e ${HOME}/."${_helper_file}".sh ]]; then
		printf "%b\n" "Downloading missing script file "${_helper_file}".sh..."
		sleep 1
		wget -nv -P ${HOME} https://raw.githubusercontent.com/tristanchase/dotfiles/main/"${_helper_file}".sh
		mv ${HOME}/"${_helper_file}".sh ${HOME}/."${_helper_file}".sh
	fi
done

source ${HOME}/.functions.sh

# Get some basic options
# TODO Make this more robust
shopt -s extglob
case "${1:-}" in
	(-d|--debug) __debugger__ ;;
	(-h|--help) __usage__ ;;
	(-t|--template) __make_template__ ;;
	(-*|--*)  printf "%b\n" "$(basename -s .sh "$0"): Option \""${1:-}"\" not recognized."  1>&2 ; __usage__  1>&2 ;;
	#('') printf "%b\n" "$(basename -s .sh "$0"): Argument required." 1>&2 ; __usage__  1>&2 ;;
	(*) _arg="${1:-}"
esac

# Bash settings
# Same as set -euE -o pipefail
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
IFS=$'\n\t'

# Main Script Wrapper
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr__ ERR
	trap __ctrl_c__ INT
	trap __cleanup__ EXIT

	__main_script__


fi

exit 0
