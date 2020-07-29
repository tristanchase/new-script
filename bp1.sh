#!/usr/bin/env bash
#-----------------------------------
# Section 1.

# Low-tech debug mode
if [[ "${1:-}" =~ (-d|--debug) ]]; then
	set -o verbose
	set -o xtrace
	_debug_file=""${HOME}"/script-logs/$(basename "${0}")/$(basename "${0}")-debug-$(date -Iseconds)"
	mkdir -p $(dirname ${_debug_file})
        touch ${_debug_file}
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
