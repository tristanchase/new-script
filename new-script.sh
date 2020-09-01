#!/usr/bin/env bash

#-----------------------------------
# Usage Section

#//Usage: new-script [ {-d|--debug} ] [ {-h|--help} ]
#//Description: Creates a new script in its own devel folder.
#//Examples: new-script; new-script --debug
#//Options:
#//	-d --debug	Enable debug mode
#//	-h --help	Display this help message

# Created: 2020-01-03
# Tristan M. Chase <tristan.m.chase@gmail.com>

# Depends on:
#  vim

#-----------------------------------
# TODO Section (bottom up)


#-----------------------------------

# Initialize variables
#_temp="file.$$"

# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script {

	function __getname() {
		printf "Name your new script (blank quits): "
		read _name
		if [[ -z "${_name}" ]]; then
			exit 2
		fi
		_filepath="${HOME}/devel"
		_newfile="${_name}.sh"
		_dir="${_filepath}/${_name}"
		_file="${_dir}/${_newfile}"
		_boilerplate_1="${_filepath}/new-script/bp1.sh"
		_boilerplate_2="${_filepath}/new-script/bp2.sh"
		_boilerplate_3="${_filepath}/new-script/bp3.sh"
		_boilerplate_4="${_filepath}/new-script/bp4.sh"
		_license="${_filepath}/new-script/license.sh"
		_runtime_section="${_filepath}/new-script/runtime-section.sh"
		_todo_section="${_filepath}/new-script/todo-section.sh"
	}

	__getname


	while [[ -e "${_file}" ]]; do
		printf "That script already exists!\n"
		__getname
	done

	printf "Describe your new script (optional): "
	read _description

	mkdir -p "${_dir}"
	cd "${_dir}"

	#-----------------------------------
	# Put it together

	__usage_section__
	cat "${_todo_section}" >> "${_newfile}"
	cat "${_license}" >> "${_newfile}"
	cat "${_runtime_section}" >> "${_newfile}"

	vim +/start_here "${_newfile}" # open vim on line with "<start_here>"

} #end __main_script

# Source helper functions
if [[ -e ~/.functions.sh ]]; then
	source ~/.functions.sh
fi

# Low-tech logging function
__logger__

# Get some basic options
# TODO Make this more robust
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	__debugger__
elif [[ "${1:-}" =~ (-h|--help) ]]; then
	__usage__
fi

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

	__main_script


fi

exit 0
