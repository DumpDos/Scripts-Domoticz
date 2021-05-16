#!/bin/bash

#== VARIABLES UTILISATEUR ==#
IP=xxx.xxx.xxx.xxx
USR=user
PWD=password

#== VARIABLES DE TRAVAIL ==#

msg=$1

xml="<TextOverlay>
        <id>2</id>
        <enabled>true</enabled>
        <posX>673</posX>
        <posY>40</posY>
        <message>${msg}</message>
        </TextOverlay>"


url="http://${USR}:${PWD}@${IP}/Video/inputs/channels/1/overlays/text/2"

#== CURL ==#
curl -d "$xml" -X PUT "$url"

#== FIN ==#
echo -e "\n\n" && exit 1
