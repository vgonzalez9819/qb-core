fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Codex'
description 'Gear and Stat System'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
