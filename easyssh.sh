#!/bin/bash

printf "\n"
sleep 0.8
printf "Author: sidious \n"
sleep 0.8
printf "Easy SSH File Transfer Script: \n"
sleep 0.8
printf "Version 1.1 \n"
printf "\n"


error(){
  echo >&2 "$(tput bold; tput setaf 1)[-] ERROR: ${*}$(tput sgr0)"
}

msg(){
  echo "$(tput bold; tput setaf 2)[+] ${*}$(tput sgr0)"
}


rootperm(){
  if [ "$(id -u)" -ne 0 ]; then
    error "You must be root"
        exit 1
  fi
}

sshcheck(){
  dpkg-query -l  | grep -i openssh-server > /dev/null 2>&1 
  if [ $? -eq 0 ]; then
    msg "openSSH is Installed."
  else
    msg "Installing openSSH-server."; apt update > /dev/null 2>&1; apt install openssh-server --yes > /dev/null 2>&1; msg "Installation successful."
  fi
}

sshdcop(){
    cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config
    cat <<EOT >/etc/ssh/sshd_config    
    Protocol 2
    IgnoreRhosts yes
    HostbasedAuthentication no
    PermitRootLogin no
    PermitEmptyPasswords no
    X11Forwarding no
    MaxAuthTries 5
    ClientAliveInterval 900
    ClientAliveCountMax 0
    UsePAM yes
    HostKey /etc/ssh/ssh_host_ed25519_key
    HostKey /etc/ssh/ssh_host_rsa_key
    KexAlgorithms curve25519-sha256@libssh.org
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
EOT
    #systemctl restart sshd.service && systemctl status sshd.service > /dev/null 2>&1  
    /etc/init.d/ssh restart > /dev/null 2>&1  
    
    if [ $? -eq 0 ]; then
        msg "SSH configuration is done."
        sshd_chk=1
    else
        error "sshd_config file could not be hardened, check user permissions.. exiting.." && exit 1
    fi
}

setperm(){
    chown root:root /etc/ssh/sshd_config
    chmod 600 /etc/ssh/sshd_config
    chown root:root /etc/anacrontab
    chmod og-rwx /etc/anacrontab
    chown root:root /etc/crontab
    chmod og-rwx /etc/crontab
    chown root:root /etc/cron.hourly
    chmod og-rwx /etc/cron.hourly
    chown root:root /etc/cron.daily
    chmod og-rwx /etc/cron.daily
    chown root:root /etc/cron.weekly
    chmod og-rwx /etc/cron.weekly
    chown root:root /etc/cron.monthly
    chmod og-rwx /etc/cron.monthly
    chown root:root /etc/cron.d
    chmod og-rwx /etc/cron.d
    chown root:root /etc/passwd
    chmod 644 /etc/passwd
    chown root:root /etc/group
    chmod 644 /etc/group
    chown root:root /etc/shadow
    chmod 600 /etc/shadow
    chown root:root /etc/gshadow
    chmod 600 /etc/gshadow
}


createuser(){   
  USNA="$(echo $RANDOM | md5sum | head -c 4; echo)" 
  useradd -m $USNA
  DAT="$(date +%s | sha256sum | base64 | head -c 32 ; echo)"
  echo $USNA:$DAT | chpasswd
}


rootperm 
sshcheck
sshdcop
setperm > /dev/null 2>&1
createuser
NORMAL="\033[0;39m"
printf "$NORMAL-----------------------------------------------\n"
msg "username: $USNA" 
msg "password: $DAT"
printf "$NORMAL-----------------------------------------------\n"


