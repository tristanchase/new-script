#!/usr/bin/env bash

_script_name=$(basename -s .sh "$0")
#-----------------------------------
# Usage Section

#<usage>
function __show_help__ {
	cat << EOF
Usage: ${_script_name} [OPTIONS] [<arguments>]

