RegisterNetEvent('call-system:submitCall', function(serviceType, description, streetName, coords)
    if type(serviceType) ~= 'string' or (serviceType ~= 'police' and serviceType ~= 'ems') then
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

    if type(coords.x) ~= 'number' or type(coords.y) ~= 'number' or type(coords. z) ~= 'number' then
        return
    end

    TriggerClientEvent('call-system:showAlert', -1, serviceType, description, streetName, coords)
end)