---------------------------------------------------------------------------
-- script_device_courant.lua ----------------------------------------------
-- DumpDos 2017 -----------------------------------------------------------
---------------------------------------------------------------------------
-- Ce script permet le calcul approximatif d'un courant à l'aide ----------
-- d'un dipositif fournissant un index de puissance. ----------------------
---------------------------------------------------------------------------
-- Veiller à utiliser une puissance en Watt, pas en VA ! ------------------
---------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local compteur	= 'Compteur Général'	-- Capteur puissance en Watt /!\
local tension	= 'Tension Secteur'	-- Capteur tension
local afficheur	= idx			-- Afficheur virtuel ampérage

-------------------------------------------------------------------------------------------------------------
----------------------------------------------- Fonction ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Fonction arrondi --
function arrondi(nombre, decimales)
  local conversion = 10^(decimales or 0)
  return math.floor(nombre * conversion + 0.5) / conversion
end

-- Fonction mise à jour des capteurs virtuels --
function update(idx, valeur1)
    local commande = string.format("%d|0|%.2f", idx, valeur1 )
    table.insert (commandArray, { ['UpdateDevice'] = commande } )
end

-------------------------------------------------------------------------------------------------------------
------------------------------------------- Fin des fonctions -----------------------------------------------
-------------------------------------------------------------------------------------------------------------
 
commandArray = {}

-- Vérification des conditions --
 if devicechanged[compteur] then
 
	-- initialisation des variables
	 watt, wattheure 	= string.match(otherdevices_svalues[compteur], "(%d+.%d*);(%d+.%d*)")
	 volt			= tonumber (otherdevices_svalues[tension])
	 
	 -- Calcul du courant -- 
	 courant_brut = (watt/volt)
	 
	 -- Arrondi --
	 courant = arrondi(courant_brut, 3)
	 
	 -- Actualisation afficheur virtuel --
	 update(afficheur, courant)

end

return commandArray
