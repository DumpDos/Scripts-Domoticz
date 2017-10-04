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
## Hue State

Ce script est dédié au retour d'état des ampoules hue dans domoticz

### Variables modifiables :

- IDX
- Ip

### Utilisation :
 
 ```
chmod +x hue_state.sh
./hue_state.sh <idx groupe ampoules hue> <idx device domoticz>
