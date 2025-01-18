local QBCore = exports['qb-core']:GetCoreObject()
local craftingTableProp = nil  -- Variable to hold the prop reference

-- Function to check if player has the required job
function HasRequiredJob()
    local playerJob = QBCore.Functions.GetPlayerData().job.name
    return playerJob == Config.RequiredJob
end

-- Create the crafting table when the resource starts
Citizen.CreateThread(function()

    -- Setup Harvesting Areas
    for _, area in pairs(Config.HarvestAreas) do
        exports['qb-target']:AddBoxZone("harvest_" .. area.item, area.coords, 1, 1, {
            name = "harvest_" .. area.item,
            heading = 0,
            debugPoly = false,
            minZ = area.coords.z - 2,
            maxZ = area.coords.z + 1
        }, {
            options = {
                {
                    type = "client",
                    event = "slacker-vapecrafting:harvest",
                    icon = "fas fa-leaf",
                    label = "Harvest " .. area.label or area.item,  -- Use label for harvesting
                    args = { item = area.item, label = area.label or area.item },
                    job = Config.RequiredJob  -- Add job restriction
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('slacker-vapecrafting:harvest')
AddEventHandler('slacker-vapecrafting:harvest', function(data)
    if not data or not data.args or not data.args.item then  
        return
    end

    if not HasRequiredJob() then
        QBCore.Functions.Notify("You do not have permission to harvest this item.", "error")
        return
    end

    local item = data.args.item
    local label = data.args.label or item  -- Use the label for the progress bar
    local playerPed = PlayerPedId()
    exports["rpemotes"]:EmoteCommandStart('garden')

    QBCore.Functions.Progressbar("harvesting", "Harvesting " .. label .. "...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        exports["rpemotes"]:EmoteCommandStart('c')
        TriggerServerEvent('slacker-vapecrafting:giveItem', item)
    end, function() -- Cancel
		exports["rpemotes"]:EmoteCommandStart('c')
    end)
end)

-- Setup Crafting Station
Citizen.CreateThread(function()
    exports['qb-target']:AddBoxZone("crafting_station", Config.CraftingStation.coords, 1, 1, {
        name = "crafting_station",
        heading = Config.CraftingStation.coords.w,
        debugPoly = false,
        minZ = Config.CraftingStation.coords.z - 2,
        maxZ = Config.CraftingStation.coords.z + 1
    }, {
        options = {
            {
                type = "client",
                event = "slacker-vapecrafting:openCraftingMenu",
                icon = "fas fa-tools",
                label = "Open Crafting Station",
                job = Config.RequiredJob  -- Add job restriction
            }
        },
        distance = 2.0
    })
end)

RegisterNetEvent('slacker-vapecrafting:openCraftingMenu')
AddEventHandler('slacker-vapecrafting:openCraftingMenu', function()
    if not HasRequiredJob() then
        QBCore.Functions.Notify("You do not have permission to use the crafting station.", "error")
        return
    end

    local craftingOptions = {}

    for _, menuItem in pairs(Config.CraftingStation.menuItems) do
        local recipeDescription = "Requires:\n"  -- Description for recipe requirements

        for _, ingredient in pairs(menuItem.recipe) do
            recipeDescription = recipeDescription .. ingredient.amount .. "x " .. ingredient.item .. "\n"
        end

        recipeDescription = recipeDescription .. "\nReceives: " .. (menuItem.label or menuItem.item)  -- Use label for the crafted item

        table.insert(craftingOptions, {
            header = menuItem.label,
            txt = recipeDescription,
            params = {
                event = "slacker-vapecrafting:craftItem",
                args = {
                    item = menuItem.item,
                    label = menuItem.label or menuItem.item,  -- Pass label to the args
                    recipe = menuItem.recipe
                }
            }
        })
    end

    exports['qb-menu']:openMenu(craftingOptions)
end)

RegisterNetEvent('slacker-vapecrafting:craftItem')
AddEventHandler('slacker-vapecrafting:craftItem', function(data)
    local playerPed = PlayerPedId()

    if not HasRequiredJob() then
        QBCore.Functions.Notify("You do not have permission to craft this item.", "error")
        return
    end

    QBCore.Functions.TriggerCallback('slacker-vapecrafting:canCraftItem', function(canCraft)
        if canCraft then
            -- Start crafting animation
            exports["rpemotes"]:EmoteCommandStart('mechanic')

            QBCore.Functions.Progressbar("crafting", "Crafting " .. data.label .. "...", 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                exports["rpemotes"]:EmoteCommandStart('c')  -- Clear the crafting animation
                TriggerServerEvent('slacker-vapecrafting:giveCraftedItem', data.item, data.recipe)
                TriggerEvent('slacker-vapecrafting:openCraftingMenu')
                -- Show item box for crafted item
                TriggerEvent('qb-inventory:client:ItemBox', QBCore.Shared.Items[data.item], "add")
            end, function() -- Cancel
                exports["rpemotes"]:EmoteCommandStart('c')
            end)
        else
            QBCore.Functions.Notify("You don't have the required items.", "error")
        end
    end, data.recipe)
end)

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
   
end)