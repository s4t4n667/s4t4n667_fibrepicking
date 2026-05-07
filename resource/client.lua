lib.locale()
local config = require('config')

local model = 1395331371 -- prop_haybale_03
local closestBale, balePos
local lastPickTime = 0  
local fibreId = 0

CreateThread(function()
    if config.blip.enabled then
        local fibresBlip = AddBlipForCoord(config.blip.coords.x, config.blip.coords.y, config.blip.coords.z)
        SetBlipSprite(fibresBlip, config.blip.sprite)
        SetBlipColour(fibresBlip, config.blip.spriteColor)
        SetBlipScale(fibresBlip, config.blip.scale)
        SetBlipAsShortRange(fibresBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(config.blip.label)
        EndTextCommandSetBlipName(fibresBlip)
    end

    if config.shop.blip.enabled then
        local shopBlip = AddBlipForCoord(config.shop.coords.x, config.shop.coords.y, config.shop.coords.z)
        SetBlipSprite(shopBlip, config.shop.blip.sprite)
        SetBlipColour(shopBlip, config.shop.blip.spriteColor)
        SetBlipScale(shopBlip, config.shop.blip.scale)
        SetBlipAsShortRange(shopBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(config.shop.blip.label)
        EndTextCommandSetBlipName(shopBlip)
    end        
end)

local function itemCheck()
    local item = config.gatherItem
    local count = exports.ox_inventory:Search('count', item)

    if count and count > 0 then 
        return true
    else
        lib.notify({
            title = locale('item.title'),
            description = locale('item.description'),
            icon = config.notifications.icon,
            iconColor = config.notifications.failColor
        })
        return false
    end
end

local function pickFibres()
    local ped = PlayerPedId()
    local playerPos = GetEntityCoords(ped)

    local currentTime = GetGameTimer()
    if currentTime - lastPickTime < config.cooldown then
        lib.notify({
            id = 'cooldownActive',
            title = locale('cooldown.title'),
            description = locale('cooldown.description'),
            showDuration = true,
            position = 'top-right',
            icon = 'fa-solid fa-hourglass-half',
        })
        return false
    end

    local bale = GetClosestObjectOfType(
        playerPos.x, playerPos.y, playerPos.z,
        config.target.distance, model,
        false, false, false
    )

    if not DoesEntityExist(bale) then return false end

    if bale ~= closestBale then
        closestBale = bale
        balePos = GetEntityCoords(bale)
    end

    if #(playerPos - balePos) > config.target.distance then
        return false
    end

    if config.requireGatherItem then
        if not itemCheck() then
            return false
        end
    end

    ExecuteCommand(config.picking.animation)
    Wait(100)

    if config.picking.useSkillcheck then
        local success = lib.skillCheck(config.picking.skillCheck, config.picking.skillCheckKeys)

        if not success then
            ClearPedTasks(ped)
            lib.notify({
                id = 'fibreFail',
                title = locale('fail.title'),
                description = locale('fail.description'),
                showDuration = true,
                position = 'top-right',
                icon = config.notifications.icon,
                iconColor = config.notifications.failColor
            })
            return false
        end
    else
        local success = lib.progressCircle({
            duration = config.picking.progressDuration,
            label = locale('progress.label'),
            useWhileDead = false,
            canCancel = config.picking.progressCanCancel,
            position = 'bottom',
            disable = { car = true, move = true },
            anim = {
                dict = "amb@prop_human_bum_bin@idle_a",
                clip = "idle_a",
            },
        })

        if not success then
            ClearPedTasks(ped)
            lib.notify({
                title = locale('progress.cancelTitle'),
                description = locale('progress.cancelDesc'),
                icon = config.notifications.icon,
                iconColor = config.notifications.failColor
            })
            return false
        end
    end

    local picked = lib.callback.await('s4t4n667_fibrepicking:PickFibre', false, config.item)

    ClearPedTasks(ped)

    if picked then
        lastPickTime = GetGameTimer()
    end

    return picked
end

local function fibreSpots()
    fibreId = fibreId + 1

    exports.ox_target:removeModel(model, targetName)
    
    local options = {
        {
            name = ('fibrePicking_%d'):format(fibreId),
            label = config.target.label,
            icon = config.target.icon,
            iconColor = config.target.iconColor,
            distance = config.target.distance,
            onSelect = function()
                pickFibres()
            end,
        },
    }
    exports.ox_target:addModel(model, options)
end

CreateThread(function()
    local pedModel = config.shop.pedModel
    local coords = config.shop.coords

    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end

    local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z -1, coords.w, false, true)

    if not DoesEntityExist(ped) then
        return
    end

    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'fibrepicking-shop',
            icon = 'fa-solid fa-basket-shopping',
            label = 'Browse Shop',
            onSelect = function()
                OpenShop()
            end
        }
    })
end)

function OpenSellMenu()
    local options = {}

    for _, v in pairs(config.shop.items) do
        if v.type == "sell" then
            options[#options + 1] = {
                title = v.label .. " - $" .. v.price,
                icon = v.icon,
                iconColor = v.iconColor,
                onSelect = function()
                    TriggerServerEvent("s4t4n667_fibrepicking:sellItem", v.item, v.price)
                end
            }
        end
    end

    lib.registerContext({
        id = 'fibrepicking_shop_sell',
        title = "Sell Items",
        menu = 'fibrepicking_shop_main',
        options = options
    })

    lib.showContext('fibrepicking_shop_sell')
end

function OpenBuyMenu()
    local options = {}

    for _, v in pairs(config.shop.items) do
        if v.type == "buy" then
            options[#options + 1] = {
                title = v.label .. " - $" .. v.price,
                icon = v.icon,
                iconColor = v.iconColor,
                onSelect = function()
                    TriggerServerEvent("s4t4n667_fibrepicking:buyItem", v.item, v.price)
                end
            }
        end
    end

    lib.registerContext({
        id = 'fibrepicking_shop_buy',
        title = "Buy Items",
        menu = 'fibrepicking_shop_main',
        options = options
    })

    lib.showContext('fibrepicking_shop_buy')
end

function OpenShop()
    lib.registerContext({
        id = 'fibrepicking_shop_main',
        title = locale('shop.title'),
        options = {
            {
                title = "Buy Items",
                icon = "fa-cart-shopping",
                onSelect = function()
                    OpenBuyMenu()
                end
            },
            {
                title = "Sell Items",
                icon = "fa-hand-holding-dollar",
                onSelect = function()
                    OpenSellMenu()
                end
            }
        }
    })

    lib.showContext('fibrepicking_shop_main')
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    fibreSpots()
end)

RegisterNetEvent('esx:playerLoaded', function()
    fibreSpots()
end)

AddEventHandler('onResourceStart', function(resource)
    fibreSpots()
end)
