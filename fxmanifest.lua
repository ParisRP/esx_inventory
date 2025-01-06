fx_version 'cerulean'
game 'gta5'

author 'ParisRP'
description 'Inventory System with ox_lib for ESX Legacy'
version '1.2.0'

--- ## Dépendances ##
dependencies {
    'es_extended', -- ESX Framework
    'ox_lib'       -- Utility Library
}

--- ## Scripts Serveur ##
server_scripts {
    '@es_extended/locale.lua',    -- Langues de ESX
    '@ox_lib/init.lua',           -- Initialisation de ox_lib
    'server/server.lua'           -- Script serveur
}

--- ## Scripts Client ##
client_scripts {
    '@es_extended/locale.lua',    -- Langues de ESX
    '@ox_lib/init.lua',           -- Initialisation de ox_lib
    'client/client.lua'           -- Script client
}

--- ## Fichiers de Langue ##
files {
    'locales/en.lua' -- Langues (exemple pour les fichiers multi-langues)
}

--- ## Configuration Partagée ##
shared_script {
    '@ox_lib/init.lua', -- Initialisation de ox_lib pour les scripts partagés
    'config.lua'        -- Configuration partagée pour client et serveur
}

--- ## UI et Assets ##
ui_page 'html/index.html' -- Si une interface utilisateur HTML est incluse

files {
    'html/index.html',          -- Fichier principal de l'UI
    'html/css/style.css',       -- Style CSS
    'html/js/script.js',        -- JavaScript pour l'UI
    --'html/img/*.png',           -- Images utilisées dans l'UI
    --'html/fonts/*.ttf'          -- Polices pour l'interface utilisateur
}

lua54 'yes' -- Activer le mode Lua 5.4 (si applicable)
