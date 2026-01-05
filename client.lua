local bulletinIcon = 'nui://call-system/bipper.png'
local gpsSetKey = string.upper(GetConvar('call_system_gps_key', 'Y'))

local serviceLabels = {
    gendarmerie = "~b~Gendarmerie~w~",
    police      = "~b~Police nationale~w~",
    sdis2a      = "~r~SDIS 2A~w~",
    sdis2b      = "~r~SDIS 2B~w~",
    samu2a      = "~r~SAMU 2A~w~",
    samu2b      = "~r~SAMU 2B~w~",
    snsm        = "~o~SNSM~w~",
}

local allowedServices = {
    gendarmerie = true,
    police = true,
    sdis2a = true,
    sdis2b = true,
    samu2a = true,
    samu2b = true,
    snsm = true,
}

local latestCall = nil
local activeBlip = nil

local function showNotification(message)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentString(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function openCallDialog()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
end

RegisterCommand('appel', openCallDialog)

local function setCallRoute()
    if not latestCall then
        showNotification('Aucun appel actif.')
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

    showNotification('Trajet GPS défini.')
end

RegisterCommand('call-system:setroute', function()
    setCallRoute()
end, false)

RegisterKeyMapping('call-system:setroute', 'Définir le trajet GPS pour le dernier appel', 'keyboard', gpsSetKey)

RegisterNUICallback('submitCall', function(data, cb)
    local serviceType = tostring(data.serviceType or '')
    local identity = tostring(data.identity or '')
    local description = tostring(data.description or '')

    if serviceType == '' or not allowedServices[serviceType] then
        cb({ ok = false, message = 'Motif invalide.' })
        return
    end

    if identity == '' then
        cb({ ok = false, message = 'Votre identité est requise.' })
        return
    end

    if description == '' then
        cb({ ok = false, message = 'La description est obligatoire.' })
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetHash)

    TriggerServerEvent('call-system:submitCall', serviceType, identity, description, streetName, {
        x = coords.x,
        y = coords.y,
        z = coords.z
    })

    cb({ ok = true })
    showNotification('Appel envoyé.')
    SetNuiFocus(false, false)
end)

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNetEvent('call-system:showAlert', function(serviceType, identity, description, streetName, coords)
    local targetCoords = vector3(coords.x, coords.y, coords.z)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - targetCoords)
    local distanceText = string.format('Distance : %d m', math.floor(distance))

    local serviceLabel = serviceLabels[serviceType] or "~b~Service~w~"
    local message = string.format('[%s]\n%s\nIdentité : %s\n%s\nPosition : %s\nAppuyez sur %s pour GPS', serviceLabel, description, identity, distanceText, streetName, gpsSetKey)

    latestCall = {
        serviceType = serviceType,
        identity = identity,
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
