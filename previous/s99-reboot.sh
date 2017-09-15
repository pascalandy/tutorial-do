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
echo "checkpoint 990 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s99-reboot.sh"; echo; echo; sleep 2;

echo "checkpoint 991 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo && echo -e "1 minute before rebooting...";
source /root/deploy-setup/cmd.sh; fct_count60;

echo "checkpoint 992 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
hostname && echo
reboot