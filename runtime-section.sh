#-----------------------------------

# Initialize variables
#_temp="file.$$"

# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script {

	<start_here>

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