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
echo "checkpoint 400 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s4-swarm.sh"; echo; echo; sleep 2;


### Create a Swarm Manager
echo "checkpoint 401 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_docker_swarm_manager_init;
sleep 5;
echo "Done | fct_docker_swarm_manager_init"

echo "checkpoint 402 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_status.node;
sleep 5;
echo "Done | fct_status"

echo "checkpoint 403 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_var.show;
sleep 5;
echo "Done | fct_var"

echo "checkpoint 404 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_label.apply;
sleep 5;
echo "Done | fct_label.apply"

echo "checkpoint 405 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_network.up;
sleep 5;
echo "Done | fct_network"

echo "checkpoint 406 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_resilio.up;
sleep 5;
echo "Done | fct_resilio.up"

#echo "checkpoint 407 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_traefik.install;
source /root/deploy-setup/cmd.sh; fct_traefik.up;
sleep 5;
echo "Done | fct_traefik.install + (up)"

echo "checkpoint 408 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_pps; 


# — — — # — — — # — — — #
echo "checkpoint 409 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo && echo -e "Add the flag 'node-is-configured.txt' : "
touch ~/temp/node-is-configured.txt;

echo;
cd /mnt/resilio000;
pwd;
echo;
echo "Letting Resilio synching...";

# End of this script
echo "checkpoint 410 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
hostname && echo