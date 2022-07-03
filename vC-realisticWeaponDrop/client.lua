local QBCore = exports['qb-core']:GetCoreObject()
local dropTable = {}
currweap, weaponHash = 1, nil
local pos = nil


--- Main Thread To Make It All Work

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        pos = GetEntityCoords(PlayerPedId())
        currweap, weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
        for k,v in pairs(dropTable) do
            local distance = GetDistanceBetweenCoords(pos, v.pos, true)
            if distance < vCode.MaxDistance then
                if distance < vCode.PickupDistance then
                    QBCore.Functions.DrawText3D(v.pos.x,v.pos.y, v.pos.z, vCode.Text.h..' '..vCode.Text.pickup..' ['..v.label..']' )    
                    if IsControlJustPressed(0, 74) then
                        Anim(v.info, v.name, k)
                    end
                else
                    QBCore.Functions.DrawText3D(v.pos.x,v.pos.y, v.pos.z, vCode.Text.pickup..' ['..v.label..']')

                end
            end
        end
    end
end)
function Anim(info,name,key)
    RequestAnimSet("move_ped_crouched")
    RequestAnimDict('pickup_object')
    while not HasAnimSetLoaded("move_ped_crouched") and not HasAnimDictLoaded('pickup_object') do
      Citizen.Wait(100)
    end
    SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.25)
    Wait(500)
    TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
    Wait(1000)
    ResetPedMovementClipset(PlayerPedId(), 0)
    ClearPedTasksImmediately(PlayerPedId())
    TriggerServerEvent('vC-realsticWeaponDrop:server:removeforEveryone', name, info, key)
end

RegisterNetEvent('vC-realsticWeaponDrop:client:removeforEveryone', function(serino)
    local key = dropTable[serino].pickupkey

    RemovePickup(key)
    dropTable[serino] = nil

    

end)



RegisterNetEvent('vC-realtisticWeaponDrop:dropweapon', function(itemname, info, weaponHash,newpos)

    local pickup = CreatePickupRotate(GetPickupHashFromWeapon(weaponHash), newpos.x, newpos.y, newpos.z, 0, 0, 0, 8, 1, 1, true, GetHashKey(weaponHash))
    local apos = GetPickupCoords(pickup)
    local label = QBCore.Shared.Items[itemname].label
    dropTable[info.serie] = {pos = apos, name = itemname, info = info, pickupkey = pickup, label = label}
end)



RegisterNetEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function()

    local PlayerData = QBCore.Functions.GetPlayerData()
    local Items = PlayerData.items

    if currweap ~= false then

        for k,v in pairs(Items) do

            if QBCore.Shared.SplitStr(v.name, "_")[1] == "weapon" and GetHashKey(v.name) == weaponHash  then
                TriggerServerEvent('QBCore:Server:RemoveItem', v.name, 1)
                TriggerEvent('inventory:client:CheckWeapon')
                TriggerServerEvent('vC-realisticWeaponDrop:server:syncforEveryone',v.name,v.info, weaponHash, pos)
            end
        end
    end
end)

