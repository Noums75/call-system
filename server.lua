RegisterNetEvent('call-system:submitCall', function(description, position, coords)
    if type(description) ~= 'string' or description == '' then
        return
    end

    if type(position) ~= 'number' then
        return
    end

    if position < 0 or position % 1 ~= 0 then
        return
    end

    if type(coords) ~= 'table' then
        return
    end

    if type(coords.x) ~= 'number' or type(coords.y) ~= 'number' or type(coords.z) ~= 'number' then
        return
    end

    TriggerClientEvent('call-system:showAlert', -1, description, position, coords)
end)
