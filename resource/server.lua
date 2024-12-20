lib.locale()
local config = lib.require('config')

local model = 1395331371 -- prop_haybale_03

lib.callback.register('s4t4n667_fibrepicking:PickFibre', function(source)
    local nearBale = false
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)

    local bale = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, model, false, false, false) -- 5.0 is the search radius

    if bale ~= 0 then 
        local objectCoords = GetEntityCoords(object) 
        local dist = #(objectCoords - coords)  

        if dist < config.target.distance then 
            nearBale = true
        end
    end

    if not nearBale then
        return false
    end

    local item = config.item
    local count = config.amountPicked

    if exports.ox_inventory:CanCarryItem(source, item, count) then
        exports.ox_inventory:AddItem(source, item, count)
        return true
    else
        lib.notify(source,{
            title = locale('carry.title'),
            description = locale('carry.description'),
            icon = 'fa-solid fa-wheat-awn',
            iconColor = '#8C2425',
        })
        return false
    end
end)

