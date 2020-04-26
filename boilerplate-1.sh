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


