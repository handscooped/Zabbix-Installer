com="lsb_release -c | awk {'print \$2'}"
ver=$(eval "$com")
com="sudo wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+"$ver"_all.deb"
eval "$com"
com="sudo dpkg -i zabbix-release_4.0-2+"$ver"_all.deb"
eval "$com"
sudo apt-get update
sudo apt-get install zabbix-agent -y
sudo sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"
echo "What do you want to call this agent?"
read agentName
cat > /etc/zabbix/zabbix_agentd.conf << EOL
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=65.50.230.94
ServerActive=65.50.230.94
Hostname=Zabbix server
Include=/etc/zabbix/zabbix_agentd.d/*.conf
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=$agentName
TLSPSKFile=/etc/zabbix/zabbix_agentd.psk
EOL
sudo systemctl start zabbix-agent
sudo systemctl enable zabbix-agent
cat /etc/zabbix/zabbix_agentd.psk
echo $agentName
read -p "Copy down PSK string and press enter to continue..."
sleep 10
sudo systemctl status zabbix-agent
read -p "If Zabbix Agent is running. Press enter to end installation"
