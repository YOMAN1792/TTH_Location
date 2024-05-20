fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'YOMAN1792'
description 'Location system done with OX_LIB for Esx'
version '1.0'


client_script "client/client.lua"
server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}


shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'locales/*.lua',
}


dependencie 'es_extended'


escrow_ignore {
    'config.lua',
    'locales/*.lua',
}