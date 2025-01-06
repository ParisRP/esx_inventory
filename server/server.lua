ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--- ## 1. Callbacks ##
-- Chargement des données d'inventaire du joueur
ESX.RegisterServerCallback('esx_inventory:getPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(nil)
        return
    end

    local identifier = xPlayer.identifier
    local inventory = MySQL.scalar.await('SELECT inventory FROM users WHERE identifier = ?', { identifier })

    if inventory then
        cb(json.decode(inventory)) -- Retourne l'inventaire décodé
    else
        cb({})
    end
end)

-- Vérification de la possession d'un objet spécifique
ESX.RegisterServerCallback('esx_inventory:hasItem', function(source, cb, item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false)
        return
    end

    local identifier = xPlayer.identifier
    local inventory = MySQL.scalar.await('SELECT inventory FROM users WHERE identifier = ?', { identifier })

    if not inventory then
        cb(false)
    else
        inventory = json.decode(inventory)
        if inventory[item] and inventory[item] >= count then
            cb(true)
        else
            cb(false)
        end
    end
end)

--- ## 2. Gestion des Objets ##
-- Ajouter un objet à l'inventaire
RegisterNetEvent('esx_inventory:addItem')
AddEventHandler('esx_inventory:addItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local inventory = MySQL.scalar.await('SELECT inventory FROM users WHERE identifier = ?', { identifier })

    if not inventory then
        inventory = {}
    else
        inventory = json.decode(inventory)
    end

    if inventory[item] then
        inventory[item] = inventory[item] + count
    else
        inventory[item] = count
    end

    MySQL.update('UPDATE users SET inventory = ? WHERE identifier = ?', { json.encode(inventory), identifier })
    TriggerClientEvent('esx:showNotification', source, 'Vous avez reçu ~g~' .. count .. ' ' .. item)
end)

-- Retirer un objet de l'inventaire
RegisterNetEvent('esx_inventory:removeItem')
AddEventHandler('esx_inventory:removeItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local identifier = xPlayer.identifier
    local inventory = MySQL.scalar.await('SELECT inventory FROM users WHERE identifier = ?', { identifier })

    if not inventory then
        inventory = {}
    else
        inventory = json.decode(inventory)
    end

    if inventory[item] and inventory[item] >= count then
        inventory[item] = inventory[item] - count

        if inventory[item] <= 0 then
            inventory[item] = nil
        end

        MySQL.update('UPDATE users SET inventory = ? WHERE identifier = ?', { json.encode(inventory), identifier })
        TriggerClientEvent('esx:showNotification', source, 'Vous avez utilisé ~r~' .. count .. ' ' .. item)
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Vous n\'avez pas assez de ' .. item)
    end
end)

--- ## 3. Transfert d'Objets ##
-- Transférer un objet à un autre joueur
RegisterNetEvent('esx_inventory:transferItem')
AddEventHandler('esx_inventory:transferItem', function(targetId, item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetPlayer = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not targetPlayer then
        TriggerClientEvent('esx:showNotification', source, '~r~Joueur introuvable.')
        return
    end

    local identifier = xPlayer.identifier
    local targetIdentifier = targetPlayer.identifier

    local inventory = MySQL.scalar.await('SELECT inventory FROM users WHERE identifier = ?', { identifier })
    local targetInventory = MySQL.scalar.await('SELECT inventory FROM users WHERE identifier = ?', { targetIdentifier })

    if not inventory then
        inventory = {}
    else
        inventory = json.decode(inventory)
    end

    if not targetInventory then
        targetInventory = {}
    else
        targetInventory = json.decode(targetInventory)
    end

    if inventory[item] and inventory[item] >= count then
        -- Retirer de l'expéditeur
        inventory[item] = inventory[item] - count
        if inventory[item] <= 0 then
            inventory[item] = nil
        end

        -- Ajouter au destinataire
        if targetInventory[item] then
            targetInventory[item] = targetInventory[item] + count
        else
            targetInventory[item] = count
        end

        MySQL.update('UPDATE users SET inventory = ? WHERE identifier = ?', { json.encode(inventory), identifier })
        MySQL.update('UPDATE users SET inventory = ? WHERE identifier = ?', { json.encode(targetInventory), targetIdentifier })

        TriggerClientEvent('esx:showNotification', source, 'Vous avez donné ~g~' .. count .. ' ' .. item)
        TriggerClientEvent('esx:showNotification', targetId, 'Vous avez reçu ~g~' .. count .. ' ' .. item)
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Vous n\'avez pas assez de ' .. item)
    end
end)
