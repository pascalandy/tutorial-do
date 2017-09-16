## Context
1. [ ] Manually deploy a machine via DO, Packet, Civo, etc
2. [ ] In iTerm, SSH into the machine
3. [ ] copy-paste `_config.sh`
4. [ ] copy-paste `_runthis-manually.sh`
5. [ ] The system will `prompt` 1 or 2 confirmation. Answer yes
6. [ ] The system will provision up to resilio
7. [ ] The provinning automatisation stops here. The goal is to have resilio sync the data (about 1.2GO at this point)
8. [ ] While resilio is synching / ensure CloudFlare DNS points to new server

## Resilio is sync
1. [ ] Once Resilio have sync the data
2. [ ] Restaure Resilio backup:
- DIR_FROM=/mnt/resilio000/CODA01/DeployGRP
- DIR_INTO=/mnt/DeployGRP/CODA77
3. [ ] Double-check / CloudFlare DNS points to new server
4. [ ] _apps / Ensure ENV_CTN_deployGRP="CODA01" are updated for each apps

## Complete the full stack deployment
1. [ ] traefik.up
2. [ ] Ensure dummy site is online
3. [ ] DeployAllBoth
4. [ ] portainer.up /CMD
5. [ ] papertrail.up
6. [ ] Setup Backblaze
7. [ ] Setup Cron
8. [ ] Test backup
9. [ ] Clean up older Resilio Stuff

## Tested on
packet.net
civo / since 2017-09-16_12h56