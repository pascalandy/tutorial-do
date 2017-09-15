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
echo "checkpoint 980 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s98-splash.sh"; echo; echo; sleep 2;

# Copy file
echo "checkpoint 981 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
#cp /root/temp/infra-as-code/files/splash.txt /etc/splash.txt
#echo "Banner /etc/splash.txt" >> /etc/ssh/sshd_config

# End of this script
echo "checkpoint 982 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
hostname && echo