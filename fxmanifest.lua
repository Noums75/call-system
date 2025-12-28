fx_version 'cerulean'
game 'gta5'

lua54 'yes'

client_script 'client.lua'
server_script 'server.lua'

shared_script '@ox_lib/init.lua'

files {
    'bipper.png'
}

dependencies {
    'ox_lib',
    'bulletin'
}