#-----------------------------------
# Section 3.

# Low-tech logging function

readonly LOG_FILE=""${HOME}"/script-logs/$(basename "${0}")/$(basename "${0}").log"
mkdir -p $(dirname ${LOG_FILE})
function __info()    { echo "$(date -Iseconds) [INFO]    $*" | tee -a "${LOG_FILE}" >&2 ; }
function __warning() { echo "$(date -Iseconds) [WARNING] $*" | tee -a "${LOG_FILE}" >&2 ; }
function __error()   { echo "$(date -Iseconds) [ERROR]   $*" | tee -a "${LOG_FILE}" >&2 ; }
function __fatal()   { echo "$(date -Iseconds) [FATAL]   $*" | tee -a "${LOG_FILE}" >&2 ; exit 1 ; }

#-----------------------------------
# Trap functions

function __traperr() {
	__error "${FUNCNAME[1]}: ${BASH_COMMAND}: $?: ${BASH_SOURCE[1]}.$$ at line ${BASH_LINENO[0]}"
}

function __ctrl_c(){
	exit 130
}

function __cleanup() {
	case "$?" in
		0) # exit 0; success!
			#do nothing
			;;
		1) # exit 1; General error
			#do nothing
			;;
		2) # exit 2; Missing keyword or command, or permission problem
			__fatal "$(basename "${0}"): missing keyword or command, or permission problem."
			;;
		126) # exit 126; Cannot execute command (permission denied or not executable)
			#do nothing
			;;
		127) # exit 127; Command not found (problem with $PATH or typo)
			#do nothing
			;;
		128) # exit 128; Invalid argument to exit (integers from 0 - 255)
			#do nothing
			;;
		130) # exit 130; user termination
			__fatal ""$(basename $0).$$": script terminated by user."
			;;
		255) # exit 255; Exit status out of range (e.g. exit -1)
			#do nothing
			;;
		*) # any other exit number; indicates an error in the script
			#clean up stray files
			#__fatal ""$(basename $0).$$": [error message here]"
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

function __usage() { grep '^#//' "${0}" | cut -c4- ; exit 0 ; }
expr "$*" : ".*-h\|--help" > /dev/null && __usage

#-----------------------------------
# Main Script goes here

# <start_here>

# End Section 3.
#-----------------------------------
