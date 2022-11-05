local QBCore = exports['qb-core']:GetCoreObject()

takeds = {}

RegisterServerEvent('vC-realisticWeaponDrop:server:syncforEveryone', function(name, info, hash, pos)
    TriggerClientEvent('vC-realtisticWeaponDrop:dropweapon', -1, name,info,hash, pos)
end)


RegisterServerEvent('vC-realsticWeaponDrop:server:removeforEveryone', function(item,info,serie)
    local Player = QBCore.Functions.GetPlayer(source)
        if takeds[serie] == nil then
            if Player.Functions.AddItem(item, 1,false,info) then
                takeds[serie] = 'taked'
                local label = QBCore.Shared.Items[item].label
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'You Picked Up A '..label..' With Serial Number '..serie..' !')
                TriggerClientEvent('vC-realsticWeaponDrop:client:removeforEveryone',-1, serie)
                Citizen.Wait(5000)
                takeds[serie] = nil
                return
            else
                        takeds[serie] = nil
                TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'You are too full to pick up this weapon!', 'error')
            end
    end
end)

RegisterServerEvent("vc-realisticWeaponDrop:server:removeItem", function(item)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(item, 1)

end)
