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


### Show this which script is running
echo "checkpoint 200 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo;
echo "SCRIPT s2-main-config.sh"; echo; echo; sleep 2;

### Load env-var
source /root/temp/infra-as-code/_config.sh .

echo "Add cloudflare keys"
echo "checkpoint 201 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
mkdir -p $HOME/.cloudflare
touch $HOME/.cloudflare/env
echo "$ENV_CF_API_KEY" | tee -a $HOME/.cloudflare/env
echo "$ENV_CF_API_EMAIL" | tee -a $HOME/.cloudflare/env
#cat > $HOME/.cloudflare/env

# — — — # — — — # — — — #
echo && echo -e "Install system utilities"
echo "checkpoint 202 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
apt-get -qq update && \
apt-get -qqy upgrade && \
apt-get -qqy install \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
	lbzip2 \
	bzip2 \
	unzip \
	ccrypt \
	tree \
	secure-delete \
	git \
	git-core \
	openssl \
	ufw \
	htop \
	fail2ban \
	ntpdate \
	tzdata \
	httpie
	# 	sendmail \
		# zram-config works but cause freaking latency issues

echo "checkpoint 203 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#echo "Setup fail2ban"
## docs https://www.linode.com/docs/security/using-fail2ban-for-security
#
cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
cp /root/temp/infra-as-code/files/jail.local /etc/fail2ban/jail.local

service fail2ban restart
fail2ban-client reload
fail2ban-client status

echo "checkpoint 204 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# Hand^wScript hack the /etc/postfix/main.cf file because it was completely
# rewritten when the Debian configurator asked you some questions.
# echo "smtpd_tls_ciphers = high" >> /etc/postfix/main.cf
# echo "smtpd_tls_exclude_ciphers = aNULL, MD5, DES, 3DES, DES-CBC3-SHA, RC4-SHA, AES256-SHA, AES128-SHA" >> /etc/postfix/main.cf
# echo "smtp_tls_protocols = !SSLv2, !SSLv3" >> /etc/postfix/main.cf
# echo "smtpd_tls_mandatory_protocols = !SSLv2, !SSLv3" >> /etc/postfix/main.cf
# echo "smtp_tls_note_starttls_offer = yes" >> /etc/postfix/main.cf
# echo "smtpd_tls_received_header = yes" >> /etc/postfix/main.cf
# echo "" >> /etc/postfix/main.cf

echo "checkpoint 205 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# These are always good to have around.
apt-get install -y libpam-pwquality unattended-upgrades
apt-get install -y haveged openntpd lynx sslscan sysstat
apt-get install -y openssl-blacklist openssl-blacklist-extra
apt-get install -y openssh-blacklist openssh-blacklist-extra


echo "checkpoint 206 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	# Postfix sends mail.
	# AIDE monitors the file system.
	# Logwatch parses the logfiles and mails you about anomalies.
apt-get install -y postfix aide logwatch libdate-manip-perl

#logwatch_reporter
# make it run weekly

# Need to confifgure /usr/share/logwatch/default.conf/logwatch.conf
# mv /etc/cron.daily/00logwatch /etc/cron.weekly/

#sed -i -e 's/\/usr\/sbin\/logwatch/#\/usr\/sbin\/logwatch/g' /etc/cron.daily/00logwatch
#echo -e "\n/usr/sbin/logwatch --mailto $SYS_ADMIN_EMAIL --detail high --format html\n" >> /etc/cron.daily/00logwatch

# logwatch | less
# logwatch --mailto mail@domain.com --output mail --format html --range 'between -7 days and today' 


echo "checkpoint 207 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
echo && echo -e "Setting swap: " && echo
swapsize="$ENV_SWAP_SIZE"
fallocate -l $swapsize /swapfile;
ls -lh /swapfile
chmod 600 /swapfile;
ls -lh /swapfile
mkswap /swapfile;
swapon /swapfile;
swapon --show
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

echo "checkpoint 208 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# This the standard network file sharing for Unix/Linux/BSD
# style operating systems.
# Unless you require to share data in this manner,
# less layers = more sec
apt-get --yes purge nfs-kernel-server nfs-common portmap rpcbind autofs


echo "checkpoint 209 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# Set up Daily Time Syncro
echo -e "\n Setting up ntpdate.\n"
echo -e "ntpdate us.pool.ntp.org ntp.ubuntu.com" > /etc/cron.daily/ntpdate && chmod +x /etc/cron.daily/ntpdate


echo "Install Docker: "
echo "checkpoint 210 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
curl -sSL https://get.docker.com/ | sh


echo "checkpoint 211 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
#empty

echo "checkpoint 212 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
#empty

echo "checkpoint 213 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
#empty

echo "checkpoint 214 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
echo; echo; echo;
docker run -it --rm mbentley/figlet "A big cheers!";
docker run -it --rm mbentley/figlet "to the";
docker run -it --rm mbentley/figlet "FirePress Team"; sleep 2;
echo; echo; echo;


# — — — # — — — # — — — #
echo "checkpoint 215 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
echo && echo -e "Set timezone "

# Configure
#timedatectl list-timezones

timedatectl set-timezone America/New_York
timedatectl set-ntp yes
echo && echo -e "Verify that the timezone has been set properly"
timedatectl

# — — — # — — — # — — — #
echo && echo -e "Setting swap: " && echo
echo "checkpoint 216 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#empty


# — — — # — — — # — — — #
echo "checkpoint 217 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#empty


# — — — # — — — # — — — #
#sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
echo "checkpoint 218 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

#echo && echo -e "Changing SSH port" && echo
#echo "checkpoint 112 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#sed -i -e 's/Port 22/Port 220/' /etc/ssh/sshd_config
#sudo /etc/init.d/ssh restart

# — — — # — — — # — — — #
# clone | deploy-setup
echo "checkpoint 219 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# SENSITIVE_DATA
cd ~
git clone "$GITLAB_DEPLOY_SETUP_URL"
cd ~/$GITLAB_DEPLOY_SETUP_REPO_NAME; sleep 0.5;
git config --global user.name "$GITLAB_DEPLOY_SETUP_USER";
git config --global user.email "$GITLAB_DEPLOY_SETUP_EMAIL";
git checkout "$GITLAB_DEPLOY_SETUP_BRANCH"; sleep 1; 

echo;
GITLAB_DEPLOY_SETUP_URL="";
GITLAB_DEPLOY_SETUP_BRANCH="";
GITLAB_DEPLOY_SETUP_REPO_NAME="";
GITLAB_DEPLOY_SETUP_USER="";
GITLAB_DEPLOY_SETUP_EMAIL="";

# clone | deploy-logs
echo "checkpoint 220 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#_SENSITIVE_DATA#_SENSITIVE_DATA
cd ~

git clone "$GITLAB_DEPLOY_LOGS_URL"
cd ~/$GITLAB_DEPLOY_LOGS_REPO_NAME; sleep 0.5;
git config --global user.name "$GITLAB_DEPLOY_LOGS_USER";
git config --global user.email "$GITLAB_DEPLOY_LOGS_EMAIL";
git config --global push.default matching;
git checkout "$GITLAB_DEPLOY_LOGS_BRANCH"; sleep 1;

echo;
GITLAB_DEPLOY_LOGS_URL="";
GITLAB_DEPLOY_LOGS_REPO_NAME="";
GITLAB_DEPLOY_LOGS_USER="";
GITLAB_DEPLOY_LOGS_EMAIL="";
GITLAB_DEPLOY_LOGS_BRANCH="";

# — — — # — — — # — — — #
echo && echo -e "Clean Up " && echo
echo "checkpoint 221 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
apt-get -q update && apt-get -qy upgrade
#apt-get -qy dist-upgrade
apt-get -y autoclean -y
apt-get -y autoremove
apt-get purge
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# End of this script
echo "checkpoint 222 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
hostname && echo