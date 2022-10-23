fx_version 'adamant'

game 'gta5'

dependency 'es_extended'

shared_scripts {
    'config.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    --dependance rageui--
    "locales/en.lua",
    "locales/fr.lua",
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
    'client/client.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
    "locales/en.lua",
    "locales/fr.lua",
    'server/server.lua'
}

