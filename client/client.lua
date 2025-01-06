local playerInventory = {}

--- ## 1. Gestion de l'Inventaire ##
-- Ouvrir l'inventaire
RegisterNetEvent('esx_inventory:openInventory')
AddEventHandler('esx_inventory:openInventory', function()
    ESX.TriggerServerCallback('esx_inventory:getPlayerInventory', function(inventory)
        if inventory then
            playerInventory = inventory
            -- Exemple : Affiche l'inventaire dans un menu interactif
            OpenInventoryMenu(playerInventory)
        else
            ESX.ShowNotification('~r~Votre inventaire est vide.')
        end
    end)
end)

-- Utiliser un objet
RegisterNetEvent('esx_inventory:useItem')
AddEventHandler('esx_inventory:useItem', function(item)
    if playerInventory[item] and playerInventory[item] > 0 then
        TriggerServerEvent('esx_inventory:removeItem', item, 1)
        ESX.ShowNotification('Vous avez utilisé ~g~1 ' .. item)
        -- Ajoutez ici une action spécifique pour l'objet (par exemple : consommer une nourriture, utiliser une clé, etc.)
    else
        ESX.ShowNotification('~r~Vous ne possédez pas cet objet.')
    end
end)

--- ## 2. Gestion des Transferts ##
-- Donner un objet à un autre joueur
RegisterNetEvent('esx_inventory:giveItem')
AddEventHandler('esx_inventory:giveItem', function(targetId, item, count)
    if playerInventory[item] and playerInventory[item] >= count then
        TriggerServerEvent('esx_inventory:transferItem', targetId, item, count)
        ESX.ShowNotification('Vous avez donné ~g~' .. count .. ' ' .. item)
    else
        ESX.ShowNotification('~r~Vous n\'avez pas assez de ' .. item)
    end
end)

--- ## 3. Affichage du Menu d'Inventaire ##
function OpenInventoryMenu(inventory)
    local elements = {}

    for item, count in pairs(inventory) do
        table.insert(elements, {
            label = item .. ' x' .. count,
            value = item
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_menu', {
        title    = 'Inventaire',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        local item = data.current.value
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory_item_menu', {
            title    = 'Options pour ' .. item,
            align    = 'top-left',
            elements = {
                { label = 'Utiliser', value = 'use' },
                { label = 'Donner', value = 'give' }
            }
        }, function(optionData, optionMenu)
            if optionData.current.value == 'use' then
                TriggerEvent('esx_inventory:useItem', item)
                menu.close()
            elseif optionData.current.value == 'give' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'give_item_count', {
                    title = 'Quantité'
                }, function(dialogData, dialogMenu)
                    local count = tonumber(dialogData.value)
                    if count and count > 0 then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            TriggerEvent('esx_inventory:giveItem', GetPlayerServerId(closestPlayer), item, count)
                            dialogMenu.close()
                            menu.close()
                        else
                            ESX.ShowNotification('~r~Aucun joueur à proximité.')
                        end
                    else
                        ESX.ShowNotification('~r~Quantité invalide.')
                    end
                end, function(_, dialogMenu)
                    dialogMenu.close()
                end)
            end
        end, function(_, menu)
            menu.close()
        end)
    end, function(_, menu)
        menu.close()
    end)
end

--- ## 4. Initialisation et Raccourcis ##
-- Ouvrir l'inventaire via une touche (par défaut : F2)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 289) then -- F2 par défaut
            TriggerEvent('esx_inventory:openInventory')
        end
    end
end)
