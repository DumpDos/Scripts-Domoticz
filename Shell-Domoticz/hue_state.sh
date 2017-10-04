#!/bin/bash
#=== hue_state.sh ===#
#=== DumpDos 2017 ===#
#####################################################################

# === Variables à éditer  === #
IP1=192.168.0.16:80 		    #-- ip hue bridge
IP2=192.168.0.11:8080		    #-- ip domoticz
USER=0123456789abcdefghijkl	#-- clé api hue

# === Variables de travail === #
off='"Off"'	
on='"On"'

# === Variables d'entrées === #
_groupe=null
_idx=null

#####################################################################
# === paramètres entrées === #
if [[ $# -eq 1 ]]; then
       _groupe=$1

elif [[ $# -eq 2 ]]; then
       _groupe=$1
       _idx=$2

fi

#####################################################################
#					               		  Script				              		  		#
#####################################################################

# === Initialisation des variables === #
url0="http://${IP1}/api/${USER}/groups/${_groupe}"
url1="http://${IP2}/json.htm?type=devices&rid=${_idx}"
url2="http://${IP2}/json.htm?type=command&param=switchlight&idx=${_idx}&switchcmd=On"
url3="http://${IP2}/json.htm?type=command&param=switchlight&idx=${_idx}&switchcmd=Off"

# === curl === #
json_hue=$(curl "${url0}") 
json_dmz=$(curl "${url1}")

# === Récupération des données === #
etat_hue=$(echo $json_hue | jq '.action.on')
etat_dmz=$(echo $json_dmz | jq '.result[].Data')

# === Affichage des données === #
echo "pont: "$etat_hue
echo "domo: "$etat_dmz

# === Vérification des condition et changement d'état === #
if $etat_hue
then
	if [ $etat_dmz = $off ]
	then
	curl "${url2}"
	echo "Changement a ON"
	fi

elif ! $etat_hue
then
	if [ $etat_dmz = $on ]
        then
	curl "${url3}"
	echo "Changement a OFF"
	fi
fi

# === fin === #
echo -e "\n\n" && exit 1
