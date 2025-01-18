local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('slacker-vapecrafting:giveItem')
AddEventHandler('slacker-vapecrafting:giveItem', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, 4)
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
end)

QBCore.Functions.CreateCallback('slacker-vapecrafting:canCraftItem', function(source, cb, recipe)
    local Player = QBCore.Functions.GetPlayer(source)
    local canCraft = true

    for _, ingredient in pairs(recipe) do
        local item = Player.Functions.GetItemByName(ingredient.item)
        if not item or item.amount < ingredient.amount then
            canCraft = false
            break
        end
    end

    cb(canCraft)
end)

RegisterNetEvent('slacker-vapecrafting:giveCraftedItem')
AddEventHandler('slacker-vapecrafting:giveCraftedItem', function(item, recipe)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    for _, ingredient in pairs(recipe) do
        Player.Functions.RemoveItem(ingredient.item, ingredient.amount)
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[ingredient.item], "remove")
    end

    Player.Functions.AddItem(item, 4)
    TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
end)