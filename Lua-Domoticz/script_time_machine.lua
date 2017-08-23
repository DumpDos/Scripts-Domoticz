-------------------------------------------------------------------------------------------------------------
-- script_time_machine.lua ----------------------------------------------------------------------------------
-- Script d'origine créé par plutonium > https://www.domoticz.com/forum/viewtopic.php?f=23&t=253 ------------
-- DumpDos 2016----------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
-- Ce script est destiné à la gestion des nofifications lors de l'arret ou la fin d'un cycle machine --------
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local Machine 		= 'Lave-Linge'              -- Nom du capteur virtuel déstiné à la machine 
local Consommation  	= 'Wattmètre Lave-Linge'    -- Nom du Wattmètre de la machine 
local Variable_machine  = 'Machine'                 -- Nom de la variable utilisateur destinée au compteur
local Intervalle_conso  = '3'                       -- Intervalle de consommation minimum (En minute)
local Consommation_sup  = 2                         -- Seuil d'activation de la machine (En Watts)
local Consommation_inf  = 1                         -- Seuil de désactivation de la machine (En Watts)
 
-------------------------------------------------------------------------------------------------------------
-------------------------------------- Fin des Variables à Editer -------------------------------------------
-------------------------------------------------------------------------------------------------------------

commandArray = {}

-- Vérification des conditions --
if (tonumber(otherdevices_svalues[Consommation])) > Consommation_sup and otherdevices[Machine] == 'Off' then
      
	-- Changement d'état --
	commandArray[Machine]='On'
	print('Machine : Démarrage cycle')
	commandArray['Variable:' .. Variable_machine]=tostring(Intervalle_conso)

else 
	-- Vérification des conditions --
	if (tonumber(otherdevices_svalues[Consommation])) <=  Consommation_inf and otherdevices[Machine] == 'On' then
		
		-- Envoi variable --
		commandArray['Variable:' .. Variable_machine]=tostring(math.max(uservariables[Variable_machine] - 1, 0))
        end
end

-- Vérification des conditions --
if (otherdevices[Machine] == 'On' and uservariables[Variable_machine] == 0) then

	-- Changement d'état et envoi notification --
	print('Machine : Arrêt Cycle')
	commandArray['SendNotification']='Lave-Linge#Cycle Fini#0'
	commandArray[Machine]='Off'
	
end   

return commandArray
