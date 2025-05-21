fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'Codex'
description 'Looter shooter gear and stat system integrated with TGIANN inventory'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}
