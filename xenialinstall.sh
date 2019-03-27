#!/bin/bash
wget https://github.com/mistermint/Zabbix-Installer/releases/download/1/zabbix-xenial.deb
sudo dpkg -i zabbix-xenial.deb
sudo apt-get update
sudo apt-get install zabbix-agent -y
sudo sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"
echo "What do you want to call this agent?"
read agentName
cat > /etc/zabbix/zabbix_agentd.conf << EOL
Server=65.50.230.94
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
