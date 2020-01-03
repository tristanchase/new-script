#!/usr/bin/env bash
#
# new-script
#
# Usage:
#  new-script
#
# Depends on:
#  list
#  of
#  dependencies
#
# Created: 2020-01-03 
# Tristan M. Chase <tristan.m.chase@gmail.com>
#-----------------------------------
# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/alphabetum/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'
#-----------------------------------

printf "Enter the name of your new script: "
read _name

_filepath=${HOME}/devel/
_newfile=$_name.sh
_dir=$_filepath/$_name
_file=$_dir/$_newfile

if [[ -e $_file ]]; then
	printf "That file already exists!";
	exit 1;
fi

printf "Enter a description of your new script: "
read _description

mkdir -p $_dir
cd $_dir

#-----------------------------------
cat > $_newfile <<EOM
#!/usr/bin/env bash
#
# $_name: $_description
#
# Usage:
#  $_name [<options>] [<arguments>]
#
# Depends on:
#  list
#  of
#  dependencies
#
# Created: $(date -Iseconds)
# Tristan M. Chase <tristan.m.chase@gmail.com>
#-----------------------------------
# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/alphabetum/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'
#-----------------------------------


EOM
#-----------------------------------

vim + $_newfile

exit 0
