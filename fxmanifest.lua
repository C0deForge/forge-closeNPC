fx_version 'cerulean'

game 'gta5'

description 'Forge NPC Car Lock Script'

author 'CodeForge'

lua54 'yes'
version '1.0.0'

shared_scripts {
    'config/config.lua' 
}

server_scripts {
    'server/server.lua' 
}

client_scripts {
    'client/client.lua' 
}

dependencies {
    'lockpick' -- For lockpick minigame
}

dependency '/assetpacks'
