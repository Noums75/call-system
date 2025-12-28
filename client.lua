local function showValidationError(message)
    lib.notify({
        title = 'Appel',
        description = message,
        type = 'error'
    })
end

local function openCallDialog()
    local input = lib.inputDialog('Nouvel appel', {
        {
            type = 'input',
            label = 'Description',
            required = true
        },
        {
            type = 'number',
            label = 'Position',
            description = 'Uniquement des chiffres',
            required = true
        }
    })

    if not input then
        return
    end

    local description = input[1]
    local position = input[2]

    if type(description) ~= 'string' or description == '' then
        showValidationError('La description est obligatoire.')
        return
    end

    if type(position) ~= 'number' then
        showValidationError('La position doit contenir uniquement des chiffres.')
        return
    end

    if position < 0 or position % 1 ~= 0 then
        showValidationError('La position doit contenir uniquement des chiffres.')
        return
    end

    local coords = GetEntityCoords(PlayerPedId())

    TriggerServerEvent('call-system:submitCall', description, position, {
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
            type = 'error'
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
        type = 'success'
    })
end

RegisterCommand('call-system:setroute', setCallRoute, false)
RegisterKeyMapping('call-system:setroute', 'Définir le trajet GPS pour le dernier appel', 'keyboard', 'Y')

RegisterNetEvent('call-system:showAlert', function(description, position, coords)
    local targetCoords = vector3(coords.x, coords.y, coords.z)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - targetCoords)
    local distanceText = string.format('Distance : %d m', math.floor(distance))
    local message = string.format('%s\n%s\nPosition : %s\nAppuyez sur Y pour GPS', description, distanceText, position)

    latestCall = {
        description = description,
        position = position,
        coords = coords
    }

    exports.bulletin:Send({
        message = message,
        timeout = 6000,
        theme = 'info',
        position = 'bottomleft'
    })
end)
