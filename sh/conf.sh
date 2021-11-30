#!/bin/bash
#########################################
# Alfredo                               #
# 03/03/2021                            #
#                                       #
# Script para configurações e downloads #
#                                       #
# *run as root*                         #
# su                                    #
# ./conf.sh                             #
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

#quick sqli
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/SQLi/quick-SQLi.txt;

#generic sqli
https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/SQLi/Generic-SQLi.txt;

#blind sqli
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/SQLi/Generic-BlindSQLi.fuzzdb.txt;

#sqli auth bypass
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Fuzzing/Databases/sqli.auth.bypass.txt;

#dates
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Miscellaneous/security-question-answers/dates.txt;

#palavras em português
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Miscellaneous/lang-portuguese.txt;

#backdoor
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Web-Shells/backdoor_list.txt;

#windows writeable locations
https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/File-System/windows-writable-locations.txt;

#secret keywords

wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Variables/secret-keywords.txt;

#descompactar rockyou
gzip -d rockyou.txt.gz;

cd ~;
# autalizar pip 
pip3 install --upgrade pip;

#gem install
gem install winrm winrm-fs colorize;

#add socks5 proxychains
echo "socks5 127.0.0.1 9050" >> /etc/proxychains.conf;

# proxychains de strict para radom chain
sed -i 's/strict_chain/#strict_chain/' /etc/proxychains.conf;
sed -i 's/#random_chain/random_chain/' /etc/proxychains.conf;

# identação vim root
echo -e "set tabstop=4\nset expandtab" >> ~/.vimrc;

# identação vim usuario
echo -e "set tabstop=4\nset expandtab" >> /home/$USER/.vimrc;

# download linPEAS and winPEAS
wget https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh;

wget https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/winPEAS/winPEASbat/winPEAS.bat;

# download ffuf
wget https://github.com/ffuf/ffuf/releases/download/v1.2.1/ffuf_1.2.1_linux_amd64.tar.gz;
tar -xzf ffuf_1.2.1_linux_amd64.tar.gz;
rm CHANGELOG.md LICENSE README.md ffuf_1.2.1_linux_amd64.tar.gz;
mv ffuf /bin/ffuf;
chmod +x /bin/ffuf;

#download enum4linux
git clone https://github.com/CiscoCXSecurity/enum4linux.git /opt/enum4linux;

#download reGeorge
git clone https://github.com/sensepost/reGeorg.git /opt/reGeorg;

#download pspy
wget https://github.com/DominicBreuker/pspy/releases/download/v1.2.0/pspy64;
mv pspy64 /bin/pspy;
chmod 755 /bin/pspy;

cd /usr/share/windows-binaries;
#Download nc64
wget https://github.com/int0x33/nc.exe/raw/master/nc64.exe;

#Download mimikatz
wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200918-fix/mimikatz_trunk.zip;
unzip -d mimikatz mimikatz_trunk.zip;

cd ~;
# limpa cache
echo 3 > /proc/sys/vm/drop_caches
sysctl -w vm.drop_caches=3;

echo "Settings Accomplished"

sleep 3

clear
