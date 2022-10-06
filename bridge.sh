#! /bin/bash
# Here Creating a bridge connection 
# which master is br10
# Slave is eth device 
# to use it in kvm , other stuffs 

BR_NAME="br10"
BR_INT="enp7s0"
#SUBNET_IP="192.168.4.0/24"
GW="192.168.4.1"
DNS1="8.8.8.8"
DNS2="8.8.4.4"
sudo nmcli connection add type bridge autoconnect yes con-name ${BR_NAME} ifname ${BR_NAME}
sudo nmcli connection modify ${BR_NAME} ipv4.addresses ${SUBNET_IP} ipv4.method dhcp
sudo nmcli connection modify ${BR_NAME} ipv4.gateway ${GW}
sudo nmcli connection modify ${BR_NAME} ipv4.dns ${DNS1} +ipv4.dns ${DNS2}
sudo nmcli connection delete ${BR_INT}
sudo nmcli connection add type bridge-slave autoconnect yes con-name ${BR_INT} ifname ${BR_INT} master ${BR_NAME}
sudo nmcli connection up br10
# For getting ip from dhcp it needs to connection reload 
sudo nmcli connection reload
sudo nmcli connection show 
