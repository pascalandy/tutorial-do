https://gist.github.com/noogen/66eab3fb094adbe2118fd0235f233440

# From Fresh install
## 1) update and upgrade as root
```
apt-get update && apt-get upgrade -y
```

* Setting up hostname, skip if done with installation

pico /etc/hosts
```
127.0.0.1       localhost
127.0.1.1       name.example.com       name

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

yo.ur.ip.addy name.example.com
```

pico /etc/hostname
```
name.example.com
```
## 2) Disable ssh root login

*  Add sudoer
```
adduser tommy
usermod -aG sudo tommy
```

* Disable root login
```
pico /etc/ssh/sshd_config
```

Change the port and disable root login
```
Port 2210
PermitRootLogin no
```

* Restart sshd
```
service sshd restart
```

* Open another local console/terminal and test your login
```
ssh tommy@you-server -p 2210
```

## 3) Install fail2ban
Synchronize the system clock and fail2ban
```
sudo apt-get -y install ntpdate fail2ban
```

sudo pico /etc/fail2ban/jail.conf

Use ctrl+w to locate [sshd]:
```
[sshd]

port    = 2210
logpath = %(sshd_log)s
enabled  = true
filter   = sshd
maxretry = 3
```

* Restart fail2ban
```
sudo service fail2ban restart
```

# 4) Disable IPv6 and hardening IPv4
```
sudo ip6tables -P INPUT DROP
sudo ip6tables -P OUTPUT DROP
sudo ip6tables -P FORWARD DROP
mv /etc/sysctl.conf /etc/sysctl.conf.bak
pico /etc/sysctl.conf
```

Edit sysctl.conf with:
```
# IP Spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0 
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Block SYN attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0 
net.ipv6.conf.default.accept_redirects = 0

# Ignore Directed pings
net.ipv4.icmp_echo_ignore_all = 1

# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

* Restart and apply the config
```
sudo sysctl -p
```

# 5) Unattended security update
This step is to keep your server up-to-date with latest Security Updates.  Only perform this step if Security is of highest concern.  Even though security updates mostly has low system impact, as with any kind of software update/changes, there always will be the possibility of it affecting your system stability.

pico /etc/apt/apt.conf.d/10periodic
```
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
```
