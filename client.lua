local bulletinIcon = 'nui://call-system/bipper.png'
local gpsSetKey = string.upper(GetConvar('call_system_gps_key', 'Y'))

local function showValidationError(message)
    lib.notify({
        title = 'Appel',
        description = message,
        type = 'error',
        icon = bulletinIcon
    })
end

local function openCallDialog()
    local input = lib.inputDialog('Nouvel appel', {
        {
            type = 'select',
            label = 'Type de service',
            description = 'Sélectionnez le type de service',
            required = true,
            options = {
                { value = 'police', label = "Forces de l'ordre" },
                { value = 'ems',    label = 'Service de secours' },
            }
        },
        {
            type = 'textarea',
            label = 'Description',
            description = 'Décrivez la situation',
            required = true,
            min = 5,
            max = 500
        }
    })

    if not input then
        return
    end

    local serviceType = input[1]
    local description = input[2]

    if type(description) ~= 'string' or description == '' then
        showValidationError('La description est obligatoire.')
        return
    end

    -- Récupération automatique de la position du joueur
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    -- Récupération du nom de rue
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)

    TriggerServerEvent('call-system:submitCall', serviceType, description, streetName, {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })
end

RegisterCommand('appel', openCallDialog)

local latestCall = nil
local activeBlip = nil

local function setCallRoute()
    if not latestCall then
        lib.notify({
            title = 'Appel',
            description = 'Aucun appel actif.',
            type = 'error',
            icon = bulletinIcon
        })
        return
    end

    local coords = latestCall.coords

    SetNewWaypoint(coords.x, coords.y)

    if DoesBlipExist(activeBlip) then
        RemoveBlip(activeBlip)
    end

    activeBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(activeBlip, 280)
    SetBlipColour(activeBlip, 5)
    SetBlipScale(activeBlip, 0.9)
    SetBlipRoute(activeBlip, true)
    SetBlipRouteColour(activeBlip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Appel')
    EndTextCommandSetBlipName(activeBlip)

    lib.notify({
        title = 'Appel',
        description = 'Trajet GPS défini.',
        type = 'success',
        icon = bulletinIcon
    })
end

-- Keybind uniquement, aucune commande utilisée pour définir le GPS.
lib.addKeybind({
    name = 'call-system:setroute',
    description = 'Définir le trajet GPS pour le dernier appel',
    defaultKey = gpsSetKey,
    onPressed = setCallRoute
})

RegisterNetEvent('call-system:showAlert', function(serviceType, description, streetName, coords)
    local targetCoords = vector3(coords.x, coords.y, coords.z)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - targetCoords)
    local distanceText = string.format('Distance : %d m', math.floor(distance))

    local serviceLabel = serviceType == 'police' and "~b~Forces de l'ordre~w~" or "~r~Service de secours~w~"
    local message = string.format('[%s]\n%s\n%s\nPosition : %s\nAppuyez sur %s pour GPS', serviceLabel, description, distanceText, streetName, gpsSetKey)

    latestCall = {
        serviceType = serviceType,
        description = description,
        streetName = streetName,
        coords = coords
    }

    exports.bulletin:Send({
        message = message,
        timeout = 15000,
        theme = 'warning',
        position = 'bottomleft',
        icon = bulletinIcon
    })
end)
