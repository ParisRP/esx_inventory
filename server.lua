ESX = nil
local weightLimit = 50.0  -- Default weight limit for inventory (can be customized)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Callback to get the player's inventory
ESX.RegisterServerCallback('esx_inventory:getInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = {}

    for i=1, #xPlayer.inventory, 1 do
        table.insert(inventory, {
            item = xPlayer.inventory[i].name,
            count = xPlayer.inventory[i].count,
            weight = xPlayer.inventory[i].weight
        })
    end

    cb(inventory)
end)

-- Callback to get the total weight of the inventory
ESX.RegisterServerCallback('esx_inventory:getTotalInventoryWeight', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local totalWeight = 0.0

    for i=1, #xPlayer.inventory, 1 do
        local itemWeight = xPlayer.inventory[i].weight * xPlayer.inventory[i].count
        totalWeight = totalWeight + itemWeight
    end

    cb(totalWeight)
end)

-- Callback to get the player's weight limit (can be customized)
ESX.RegisterServerCallback('esx_inventory:getPlayerWeightLimit', function(source, cb)
    -- This can be customized to return a different limit per player (e.g., based on their job, rank, etc.)
    cb(weightLimit)
end)

-- Event to add an item to the inventory
RegisterServerEvent('esx_inventory:addItem')
AddEventHandler('esx_inventory:addItem', function(item, count, weight)
    local xPlayer = ESX.GetPlayerFromId(source)

    if item and count and weight then
        local existingItem = xPlayer.getInventoryItem(item)

        if existingItem then
            -- Add the item to the player's inventory
            xPlayer.addInventoryItem(item, count)

            -- Notify the player
            TriggerClientEvent('esx_inventory:notify', source, "You have added " .. count .. " " .. item .. "(s).")
        else
            TriggerClientEvent('esx_inventory:notify', source, "Error: Item not found.")
        end
    else
        TriggerClientEvent('esx_inventory:notify', source, "Error: Invalid parameters.")
    end
end)

-- Event to remove an item from the inventory
RegisterServerEvent('esx_inventory:removeItem')
AddEventHandler('esx_inventory:removeItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)

    if item and count then
        local existingItem = xPlayer.getInventoryItem(item)

        if existingItem and existingItem.count >= count then
            -- Remove the item from the player's inventory
            xPlayer.removeInventoryItem(item, count)

            -- Notify the player
            TriggerClientEvent('esx_inventory:notify', source, "You have removed " .. count .. " " .. item .. "(s).")
        else
            TriggerClientEvent('esx_inventory:notify', source, "Error: Insufficient items or invalid item.")
        end
    else
        TriggerClientEvent('esx_inventory:notify', source, "Error: Invalid parameters.")
    end
end)

-- Event to sell an item
RegisterServerEvent('esx_inventory:sellItem')
AddEventHandler('esx_inventory:sellItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemPrice = getItemPrice(item)

    if item and count then
        local existingItem = xPlayer.getInventoryItem(item)

        if existingItem and existingItem.count >= count then
            -- Remove the item and give money
            xPlayer.removeInventoryItem(item, count)
            xPlayer.addMoney(itemPrice * count)

            -- Notify the player
            TriggerClientEvent('esx_inventory:notify', source, "You sold " .. count .. " " .. item .. "(s) for $" .. (itemPrice * count) .. ".")
        else
            TriggerClientEvent('esx_inventory:notify', source, "Error: Insufficient items.")
        end
    else
        TriggerClientEvent('esx_inventory:notify', source, "Error: Invalid parameters.")
    end
end)

-- Event to buy an item
RegisterServerEvent('esx_inventory:buyItem')
AddEventHandler('esx_inventory:buyItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemPrice = getItemPrice(item)

    if item and count then
        local totalCost = itemPrice * count

        if xPlayer.getMoney() >= totalCost then
            -- Deduct money and add the item
            xPlayer.removeMoney(totalCost)
            xPlayer.addInventoryItem(item, count)

            -- Notify the player
            TriggerClientEvent('esx_inventory:notify', source, "You bought " .. count .. " " .. item .. "(s) for $" .. totalCost .. ".")
        else
            TriggerClientEvent('esx_inventory:notify', source, "Error: Not enough money.")
        end
    else
        TriggerClientEvent('esx_inventory:notify', source, "Error: Invalid parameters.")
    end
end)

-- Function to get the price of an item (can be customized)
function getItemPrice(item)
    local prices = {
        apple = 5,
        bread = 10,
        water = 2,
        -- Add more items and their prices here
    }

    return prices[item] or 0  -- Return 0 if the item is not in the prices table
end
