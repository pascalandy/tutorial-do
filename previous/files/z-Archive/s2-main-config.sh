#!/bin/sh
set -u
set -e

echo "SCRIPT s2-main-config.sh";
sleep 2;

# swapsize="see line 149"

# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# 12_ubuntu-configs.sh | # This shall be copied in a gist
# SENSITIVE_DATA
# https://gist.github.com/pascalandy/2dcbe6be86a7a391c0e121831febc67c
# 2017-05-14_16h44 | is the last script update
# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #


# — — — # — — — # — — — #
echo "Copy cloudflare keys"
echo "checkpoint 106 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
mkdir -p /root/.cloudflare
# SENSITIVE_DATA
cat > $HOME/.cloudflare/env <<EOF
CF_API_KEY=a01a242673444cab06eb642a235fdc7a9d260
CF_API_EMAIL=pascal@firepress.org
EOF


# — — — # — — — # — — — #
echo && echo -e "Install system utilities"
echo "checkpoint 107 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
apt-get -q update
apt-get -qy upgrade
apt-get -qy install \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
	lbzip2 \
	unzip \
	ccrypt \
	tree \
	secure-delete \
	git \
	git-core \
	openssl \
	httpie
		# zram-config works but cause freaking latency issues


# — — — # — — — # — — — #
echo "Install Docker: "
echo "checkpoint 108 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
curl -sSL https://get.docker.com/ | sh

echo; echo; echo; echo
docker run -it --rm mbentley/figlet "FirePress Hello World"
echo; echo; sleep 2


# — — — # — — — # — — — #
#echo && echo -e "Install timedatectl (Time Zone)"
#echo && echo -e "Install ntp - Network Time Protocol (NTP)"&& sleep 0 && echo
#echo "checkpoint 109 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#sudo apt-get -qqy install ntp ntpdate --no-install-recommends
#timedatectl list-timezones
#sudo timedatectl set-timezone America/New_York
#sudo timedatectl set-ntp yes
#echo && echo -e "Verify that the timezone has been set properly"
#timedatectl


# — — — # — — — # — — — #
echo && echo -e "Setting swap: " && echo
echo "checkpoint 110 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
swapsize="4096M"
fallocate -l $swapsize /swapfile;
ls -lh /swapfile
chmod 600 /swapfile;
ls -lh /swapfile
mkswap /swapfile;
swapon /swapfile;
swapon --show
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab


# — — — # — — — # — — — #
echo && echo -e "Clean Up " && echo
echo "checkpoint 111 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
apt-get -q update && apt-get -qy upgrade
apt-get -qy dist-upgrade
apt-get autoclean -y
apt-get autoremove
apt-get purge
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# — — — # — — — # — — — #
echo && echo -e "Changing SSH port" && echo
echo "checkpoint 112 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#sed -i -e 's/Port 22/Port 997/' /etc/ssh/sshd_config
#sudo /etc/init.d/ssh restart

#sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config


# — — — # — — — # — — — #
# clone | deploy-setup
echo "checkpoint 113 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# SENSITIVE_DATA
cd ~
git clone https://pascalandy:Gitlab-2200-polo@gitlab.com/firepress-delivery-heroes/deploy-setup.git
ENV_BRANCH="1.9.30";
ENV_NAME="Pascal Andy";
ENV_EMAIL="pascal@firepress.org";
ENV_REPO_NAME="deploy-setup"
echo;

cd ~/$ENV_REPO_NAME; sleep 0.5;
git config --global user.name "$ENV_NAME";
git config --global user.email "$ENV_EMAIL";
git checkout "$ENV_BRANCH"; sleep 1; 
echo;
ENV_BRANCH=""; ENV_NAME=""; ENV_EMAIL="";

# clone | deploy-logs
echo "checkpoint 114 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#_SENSITIVE_DATA#_SENSITIVE_DATA
cd ~
git clone https://pascalandy:Gitlab-2200-polo@gitlab.com/firepress-delivery-heroes/deploy-logs.git
ENV_BRANCH="master";
ENV_NAME="Pascal Andy";
ENV_EMAIL="pascal@firepress.org";
ENV_REPO_NAME="deploy-logs"
echo;

cd ~/$ENV_REPO_NAME; sleep 0.5;
git config --global user.name "$ENV_NAME";
git config --global user.email "$ENV_EMAIL";
git config --global push.default matching;
git checkout "$ENV_BRANCH"; sleep 1; 
echo;
ENV_BRANCH=""; ENV_NAME=""; ENV_EMAIL="";

# — — — # — — — # — — — #
echo "checkpoint 115 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
echo && echo -e "Add the flag 'node-is-configured.txt' : "
touch ~/temp/node-is-configured.txt


# — — — # — — — # — — — #
#echo "checkpoint 116 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#echo && echo -e "Time to reboot..."; sleep 2;
#reboot


# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# Could be usefull in the future

# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE EDITOR=/usr/bin/nano " && echo
#echo "checkpoint 107 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#EDITOR=/usr/bin/nano
#DEBIAN_FRONTEND=noninteractive
#	#details https://goo.gl/6Sjlbv


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Configure UFW " && echo
#echo && echo -e "$PIK_BLUE WARNING - Needed on Scaleway only" && echo
#echo "checkpoint 109 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#echo "FOUND THAT UFW MESS WITH MY SETUP 2017-05-14_15h42"

#ufw --force enable
##ufw default deny incoming
##ufw default allow outgoing
#
## All nodes | Swarm Leader AND workers
#ufw allow 22/tcp
#ufw allow 997/tcp
#ufw allow 2376/tcp
#	#TCP and UDP port 7946 for communication among nodes (container network discovery).
#ufw allow 7946/tcp
#ufw allow 7946/udp
#	#UDP port 4789 for overlay network traffic (container ingress networking).
#ufw allow 4789/udp
#
#	# On Leader only | Will need to disable on Workers
#ufw allow 2377/tcp
#
## >>> Reload UFW
#ufw reload
#ufw status numbered

#sed -i -e '/DEFAULT_FORWARD_POLICY="DROP"/ c\DEFAULT_FORWARD_POLICY="ACCEPT"' /etc/default/ufw
# >>> Ensure that 'IPV6=yes' | sudo nano /etc/default/ufw

    #ie... sudo ufw delete 2

	### Open this port
	#ENV_PORT_ACTION=8083
	#sudo ufw allow $ENV_PORT_ACTION/tcp
	#sudo ufw reload && sudo ufw status verbose

	### Delete this port
	#ENV_PORT_ACTION=22
	#sudo ufw deny $ENV_PORT_ACTION
	#sudo ufw delete deny $ENV_PORT_ACTION
	#sudo ufw reload
	#sudo ufw status numbered
	#echo && echo -e "$PIK_GREEN Freshly deleted - Port $ENV_PORT_ACTION"

	# ufw-rules https://gist.github.com/pascalandy/e4ca1dc7fc225d0950d02c4e40ba1edc


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Secure shared memory" && echo
#echo "checkpoint 111 BYPASS $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#sed -i -e '$a tmpfs     /run/shm     tmpfs     defaults,noexec,nosuid     0     0' /etc/fstab


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Configure apt.conf.d/" && echo
#echo "checkpoint 112 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#echo 'APT::Get::Assume-Yes;' | sudo tee -a /etc/apt/apt.conf.d/00Do-not-ask
#	#detail https://goo.gl/lnLJkV


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Install Fail2Ban" && echo
#echo "checkpoint 114 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#sudo apt-get -qy install fail2ban --no-install-recommends
#
#FAILBAN_URL=https://gist.githubusercontent.com/pascalandy/264e9a38e7bddd90ee5bc9d8b9e4c348/raw/d7c32a0738772633014238c779c19c882cfd9084/fail2ban.local
#
#wget $FAILBAN_URL
#echo && cat fail2ban.local 
#cp fail2ban.local /etc/fail2ban/fail2ban.local
#rm -f fail2ban.local && echo && echo
#
#JAIL_URL=https://gist.githubusercontent.com/pascalandy/4e92a12ea807b4f8b7e6ddddef682289/raw/2e94e4485d45204eefe813f7809033a4d1e292c7/jail.local
#wget $JAIL_URL
#cp jail.local /etc/fail2ban/jail.local
#echo && cat jail.local
#rm -f jail.local && echo && echo
#
#sudo fail2ban-client reload
#sudo fail2ban-client reload sshd
#sudo fail2ban-client status 
#sudo fail2ban-client status sshd


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Harden network with sysctl settings " && echo
#echo "checkpoint BYPASS $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#echo -e "$PIK_BLUE IP Spoofing protection"
#echo -e "$PIK_BLUE Ignore ICMP broadcast requests"
#echo -e "$PIK_BLUE Disable source packet routing"
#echo -e "$PIK_BLUE Ignore send redirects"
#echo -e "$PIK_BLUE Block SYN attacks"
#echo -e "$PIK_BLUE Log Martians"
#echo -e "$PIK_BLUE Ignore ICMP redirects"
#echo -e "$PIK_BLUE Setting gc threshold for Docker Swarm"
#echo -e "$PIK_BLUE Setting vm.vfs_cache_pressure"
#echo -e "$PIK_BLUE Setting vm.swappiness"
#
#SYSCTL_URL=https://gist.githubusercontent.com/pascalandy/98c181a3d2869b3e40a7db8c879a39e4/raw/608a461e4604006788de9f489a77870bf5c36ce5/sysctl.conf
#wget $SYSCTL_URL
#cp sysctl.conf /etc/sysctl.conf
#echo && cat sysctl.conf
#rm -f sysctl.conf
#sudo sysctl -p && echo && echo


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Prevent Spoofing " && echo
#echo "checkpoint 116 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#HOST_URL=https://gist.githubusercontent.com/pascalandy/4aa0c1450d101e71532ae70db8ea059b/raw/498caf154866f36c1150c467df4fa1cf8baa92c4/host.conf
#wget $HOST_URL
#cp host.conf /etc/host.conf
#echo && cat host.conf
#rm -f host.conf && echo && echo


# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Adjust memory and swap accounting for Docker "
#echo && echo -e "$PIK_BLUE WARNING - not working on Scaleway" && echo
#sed -i -e '/GRUB_CMDLINE_LINUX_DEFAULT=""/ c\GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' /etc/default/grub
#sudo update-grub

# — — — # — — — # — — — #
# echo && echo -e "$PIK_BLUE Install RKHunter & CHKRootKit (Check for rootkits) " && echo
# sudo apt-get -q update && sudo apt-get -qy upgrade
# sudo apt-get -qy install rkhunter --no-install-recommends
# sudo apt-get -qy install chkrootkit --no-install-recommends
# sudo chkrootkit
	# ¯\_(ツ)_/¯ These 3 cmd needs to be executed manually because it stops our script
	# sudo rkhunter --update --skip-keypress
	# sudo rkhunter --propupd --skip-keypress
	# sudo rkhunter --checkall --skip-keypress

# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Adding user onfire " && echo
#sudo adduser onfire --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
#echo "onfire:#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA" | sudo chpasswd
#sudo usermod -aG sudo onfire
#sudo usermod -aG docker onfire
#wget https://gist.githubusercontent.com/pascalandy/a9b42d99896d46e7d307a65e3d696fb7/raw/c5966de548943c6217083dd9f21b3f05da53ba16/90-cloud-init-users
#cp 90-cloud-init-users /etc/sudoers.d/90-cloud-init-users
#echo && cat 90-cloud-init-users
#rm -f 90-cloud-init-users && echo && echo

# — — — # — — — # — — — #
# Infinit Storage

	#echo && echo -e "$PIK_BLUE Install infinit storage (Plan A)" # https://infinit.sh/documentation/docker/volume-plugin
	#echo "checkpoint 113 BYPASS $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	#
	#### Installation https://infinit.sh/get-started/linux
	#
	#### Export the user we would like to use
	#export INFINIT_USER=#_SENSITIVE_DATA#_SENSITIVE_DATA
	#
	#sudo apt-get -y update
	#sudo apt-get install -qy fuse
	#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D2C3B0B
	#sudo apt-get install -qy software-properties-common apt-transport-https
	#sudo apt-add-repository -y "deb https://debian.infinit.sh/ trusty main"
	#sudo apt-get -y update
	#sudo apt-get install -qy infinit
	#
	#### Removing PPA (it mess around apt-get udpate)
	#sudo add-apt-repository --remove "deb https://debian.infinit.sh/ trusty main"
	#
	#### Install psmisc so that we have the `killall` command
	#sudo apt-get install -qy psmisc
	#
	#### Update the `PATH` to include the Infinit binaries
	#export PATH=/opt/infinit/bin:$PATH
	#
	## Permanently set $PATH
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### ### ### ### ### ### ### ### ### ###" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### Adding infinit in our PATH" >> ~/.profile
	#echo "PATH=$PATH:/opt/infinit/bin" >> ~/.profile
	#
	#### Test the installation
	#cd /opt/infinit/bin && ls -la
	#echo "Unit-test. We should see infinit version here:"
	#infinit-user -v
	#
	# ---
	#
	#echo && echo -e "$PIK_BLUE Install infinit storage (Plan B)" # https://infinit.sh/documentation/docker/volume-plugin
	#echo "checkpoint 112 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	#
	#APP_DIR=infinit
	#INSTALL_VERSION=0.7.2
	#INSTALL_URL="https://storage.googleapis.com/sh_infinit_releases/linux64/Infinit-x86_64-linux_debian_oldstable-gcc4-$INSTALL_VERSION.tbz"
	#INSTALL_PACKAGE="Infinit-x86_64-linux_debian_oldstable-gcc4-$INSTALL_VERSION"
	#
	## /usr/local/bin/$DIRECTORY_NAME/bin
	#
	#sudo apt-get -q update && sudo apt-get -qy upgrade
	#rm -rf /tmp && mkdir /tmp && cd /tmp
	#wget $INSTALL_URL
	#tar xjvf $INSTALL_PACKAGE.tbz
	#
	#mv /tmp/$INSTALL_PACKAGE /tmp/$APP_DIR/
	#mv /tmp/$APP_DIR/ /bin/$APP_DIR
	#
	## Add infinit into our PATH
	#export PATH=$PATH:/bin/$APP_DIR/bin
	#
	## Permanently set $PATH
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### ### ### ### ### ### ### ### ### ###" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### Adding infinit in our PATH" >> ~/.profile
	#echo "PATH=$PATH:/bin/$APP_DIR/bin" >> ~/.profile
	#
	## Testing installation
	#cd /bin/$APP_DIR/bin && ls -la
	#infinit-user -v && echo
	#echo "The version shall match with: $INSTALL_VERSION" && echo
	#
	## Activate Docker Plugin
	## echo "user_allow_other" >> /etc/fuse.conf
	## echo "more config are required ..."
	#
	## Clean up
	#rm -rf /tmp && mkdir /tmp && cd /tmp
	#cd ~
	#
	# ---
	#
	#echo && echo -e "$PIK_BLUE Install Go"
	#echo "checkpoint 113A $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	#wget https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz
	#tar -C ${HOME} -xzf go1.7.4.linux-amd64.tar.gz
	#
	#export GOROOT=${HOME}/go
	#export GOPATH=${HOME}/work
	#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
	#
	#source ~/.bashrc
	#
	#go env
	#go version

# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# 12_server_config_script.sh
# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #

# Run the bash script
# cd ~/temp; ls -la; sleep 1; chmod +x ./$THIS_SCRIPT; ./$THIS_SCRIPT;
