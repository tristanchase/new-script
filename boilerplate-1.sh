#!/usr/bin/env bash

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


