---------------------------------------------------------------------------
-- script_time_pollution.lua ----------------------------------------------
-- DumpDos ----------------------------------------------------------------
---------------------------------------------------------------------------
-- Ce script est dédié à la récupération des données fournies par le ------
-- site Air Rhône-Alpes ---------------------------------------------------
---------------------------------------------------------------------------
-- Attention ce script fonctionne uniquement en région Rhône-Alpes !-------
---------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------
-------------------------------------------- Informations ---------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- Site 		: http://www.air-rhonealpes.fr
-- Script inspiré de 	: https://easydomoticz.com/forum/viewtopic.php?f=17&t=2006

-------------------------------------------------------------------------------------------------------------
----------------------------------------- Variables à Editer ------------------------------------------------
-------------------------------------------------------------------------------------------------------------

local send_notification	= 3		-- Niveau de déclenchement des notifications
local pollution_disp	= "392"		-- Idx de l'afficheur virtuel
local code_ville 	= "38185"	-- Code Insee de la commaune
local Print_logs	= true		-- Affichage des données dans les logs


-------------------------------------------------------------------------------------------------------------
---------------------------------------- Variables de Travail -----------------------------------------------
-------------------------------------------------------------------------------------------------------------

local fichier			= "pollution_airRA.xml"
local code_insee		= tostring(code_ville)

--------------------------------------------------------------------------------------------------------------
---------------------------------------------- Fonctions -----------------------------------------------------
--------------------------------------------------------------------------------------------------------------

-- Fonction debugging --
function logs (x, Print_logs)
	 if (Print_logs) then
     print (x)
	 end 
end

--------------------------------------------------------------------------------------------------------------
------------------------------------------------ Fin ---------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
commandArray = {}

-- Récupération de l'heure --
time = os.date("*t")

-- Vérification des conditions --
if (time.min == 00 and ((time.hour == 7) or (time.hour == 13) or (time.hour == 18))) then -- 3 éxecutions du script par jour à 7H20, 13h20 et 18H20
-- if (time.hour == 7 and time.min == 00) then -- éxécution du script tous les matins à 07h00
-- if time.min % 1 == 0 then -- éxécution du script toutes les 30 minutes


-- Affichage d'éxécution --
print('script_time_pollution.lua')

	 -- Récupération des données --
     os.execute("wget -q -O "..fichier.." http://www.air-rhonealpes.fr/monair/commune/"..code_insee.."")
     local f = io.open(fichier, "r")

	 -- Lecture des données --
     local dataHtml = f:read("*all")
     f:close()

	 -- Décodage des données --
	 for instance in dataHtml:gmatch("<body class=.->(.-)</body>") do
	 local indice = instance:match('<div class="indice">(.-)</div>')
	 
	 logs ("Niveau de pollution = "..indice.."/100", Print_logs)
	 
	-- Initialisation des variables --
	 local niveau = tonumber(indice)
	
    -- Vérification des conditions niveau 1 --  
    if niveau <= 25 then 
	
        -- Mise à jour capteur virtuel --
	if pollution_disp ~= nil then
         commandArray['UpdateDevice'] = pollution_disp..'|1|Niveau de pollution faible'
        end
        
	-- Envoi notification --
	if send_notification > 0 and send_notification < 2 then
         commandArray['SendNotification'] = 'Pollution#Niveau de pollution faible'
        end
	-- Affichage des données dans logs --
        logs(" Niveau de pollution faible ", Print_logs)

    -- Vérification des conditions niveau 2 --
    elseif niveau <= 50 and niveau > 25   then 
	
	-- Mise à jour capteur virtuel --
        if pollution_disp ~= nil then
         commandArray['UpdateDevice'] = pollution_disp..'|2|Niveau de pollution moyen'
        end
		
	-- Envoi notification --
        if send_notification > 0 and send_notification < 3 then
         commandArray['SendNotification'] = 'Pollution#Niveau de pollution moyen'
        end
		
	-- Affichage des données dans logs --
        logs("Niveau de pollution moyen", Print_logs)   

    -- Vérification des conditions niveau 3 --
    elseif niveau <= 75 and niveau > 50   then
	
	-- Mise à jour capteur virtuel --
        if pollution_disp ~= nil then
         commandArray['UpdateDevice'] = pollution_disp..'|3|Niveau de pollution élevé'
        end
		
	-- Envoi notification --
        if send_notification > 0 and send_notification < 4 then
         commandArray['SendNotification'] = 'Pollution#Niveau de pollution élevé'
        end
		
	-- Affichage des données dans logs --
        logs("Niveau de pollution élevé", Print_logs)     

    -- Vérification des conditions niveau 4 --
    elseif niveau <= 100 and niveau > 75   then
	
	-- Mise à jour capteur virtuel --
        if pollution_disp ~= nil then
         commandArray['UpdateDevice'] = pollution_disp..'|4|Niveau de pollution très élevé'
        end
		
	-- Envoi notification --
        if send_notification > 0 and send_notification < 5 then
         commandArray['SendNotification'] = 'Pollution#Niveau de pollution très élevé'
        end
		
		-- Affichage des données dans logs --
        logs("Niveau de pollution très élevé", Print_logs)
		
    -- Verification des conditions niveau non défini --
    else
	 print("niveau non defini")
    end      

end 
end
return commandArray
