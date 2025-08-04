lib.locale()
local config = require('config')

local model = 1395331371 -- prop_haybale_03

local closestBale, balePos
local lastPickTime = 0  


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
end)

CreateThread(function()
    local model = `a_m_m_farmer_01` -- choose your model
    local coords = vector4(2588.0945, 4665.3818, 34.0768, 227.5840) -- change to your location

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'sell_fibres',
            icon = 'fa-solid fa-comments',
            label = locale('interact.target'),
            onSelect = function()
                openSellMenu()
            end
        }
    })
end)

function openSellMenu()
    local Options = {}
    Options[#Options + 1] = {
        title = locale('interact.menu.sell'),
        description = locale('interact.menu.sellDesc'),
        icon = 'leaf',
        menu = "fibre_submenu"
    }
    if config.tool.item then
        Options[#Options + 1] = {
            title = locale('interact.menu.buy'),
            description = locale('interact.menu.buyDesc')..config.sell.currency..tostring(config.tool.price),
            icon = 'hammer',
            onSelect = function()
                TriggerServerEvent('s4t4n667_fibrepicking:buyTool')
            end
        }
    end

    lib.registerContext({
        id = 'sell_menu',
        title = locale('interact.menu.title'),
        options = Options
    })

    lib.showContext('sell_menu')
end

lib.registerContext({
        id = "fibre_submenu",
        title = locale('interact.menu.sell'),
        menu = "sell_menu",
        options = {
            {
                title = locale('interact.sellMenu.sellCustom'),
                description = locale('interact.sellMenu.sellCustomDesc')..config.sell.currency..tostring(config.sell.price)..locale('interact.sellMenu.perItem'),
                icon = "dollar-sign",
                onSelect = function()
                    fibreDialog()
                end
            },
            {
                title = locale('interact.sellMenu.sellAll'),
                description = locale('interact.sellMenu.sellAllDesc'),
                icon = "sack-dollar",
                onSelect = function()
                    TriggerServerEvent('s4t4n667_fibrepicking:sellAllFibres')
                end
            }
        }
})

function fibreDialog()
    local input = lib.inputDialog("Sell Custom Amount", {
        { type = 'number', label = "Enter Amount:", name = "amount" }
    })

    if input then
        local amount = input[1]
        if config.debug then
            print('Input Value: ', tostring(amount))
        end
        if amount and amount > 0 then
            TriggerServerEvent('s4t4n667_fibrepicking:sellFibres', amount)
        else
            lib.notify({
                title = 'Invalid Amount',
                description = 'Please enter a number greater than 0.',
                type = 'error'
            })
        end
    end
end

local function checkItem(itemName, cb)
    lib.callback("s4t4n667_fibrepicking:checkItem", false, function(hasItem)
        if config.debug then
            print("Has tool (client):", hasItem)
        end
        cb(hasItem)
    end, itemName)
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
            iconColor = ''
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
                icon = 'fa-solid fa-wheat-awn',
                iconColor = '#8C2425'
            })
            return false
        end
    else
        lib.progressCircle({
            duration = config.picking.progressDuration,
            label = locale('progresslabel'),
            useWhileDead = false,
            canCancel = true,
            position = 'bottom',
            disable = { car = true, move = true },
            anim = {
                dict = "amb@prop_human_bum_bin@idle_a",
                clip = "idle_a",
            },
        })
    end

    local picked = lib.callback.await('s4t4n667_fibrepicking:PickFibre', false, config.item)
    
    ClearPedTasks(ped)

    if picked then
        lastPickTime = GetGameTimer()
    end

    return picked
end


local function fibreSpots()
    local options = {
        {
            name = 'fibrePicking',
            label = config.target.label,
            icon = config.target.icon,
            iconColor = config.target.iconColor,
            distance = config.target.distance,
            onSelect = function()
                if not config.tool.item then
                    pickFibres()
                else 
                    checkItem(config.tool.item, function(hasItem)
                        if hasItem then
                            pickFibres()
                        else
                            lib.notify({
                                title = locale('item.title'),
                                description = locale('item.description'),
                                type = "error"
                            })
                        end
                    end)
                end
            end
        },
    }
    exports.ox_target:addModel(model, options)
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