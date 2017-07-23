#!/bin/bash

##################################################################################################

# === Variables à éditer  === #
IP=0.0.0.0
USER=abcdef0123456789
ID=1

# === Variables d'entrées === #
_transecondes=2         #-- temps de transition
_luminosite=254         #-- liminosité
_temperature=153        #-- température de couleur

###################################################################################################

# === paramètres entrées === #
if [[ $# -eq 1 ]]; then
       _transecondes=$1

elif [[ $# -eq 2 ]]; then
       _transecondes=$1
       _luminosite=$2

elif [[ $# -eq 3 ]]; then
       _transecondes=$1
       _luminosite=$2
       _temperature=$3

fi

# === conversion === #
_transition=$(( $_transecondes  * 10 ))

# === Initialisation des variables === #
url="http://${IP}/api/${USER}/groups/${ID}/action"
data="{\"on\": true, \"bri\":$_luminosite, \"ct\":$_temperature, \"transitiontime\":$_transition}"

# === curl === #
curl --Request PUT --data "${data}" "${url}"

# === fin === #
echo -e "\n\n" && exit 1
