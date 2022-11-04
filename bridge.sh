#! /bin/bash

# -------- Show Connections with nmcli -----------------------------------------------------
function show()
{
	read -p "Do You Neet To See What Connections There Are?[y/n] " answer1
	answer1=${answer:-"y"}
	if [[ $answer1 = @("y"|"yes") ]];then
		echo "------------ You Have These Connections -----------------------"
		nmcli connection show 
	fi
}

show

# ------ Choosing Ethernet to be slave for bridge --------------------------------------------
read -p "Which ethernet you need to be slave for $BR_NAME :" BR_INT
while [[ $BR_INT = "" ]];do
	echo "You have to choose an etherntet connection"
	read -p "Which ethernet you need to be slave for $BR_NAME :" BR_INT
done

read -p "Name for bridge [br10]: " BR_NAME
BR_NAME=${BR_NAME:-"br10"}

#BR_NAME="br10"
#BR_INT="enp7s0"
##SUBNET_IP="192.168.1.105/24"
#GW="192.168.1.1"
#DNS1="8.8.8.8"
#DNS2="8.8.4.4"
#

function main(){
	sudo nmcli connection add type bridge autoconnect yes con-name ${BR_NAME} ifname ${BR_NAME}
	sudo nmcli connection modify ${BR_NAME} ipv4.dns ${DNS1} +ipv4.dns ${DNS2}
  sudo nmcli connection delete ${BR_INT}
  sudo nmcli connection add type bridge-slave autoconnect yes con-name ${BR_INT} ifname ${BR_INT} master ${BR_NAME}
  sudo nmcli connection up br10
  # For getting ip from dhcp it needs to connection reload 
  sudo nmcli connection reload
}

function Auto(){
	sudo nmcli connection modify ${BR_NAME} ipv4.method auto

}

function Manual(){
	sudo nmcli connection modify ${BR_NAME} ipv4.addresses ${SUBNET_IP} ipv4.method auto
	sudo nmcli connection modify ${BR_NAME} ipv4.gateway ${GW}

}

