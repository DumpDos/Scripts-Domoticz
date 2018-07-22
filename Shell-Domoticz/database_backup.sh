#!/bin/bash
#=== database_backup.sh ===#
#=== DumpDos 2018 ===#

#-- Variables --#
dz_ip='192.168.xxx.xxx'
dz_port='8080'

nas_ip='192.168.xxx.xxx'
nas_user='user'
nas_pass='password'

file_emp="/home/Domoticz.db"
save_emp="/Sauvegarde/Domoticz.db"

##############
#-- Script --#
##############

#-- Wget --#
wget http://$dz_ip:$dz_port/backupdatabase.php -O $file_emp

#-- FTP --#
ftp -n $nas_ip <<END_SCRIPT
user $nas_user $nas_pass
put $file_emp $save_emp
bye
END_SCRIPT
exit 0
