#!/bin/bash
#=== device_control_dimmer.sh ===#
#=== DumpDos 2017 ===#

#####################################################################$

# === Variables à éditer  === #
IP=xxx.xxx.xxx.xxx:8080

# === Variables d'entrées === #
_commande=null    #-- temps de transition
_idx=null         #-- liminosité

#####################################################################$

# === paramètres entrées === #
if [[ $# -eq 1 ]]; then
       _idx=$1

elif [[ $# -eq 2 ]]; then
       _idx=$1
       _level=$2

fi


# === Initialisation des variables === #
url="http://${IP}/json.htm?type=command&param=switchlight&idx=$_idx&switchcmd=Set%20Level&level=$_level"
# === curl === #
curl "${url}"

# === fin === #
echo -e "\n\n" && exit 1
