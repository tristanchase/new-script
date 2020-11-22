#!/usr/bin/env bash

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
# * Update README.md file

# DONE
# + Create -t|--template option
#   + Update usage section

#-----------------------------------

# Initialize variables
#_temp="file.$$"

# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script__ {

	_filepath="${HOME}/devel"
	_license="${_filepath}/new-script/license.sh"
	_runtime_section="${_filepath}/new-script/runtime-section.sh"
	_todo_section="${_filepath}/new-script/todo-section.sh"

	## Create a new script template in the current directory and exit (optional).
	if [[ "${_template_yN:-}" = "y" ]]; then
		__make_template__
	fi

	## Get the name of the new script (exit if empty).
	__getname__

	## Check to see if the script already exists.
	while [[ -e "${_file}" ]]; do
		printf "That script already exists!\n"
		__getname__
	done

	## Get an optional description of the new script.
	printf "Describe your new script (optional): "
	read _description

	## Create the directory for the new script.
	mkdir -p "${_dir}"
	cd "${_dir}"

	## Put it together.
	__create_script__

} #end __main_script__

# Local functions

function __create_script__ {
	__usage_section__
	cat "${_todo_section}" >> "${_newfile}"
	cat "${_license}" >> "${_newfile}"
	cat "${_runtime_section}" >> "${_newfile}"

	vim +/start_here "${_newfile}" # open vim on line with "<start_here>"
}

function __getname__ {
	printf "Name your new script (blank quits): "
	read _name
	if [[ -z "${_name}" ]]; then
		exit 2
	fi
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
if [[ -e ~/.functions.sh ]]; then
	source ~/.functions.sh
fi

# Get some basic options
# TODO Make this more robust
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	__debugger__
elif [[ "${1:-}" =~ (-h|--help) ]]; then
	__usage__
elif [[ "${1:-}" =~ (-t|--template) ]]; then
	_template_yN="y"
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

	__main_script__


fi

exit 0
