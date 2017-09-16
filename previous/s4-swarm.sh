#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Print a helpful message if a pipeline with non-zero exit code causes the
# script to exit as described above.
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset

###############################################################################
# Functions
###############################################################################

### Show this which script is running
echo "checkpoint 400 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s4-swarm.sh"; echo; echo; sleep 2;


### Create a Swarm Manager
echo "checkpoint 401 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_docker_swarm_manager_init;
echo "Done | fct_docker_swarm_manager_init"; sleep 5;

echo "checkpoint 402 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_status
echo "Done | fct_status"; sleep 5;

echo "checkpoint 403 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_var.show;
echo "Done | fct_var"; sleep 5;

echo "checkpoint 404 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_label.apply;
echo "Done | fct_label.apply"; sleep 5;

echo "checkpoint 405 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_network.up;
echo "Done | fct_network"; sleep 5;

echo "checkpoint 406 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
source /root/deploy-setup/cmd.sh; fct_resilio.up;
echo "Done | fct_resilio.up"; sleep 5;

#echo "checkpoint 407 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
#source /root/deploy-setup/cmd.sh; fct_traefik.up;
#echo "Done | fct_traefik.install + (up)"; sleep 5;

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
hostname && echo;