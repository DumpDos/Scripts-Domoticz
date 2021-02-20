#!/bin/bash

#####################################################################$

# === Variables à éditer  === #
IP=xxx.xxx.xxx.xxx
USR=username
PWD=password


# === Variables d'entrées === #
_goto=null    #-- Position caméra
_channel=null #-- Canal caméra

#####################################################################$

# === paramètres entrées === #
if [[ $# -eq 1 ]]; then
       _goto=$1

elif [[ $# -eq 2 ]]; then
       _goto=$1
       _channel=$2

fi

# === Initialisation des variables === #
url="http://${USR}:${PWD}@${IP}/ISAPI/PTZCtrl/channels/$_channel/presets/$_goto/goto"

# === curl === #
curl -X PUT "${url}"

# === fin === #
echo -e "\n\n" && exit 1
