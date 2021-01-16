#-----------------------------------
# Runtime Section

#<main>
# Initialize variables
#_temp="file.$$"

# List of temp files to clean up on exit (put last)
#_tempfiles=("${_temp}")

# Put main script here
function __main_script__ {

	<start_here>

} #end __main_script__
#</main>

#-----------------------------------
# Local functions

#<functions>
function __local_cleanup__ {
	:
}
#</functions>

#-----------------------------------
# Source helper functions
for _helper_file in functions colors git-prompt; do
	if [[ ! -e "${HOME}"/."${_helper_file}".sh ]]; then
		printf "%b\n" "Downloading missing script file "${_helper_file}".sh..."
		sleep 1
		wget -nv -P "${HOME}" https://raw.githubusercontent.com/tristanchase/dotfiles/master/"${_helper_file}".sh
		mv "${HOME}"/"${_helper_file}".sh "${HOME}"/."${_helper_file}".sh
	fi
done

source "${HOME}"/.functions.sh

#-----------------------------------
# Get some basic options
# TODO Make this more robust
#<options>
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	__debugger__
elif [[ "${1:-}" =~ (-h|--help) ]]; then
	__usage__
fi
#</options>

#-----------------------------------
# Bash settings
# Same as set -euE -o pipefail
#<settings>
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
IFS=$'\n\t'
#</settings>

#-----------------------------------
# Main Script Wrapper
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
	trap __traperr__ ERR
	trap __ctrl_c__ INT
	trap __cleanup__ EXIT

	__main_script__


fi

exit 0
