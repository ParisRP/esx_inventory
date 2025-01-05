fx_version 'cerulean'
game 'gta5'

author 'paris rp'
description 'Realistic ESX Legacy Inventory System with OxLib'
version '1.0.0'

-- Specify the server scripts
server_scripts {
    '@ox_lib/init.lua', -- Include OxLib initialization
    'server.lua', -- Server-side logic for inventory management
}

-- Specify the client scripts
client_scripts {
    '@ox_lib/init.lua', -- Include OxLib initialization
    'client.lua', -- Client-side logic for inventory management
}

-- Define UI files (if any)
ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/scripts.js',
    'html/img/*' -- Include any images used for the UI
}

-- Dependencies
dependencies {
    'esx_core', 
    'ox_lib' -- Include OxLib as a dependency
}

-- This will allow the resource to be loaded by ESX framework
escrow_ignore {
    'html',
    'client.lua',
    'server.lua'
}
