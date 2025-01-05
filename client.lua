ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Function to display items in the inventory
function showInventory()
    ESX.TriggerServerCallback('esx_inventory:getInventory', function(inventory)
        local inventoryList = ''
        for i=1, #inventory, 1 do
            inventoryList = inventoryList .. inventory[i].item .. " - " .. inventory[i].count .. " (Weight: " .. inventory[i].weight .. ")\n"
        end

        if inventoryList == '' then
            ESX.ShowNotification("Your inventory is empty.")
        else
            ESX.ShowNotification("Inventory:\n" .. inventoryList)
        end
    end)
end

-- Command to show the inventory
RegisterCommand('showInventory', function()
    showInventory()
end, false)

-- Function to add an item to the inventory
function addItemToInventory(item, count, weight)
    if item and count and weight then
        TriggerServerEvent('esx_inventory:addItem', item, count, weight)
    else
        ESX.ShowNotification("Error: Invalid parameters.")
    end
end

-- Command to add an item
RegisterCommand('addItem', function(source, args, rawCommand)
    local item = args[1]
    local count = tonumber(args[2])
    local weight = tonumber(args[3])

    if item and count and weight then
        addItemToInventory(item, count, weight)
    else
        ESX.ShowNotification("Error: Invalid parameters.")
    end
end, false)

-- Function to remove an item from the inventory
function removeItemFromInventory(item, count)
    if item and count then
        TriggerServerEvent('esx_inventory:removeItem', item, count)
    else
        ESX.ShowNotification("Error: Invalid parameters.")
    end
end

-- Command to remove an item
RegisterCommand('removeItem', function(source, args, rawCommand)
    local item = args[1]
    local count = tonumber(args[2])

    if item and count then
        removeItemFromInventory(item, count)
    else
        ESX.ShowNotification("Error: Invalid parameters.")
    end
end, false)

-- Notification to inform the player
RegisterNetEvent('esx_inventory:notify')
AddEventHandler('esx_inventory:notify', function(message)
    ESX.ShowNotification(message)
end)

-- Function to manage adding items via an interactive menu
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Example of adding an item via a key press event
        if IsControlJustPressed(0, 38) then  -- E key (by default) for interaction
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)

            -- Simulate adding an item (here an apple with weight 0.5 and quantity 1)
            addItemToInventory("apple", 1, 0.5)
        end
    end
end)

-- Function to update inventory weight
RegisterNetEvent('esx_inventory:updateWeight')
AddEventHandler('esx_inventory:updateWeight', function(newWeight)
    ESX.ShowNotification("Current inventory weight: " .. newWeight .. " / " .. weightLimit .. " kg")
end)

-- Check the inventory weight and display
function checkInventoryWeight()
    ESX.TriggerServerCallback('esx_inventory:getTotalInventoryWeight', function(currentWeight)
        getPlayerWeightLimit(function(weightLimit)
            if currentWeight > weightLimit then
                ESX.ShowNotification("Warning! You have exceeded the weight limit!")
            else
                ESX.ShowNotification("Current inventory weight: " .. currentWeight .. " kg / " .. weightLimit .. " kg")
            end
        end)
    end)
end

-- Show the total weight of the inventory with a command
RegisterCommand('checkWeight', function()
    checkInventoryWeight()
end, false)

-- Get the player's weight limit
function getPlayerWeightLimit(cb)
    ESX.TriggerServerCallback('esx_inventory:getPlayerWeightLimit', function(limit)
        cb(limit)
    end)
end

-- Command to simulate a selling transaction
RegisterCommand('sellItem', function(source, args, rawCommand)
    local item = args[1]
    local count = tonumber(args[2])

    if item and count then
        -- This command is an example of simulating a transaction
        ESX.TriggerServerCallback('esx_inventory:sellItem', function(success)
            if success then
                ESX.ShowNotification("You sold " .. count .. " " .. item .. "(s).")
            else
                ESX.ShowNotification("Error: Could not sell this item.")
            end
        end, item, count)
    else
        ESX.ShowNotification("Error: Invalid parameters.")
    end
end, false)

-- Command to simulate a purchase transaction
RegisterCommand('buyItem', function(source, args, rawCommand)
    local item = args[1]
    local count = tonumber(args[2])

    if item and count then
        -- This command is an example of simulating a purchase
        ESX.TriggerServerCallback('esx_inventory:buyItem', function(success)
            if success then
                ESX.ShowNotification("You bought " .. count .. " " .. item .. "(s).")
            else
                ESX.ShowNotification("Error: Could not buy this item.")
            end
        end, item, count)
    else
        ESX.ShowNotification("Error: Invalid parameters.")
    end
end, false)
