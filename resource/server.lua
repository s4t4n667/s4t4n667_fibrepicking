lib.locale()
local config = lib.require('config')
lib.versionCheck('s4t4n667/s4t4n667_fibrepicking')

lib.callback.register('s4t4n667_fibrepicking:checkItem', function(source, itemName)
    local hasItem = exports.ox_inventory:Search(source, 'count', itemName) > 0
    if config.debug then
        print(('Checking if player %s has item %s: %s'):format(source, itemName, tostring(hasItem)))
    end
    return hasItem
end)

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

RegisterNetEvent('s4t4n667_fibrepicking:sellAllFibres', function()
    local src = source
    local itemName = config.item
    local item = exports.ox_inventory:GetItem(src, itemName)

    if item and item.count > 0 then
        local count = item.count
        local pricePerItem = config.sell.price
        local totalPrice = count * pricePerItem

        exports.ox_inventory:RemoveItem(src, itemName, count)
        exports.ox_inventory:AddItem(src, config.sell.moneyItem, totalPrice)

        TriggerClientEvent('ox_lib:notify', src, {
            title = locale('interact.sellMenu.saleSuccess'),
            description = locale('interact.sellMenu.youSold')..count..locale('interact.sellMenu.fibresFor')..config.sell.currency..totalPrice,
            type = "success"
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = locale('interact.sellMenu.noFibres'),
            description = locale('interact.sellMenu.noFibresDesc'),
            type = "error"
        })
    end
end)

RegisterNetEvent('s4t4n667_fibrepicking:sellFibres', function(amount)
    local src = source
    local itemName = config.item
    local item = exports.ox_inventory:GetItem(src, itemName)

    if item and item.count >= amount and amount > 0 then
        local pricePerItem = config.sell.price
        local totalPrice = amount * pricePerItem

        exports.ox_inventory:RemoveItem(src, itemName, amount)
        exports.ox_inventory:AddItem(src, config.sell.moneyItem, totalPrice)

        TriggerClientEvent('ox_lib:notify', src, {
            title = locale('interact.sellMenu.saleSuccess'),
            description = locale('interact.sellMenu.youSold')..amount..locale('interact.sellMenu.fibresFor')..config.sell.currency..totalPrice,
            type = "success"
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = locale('interact.sellMenu.noFibres'),
            description = locale('interact.sellMenu.noFibresDesc'),
            type = "error"
        })
    end
end)

RegisterNetEvent('s4t4n667_fibrepicking:buyTool', function(toolName)
    local src = source
    local currencyItem = config.sell.moneyItem

    local toolConfig
    for _, v in ipairs(config.tool) do
        if v.item == toolName then
            toolConfig = v
            break
        end
    end

    if not toolConfig then
        print(('[WARN] Player %s tried to buy invalid tool: %s'):format(src, toolName))
        return
    end

    local price = toolConfig.price
    local toolItem = toolConfig.item

    local playerMoney = exports.ox_inventory:GetItem(src, currencyItem)?.count or 0

    if playerMoney >= price then
        exports.ox_inventory:RemoveItem(src, currencyItem, price)
        exports.ox_inventory:AddItem(src, toolItem, 1)

        TriggerClientEvent('ox_lib:notify', src, {
            title = string.format(locale("interact.menu.purchased"), toolItem),
            description = locale("interact.menu.purchasedDesc")..config.sell.currency..price,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = locale("interact.menu.insufficientFunds"),
            description = locale("interact.menu.insufficientFundsDesc"),
            type = 'error'
        })
    end
end)