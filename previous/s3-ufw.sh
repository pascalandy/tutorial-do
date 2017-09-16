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
echo "checkpoint 300 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s3-ufw.sh"; echo; echo; sleep 2;

### Load env-var
source /root/temp/infra-as-code/_config.sh .

echo "checkpoint 301 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
# Create main directories
MNT_DEPLOY_GRP="/mnt/DeployGRP"

mkdir -p /mnt/resilio000
mkdir -p $MNT_DEPLOY_GRP/tooldata/portainer/data
mkdir -p $MNT_DEPLOY_GRP/tooldata/caddy
mkdir -p $MNT_DEPLOY_GRP/tooldata/traefik
   touch $MNT_DEPLOY_GRP/tooldata/traefik/acme.json


echo "checkpoint 302 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
### UFW config

## SSH port
ufw allow ssh;

ufw allow http;
ufw allow https;

## TCP port 2376 for secure Docker client communication. This port is required for Docker Machine to work. Docker Machine is used to orchestrate Docker hosts.
ufw allow 2376/tcp;

## TCP and UDP port 7946 for communication among nodes (container network discovery).
ufw allow 7946/tcp;
ufw allow 7946/udp;

## UDP port 4789 for overlay network traffic (container ingress networking).
ufw allow 4789/udp;

## On Leader only | To disable on Workers
## Port 2377 is used for communication between the nodes of a Docker Swarm or cluster. It only needs to be opened on manager nodes.
ufw allow 2377/tcp;

##Use by Traefik
ufw allow 8080/tcp;

echo "checkpoint 303 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
# >>> Reload UFW
ufw reload;
ufw --force enable;
ufw status numbered;
systemctl restart docker;


# End of this script
echo "checkpoint 304 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
hostname && echo