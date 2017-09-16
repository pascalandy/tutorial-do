###############################################################################
# Manually run 1) _config.sh  2) _runthis-manually.sh
#
# Prompts | the system will ask for 
# A) *** cloud.cfg (Y/I/N/O/D/Z) [default=N] ? /y
# B) The authenticity of host 'gitlab.com (52.167.219.168)' /yes
###############################################################################

### Show this which script is running
echo "SCRIPT s0-sequence.sh" && \

export DEBIAN_FRONTEND=noninteractive && \

### Create log file
mkdir -p ~/temp && \
touch ~/temp/provisionninglogs.txt && \
cd ~/temp && \
echo "checkpoint 01 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo && \

###  Install Git
echo "checkpoint 02 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo && \
apt-get update -y && \
apt-get upgrade -qy && \
apt-get install -y git language-pack-en && \

### Set SSH key for gitlab
echo "checkpoint 03 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo && \
echo "Copy the private key so this machine can talk with our private git server" && echo && \
mkdir -p ~/.ssh/ && \
echo "$GITLAB_PRIV_KEY" >> ~/.ssh/id_rsa && \
sudo chmod 600 ~/.ssh/id_rsa && \
cat ~/.ssh/id_rsa && \

### Git clone INFRA
echo "checkpoint 04 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo && \
git clone "$GITLAB_INFRA_AS_CODE_URL" && \

    # The system will prompt. The authenticity of host 'gitlab.com... can't be established.
    # ECDSA key fingerprint is SHA256 . #Are you sure you want to continue ...

### Update root passwd
echo "checkpoint 05 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo && \
echo "Update root password" && \
echo "root:$ROOT_PASS" | chpasswd && \
cat ~/temp/provisionninglogs.txt && \
ROOT_PASS="null" && sleep 2 && \

### Launch the scripts
echo "checkpoint 06 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo && \
hostname && echo && \
cd ~/temp/"$GITLAB_INFRA_AS_CODE_REPO_NAME" && \
chmod +x s0-sequence.sh && \
./s0-sequence.sh;