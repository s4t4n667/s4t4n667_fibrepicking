lib.locale()
local config = lib.require('config')
lib.versionCheck('s4t4n667/s4t4n667_fibrepicking')

lib.callback.register('s4t4n667_fibrepicking:PickFibre', function(source)
    local item = config.item
    local count = math.random(config.picking.minAmount, config.picking.maxAmount)

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

local function GetShopItem(itemName)
    for _, item in pairs(config.shop.items) do
        if item.item == itemName then
            return item
        end
    end
    return nil
end

RegisterNetEvent("s4t4n667_fibrepicking:buyItem", function(item)
    local src = source

    local data = GetShopItem(item)
    if not data then
        print(("[s4t4n667_fibrepicking] %s invalid item: %s"):format(src, item))
        return
    end

    local money = exports.ox_inventory:Search(src, 'count', 'money')

    if money >= data.price then

        if exports.ox_inventory:CanCarryItem(src, item, 1) then
            exports.ox_inventory:RemoveItem(src, 'money', data.price)
            exports.ox_inventory:AddItem(src, item, 1)

            TriggerClientEvent('ox_lib:notify', src, {title = locale('shop.notify_title'), description = locale('shop.notify_success'), type = "success", position = config.notifications.position})
        else
            TriggerClientEvent('ox_lib:notify', src, {title = locale('shop.notify_title'), description = locale('shop.notify_carry'), type = "error", position = config.notifications.position})
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('shop.notify_title'), description = locale('shop.notify_money'), type = "error", position = config.notifications.position})
    end
end)

RegisterNetEvent("s4t4n667_fibrepicking:sellItem", function(item)
    local src = source

    local data = GetShopItem(item)
    if not data then
        print(("[s4t4n667_fibrepicking] %s invalid item: %s"):format(src, item))
        return
    end

    local count = exports.ox_inventory:Search(src, 'count', item)
    local amount = data.price*count

    if count >= 1 then
        exports.ox_inventory:RemoveItem(src, item, count)
        exports.ox_inventory:AddItem(src, 'money', amount)

        TriggerClientEvent('ox_lib:notify', src, {title = locale('shop.notify_title'),  description = locale('shop.notify_sell_success'), type = "success",  position = config.notifications.position})
    else
        TriggerClientEvent('ox_lib:notify', src, {title = locale('shop.notify_title'), description = locale('shop.notify_no_item'), type = "error",  position = config.notifications.position})
    end
end)