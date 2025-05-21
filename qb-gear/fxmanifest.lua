fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name 'qb-gear'
description 'Looter shooter gear and stat system'
version '0.1.0'

dependency 'qb-core'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}
