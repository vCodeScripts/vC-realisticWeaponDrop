local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('vC-realisticWeaponDrop:server:syncforEveryone', function(name, info, hash, pos)
    TriggerClientEvent('vC-realtisticWeaponDrop:dropweapon', -1, name,info,hash, pos)
end)


RegisterServerEvent('vC-realsticWeaponDrop:server:removeforEveryone', function(item,info,serie)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.AddItem(item, 1,false,info) then
        local label = QBCore.Shared.Items[item].label
        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'You Picked Up A '..label..' With Serial Number '..serie..' !')
        TriggerClientEvent('vC-realsticWeaponDrop:client:removeforEveryone',-1, serie)
    else
        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'You are too full to pick up this weapon!', 'error')
    end


end)