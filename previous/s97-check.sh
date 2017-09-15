#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

### Show this which script is running
echo "checkpoint 970 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s97-check.sh"; echo; echo; sleep 2;


echo "checkpoint 971 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
if [ `id -u` -gt 0 ]; then
    echo "You must be root."
    exit 1
fi

echo "checkpoint 972 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
# Bash Guard https://goo.gl/gwZl5G 
if ! [ -n "$BASH_VERSION" ]; then
    echo "This is not bash! Maybe sh !?!";
    SCRIPT=$(readlink -f "$0")
    /bin/bash "$SCRIPT"
    exit 1
fi

echo "checkpoint 973 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
# Basic check
if ! [ -x "$(which systemctl)" ]; then
    echo "systemctl required. Exiting."
    exit 1
fi

# End of this script
echo "checkpoint 974 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
hostname && echo