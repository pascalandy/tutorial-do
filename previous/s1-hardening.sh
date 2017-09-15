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
echo "checkpoint 100 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s1-hardening.sh"; echo; echo; sleep 2;

### Load env-var
source /root/temp/infra-as-code/_config.sh .

echo "checkpoint 101 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
### Ensure we are in the right path
mkdir -p ~/temp;
cd ~/temp;

echo "checkpoint 102 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
### Clone Repo
git clone "$GIT_REPO_HARDENING";
cd hardening;
cat ubuntu.cfg;
bash ubuntu.sh;


### Because I use root
# https://github.com/konstruktoid/hardening/issues/5#issuecomment-327799782
# change PermitRootLogin to yes in the sshd-config file and unlock the root user.

# before
#cat /etc/ssh/sshd_config | grep PermitRootLogin
# after
#sed -i "s+PermitRootLogin no+PermitRootLogin yes+g" "/etc/ssh/sshd_config"
#cat /etc/ssh/sshd_config | grep PermitRootLogin


# End of this script
echo "checkpoint 103 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
hostname && echo