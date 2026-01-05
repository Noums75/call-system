local allowedServices = {
    gendarmerie = true,
    police = true,
    sdis2a = true,
    sdis2b = true,
    samu2a = true,
    samu2b = true,
    snsm = true,
}

RegisterNetEvent('call-system:submitCall', function(serviceType, identity, description, streetName, coords)
    if type(serviceType) ~= 'string' or not allowedServices[serviceType] then
        return
    end

    if type(identity) ~= 'string' or identity == '' then
        return
    end

    if type(description) ~= 'string' or description == '' then
        return
    end

    if type(streetName) ~= 'string' or streetName == '' then
        return
    end

    if type(coords) ~= 'table' then
        return
    end

    if type(coords.x) ~= 'number' or type(coords.y) ~= 'number' or type(coords.z) ~= 'number' then
        return
    end

    TriggerClientEvent('call-system:showAlert', -1, serviceType, identity, description, streetName, coords)
end)
