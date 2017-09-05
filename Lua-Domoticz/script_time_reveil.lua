---------------------------------------------------------------------------
-- script_time_reveil.lua -------------------------------------------------
---------------------------------------------------------------------------
-- Script original par Vil1driver : ---------------------------------------
-- http://easydomoticz.com/forum/viewtopic.php?t=670#p5106 ----------------
---------------------------------------------------------------------------
-- Modifié par DumpDos ----------------------------------------------------
---------------------------------------------------------------------------
-- Ce script est dédié à la gestion du réveil dans domoticz ---------------
---------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local variable	= "nom variable"	-- Variable réveil
local texte	= 001			-- Idx afficheur texte  

-------------------------------------------------------------------------------------------------------------
---------------------------------------- Variables de Travail -----------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Différence temps --
time 	= os.date("*t")
h 	= uservariables[variable]
heures 	= string.sub(h, 1, 2)
minutes = string.sub(h, 4, 5)
jour 	= string.sub(h, 9, 10)
mois 	= string.sub(h, 12, 13)
annee 	= string.sub(h, 15, 18)
t1 	= os.time{year=annee, month=mois, day=jour, hour=heures, min=minutes, sec=00}
temps 	= os.difftime(t1, os.time())

--------------------------------------------------------------------------------------------------------------
------------------------------------------------ Script ------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

commandArray = {}

-- Récupération de l'heure --
now = os.date("*t")

-- Vérification des conditions --
if now.min % 30 == 0 then

    -- initialisation variable --
	local string = uservariables[variable]
	local heure_st, jour_semaine_st, jour_st, mois_st, annee_st = string.match (string, "(%d%d%p%d%d)-(%d)-(%d%d)/(%d%d)/(%d%d%d%d)" )

	-- Vérification des conditions --
	if annee_st >= '2016' then
	
		-- Conversion jour semaine
		if jour_semaine_st == '1' then
		 jour_semaine = 'Dimanche'
		 
		elseif jour_semaine_st == '2' then
		 jour_semaine = 'Lundi'
		
		elseif jour_semaine_st == '3' then
		 jour_semaine = 'Mardi'
		 
		elseif jour_semaine_st == '4' then
		 jour_semaine = 'Mercredi'
		
		elseif jour_semaine_st == '5' then
		 jour_semaine = 'Jeudi'
		 
		elseif jour_semaine_st == '6' then
		 jour_semaine = 'Vendredi'
		 
		elseif jour_semaine_st == '7' then
		 jour_semaine = 'Samedi'
		 
		end
	
		-- Mise à jour capteur texte --
		commandArray['UpdateDevice'] = texte..'|0|'..jour_semaine..' à '..heure_st
	
	else
		
		-- Mise à jour capteur texte --
		commandArray['UpdateDevice'] = texte..'|0|'..'Pas de réveil actif'
		
	end

end

-- Vérification des conditions --
if (temps >= 540 and temps <= 600) then

	-- Changement d'état --
	commandArray['Device']='On'

end

return commandArray
