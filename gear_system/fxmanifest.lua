fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Standalone Gear and Stat System'

shared_script 'config.lua'

server_script 'server.lua'
client_script 'client.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/main.js'
}

ui_page 'html/index.html'
