#!/bin/bash
#########################################
# Alfredo                               #
# 03/03/2021                            #
#                                       #
# Script para configurações e downloads #
#                                       #
# *run as root*                         #
#                                       #
#########################################

# resolve erro NO_PUBKEY
apt update 2>&1 1>/dev/null | sed -ne 's/.*NO_PUBKEY //p' | while read key; do if ! [[ ${keys[*]} =~ "$key" ]]; then sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys "$key"; keys+=("$key"); fi; done;

# download de algumas wordlists
cd /usr/share/wordlists/;

#raft-large-directories
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-directories.txt;

#raft-large-files
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-files.txt;

#raft-large-words
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-words.txt;

#password fuzz
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/Passwords.fuzz.txt;

#linux file list
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/LinuxFileList.txt;

#login fuzz
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/Logins.fuzz.txt;

#descompactar rockyou
gzip -d rockyou.txt.gz;

cd ~;
# autalizar pip 
pip3 install --upgrade pip;

#add socks5 proxychains
echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf;

# proxychains de strict para radom chain
sed -i 's/strict_chain/#strict_chain/' /etc/proxychains.conf;
sed -i 's/#random_chain/random_chain/' /etc/proxychains.conf;

# identação vim root
echo -e "set tabstop=4\nset expandtab" >> ~/.vimrc;

# identação vim usuario
echo -e "set tabstop=4\nset expandtab" >> /home/$USER/.vimrc;

# limpa cache
echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3

