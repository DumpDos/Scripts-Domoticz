#!/bin/bash

#####################################################################$

# === Variables à éditer  === #
IP=xxx.xxx.xxx.xxx:8080

# === Variables d'entrées === #
_commande=null    #-- Commande On ou Off
_idx=null         #-- Idx switch domoticz

#####################################################################$

# === paramètres entrées === #
if [[ $# -eq 1 ]]; then
       _idx=$1

elif [[ $# -eq 2 ]]; then
       _idx=$1
       _commande=$2

fi


# === Initialisation des variables === #
url="http://${IP}/json.htm?type=command&param=switchlight&idx=$_idx&switchcmd=$_commande"
# === curl === #
curl "${url}"

# === fin === #
echo -e "\n\n" && exit 1
