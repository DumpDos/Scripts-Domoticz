# Shell-Domoticz
Scripts Shell pour Domoticz

## Hue Control

Ce script est dédié au contrôle des lampes phillips Hue white ambiance.

### Variables modifiables :

- Temps de transition
- Intensité lumineuse
- Température de couleur

### Utilisation :
 
 ```
chmod +x hue_control.sh
./hue_control.sh <temps de transition> <intensité> <température de couleur>
```

## Hue State

Ce script est dédié à la récupération de l'état des lampes hue

### Variables modifiables :

- Ip
- Clé Api

### Utilisation :
 
 ```
chmod +x hue_state.sh
./hue_state.sh <groupe de lampes> <id lampe>
```

## Device control

Ce script est dédié au contrôle des switch domoticz

### Variables modifiables :

- Ip

### Utilisation :
 
 ```
chmod +x device_control.sh
./device_control.sh <idx> <On/Off>
```


## Device control dimmer

Ce script est dédié au contrôle des variateurs domoticz

### Variables modifiables :

- Ip

### Utilisation :
 
 ```
chmod +x device_control_dimmer.sh
./device_control_dimmer.sh <idx> <level>
```
## Database Backup

Ce script est dédié à la sauvegarde de la base de donnée sur un support FTP

### Variables modifiables :

- Ip
- Port
- Utilisateur
- Mot de passe
- Emplacement fichiers

### Utilisation :
 
 ```
chmod +x database_backup.sh
./database_backup.sh
 ```
 
