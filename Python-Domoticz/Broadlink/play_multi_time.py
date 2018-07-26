#!/usr/bin/python
# coding: utf-8
# DumpDos 2018

#--- Librairies ---#

import broadlink
import time
import sys

#--- Variables ---#

ip	= "192.168.xx.xx"
mac 	= "xxxxxxxxxxxx"
port    = 80
timeout = "30"

#--- Fonctions ---#

def read_file(file, sleep):

    var_time = float(sleep)
    data = open(file, 'r')
    myhex = data.read()
    device.send_data(myhex.decode('hex'))
    time.sleep(var_time)

def is_number(var):
    try:
        float(var)
        return True
    except ValueError:
        return False

#--- Script ---#

try:
    fileName_0 = sys.argv[1]

except IndexError:
    fileName_0 = 'null'

if fileName_0 == 'null':
    print "Erreur - arguments non-valides"
    print "Utilisation: play_multi.py <délai> <fichier 1> <fichier 2>..."
    sys.exit()
else:

    device = broadlink.rm((ip,port), mac, timeout)
    arg_list = list(sys.argv)
    arg_numb = len(sys.argv)
    var_time = 1
    var_agmt = 2

    print "Connexion au module Broadlink..."
    device.auth()
    time.sleep(1)

    print "Connecté..."

    time.sleep(1)
    device.host



    while not var_agmt == arg_numb:
        
        arg_time = arg_list[var_time]
        
        if is_number(arg_time) == True:
            
            var_time = var_time + 2
            read_file(arg_list[var_agmt], arg_time)
            var_agmt = var_agmt + 2
            print "Code envoyé"
        else if is_number == False:
            print "Erreur - arguments non-valides"
            print "Utilisation: play_multi.py <délai> <fichier 1> <fichier 2>..."
            sys.exit()

else:

    print "Erreur - Arguments"
print "Utilisation: play_multi.py <délai> <fichier 1> <fichier 2>..."
