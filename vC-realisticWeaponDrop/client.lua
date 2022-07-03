local QBCore = exports['qb-core']:GetCoreObject()
local dropTable = {}
currweap, weaponHash = 1, nil
local pos = nil

--- Main Thread To Make It All Work

function CanPickup()
  if IsEntityDead(PlayerPedId()) then return true end 
  if IsPedFatallyInjured(PlayerPedId()) then return true end 
  if GetEntityHealth(PlayerPedId()) == 0 then return true end 
  return false 
end

Citizen.CreateThread(function()
    sleep = 400
    while true do
        Citizen.Wait(sleep)
        pos = GetEntityCoords(PlayerPedId())
        currweap, weaponHash = GetCurrentPedWeapon(PlayerPedId(), 1)
        for k,v in pairs(dropTable) do
            local distance = GetDistanceBetweenCoords(pos, v.pos, true)
            if distance < vCode.MaxDistance then
                sleep = 0
                if distance < vCode.PickupDistance then
                    QBCore.Functions.DrawText3D(v.pos.x,v.pos.y, v.pos.z, vCode.Text.h..' '..vCode.Text.pickup..' ['..v.label..']' )    
                    if IsControlJustPressed(0, vCode.Key) then
                        local pickupB = CanPickup()
                        if pickupB == false then 
                            Anim(v.info, v.name, k)
                        end
                    end
                else
                    QBCore.Functions.DrawText3D(v.pos.x,v.pos.y, v.pos.z, vCode.Text.pickup..' ['..v.label..']')

                end
            else
                sleep = 400
            end
        end
     
    end
end)

function Anim(info,name,key)
    if not IsEntityDead(PlayerPedId()) then
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

haveTwoScriptsConrol = {}

RegisterNetEvent('baseevents:onPlayerDied')
AddEventHandler('baseevents:onPlayerDied', function()
    if haveTwoScriptsConrol['as'] == nil then 
        local PlayerData = QBCore.Functions.GetPlayerData()
        local Items = PlayerData.items
        CanDrop = true
        for k,v in pairs(vCode.BlacklistedWeapons) do 
            if GetHashKey(v) == weaponHash then 
                CanDrop = false
                break
            end
        end
        if currweap ~= false and CanDrop then
            
            for k,v in pairs(Items) do
    
                if QBCore.Shared.SplitStr(v.name, "_")[1] == "weapon" and GetHashKey(v.name) == weaponHash  then
                    TriggerServerEvent('QBCore:Server:RemoveItem', v.name, 1)
                    TriggerEvent('inventory:client:CheckWeapon')
                    TriggerServerEvent('vC-realisticWeaponDrop:server:syncforEveryone',v.name,v.info, weaponHash, pos)
                end
            end
        end
        haveTwoScriptsConrol['as'] = 'as'
    end
    Wait(2000)
    haveTwoScriptsConrol['as'] = nil
end)

local disabledPickups = {
    `PICKUP_WEAPON_ADVANCEDRIFLE`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_ASSAULTRIFLE`,
    `PICKUP_WEAPON_ASSAULTRIFLE_MK2`,
    `PICKUP_WEAPON_ASSAULTSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSMG`,
    `PICKUP_WEAPON_AUTOSHOTGUN`,
    `PICKUP_WEAPON_BAT`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_BOTTLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE_MK2`,
    `PICKUP_WEAPON_BULLPUPSHOTGUN`,
    `PICKUP_WEAPON_CARBINERIFLE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2`,
    `PICKUP_WEAPON_COMBATMG`,
    `PICKUP_WEAPON_COMBATMG_MK2`,
    `PICKUP_WEAPON_COMBATPDW`,
    `PICKUP_WEAPON_COMBATPISTOL`,
    `PICKUP_WEAPON_COMPACTLAUNCHER`,
    `PICKUP_WEAPON_COMPACTRIFLE`,
    `PICKUP_WEAPON_CROWBAR`,
    `PICKUP_WEAPON_DAGGER`,
    `PICKUP_WEAPON_DBSHOTGUN`,
    `PICKUP_WEAPON_DOUBLEACTION`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_FLAREGUN`,
    `PICKUP_WEAPON_FLASHLIGHT`,
    `PICKUP_WEAPON_GRENADE`,
    `PICKUP_WEAPON_GRENADELAUNCHER`,
    `PICKUP_WEAPON_GUSENBERG`,
    `PICKUP_WEAPON_GolfClub`,
    `PICKUP_WEAPON_HAMMER`,
    `PICKUP_WEAPON_HATCHET`,
    `PICKUP_WEAPON_HEAVYPISTOL`,
    `PICKUP_WEAPON_HEAVYSHOTGUN`,
    `PICKUP_WEAPON_HEAVYSNIPER`,
    `PICKUP_WEAPON_HEAVYSNIPER_MK2`,
    `PICKUP_WEAPON_HOMINGLAUNCHER`,
    `PICKUP_WEAPON_KNIFE`,
    `PICKUP_WEAPON_KNUCKLE`,
    `PICKUP_WEAPON_MACHETE`,
    `PICKUP_WEAPON_MACHINEPISTOL`,
    `PICKUP_WEAPON_MARKSMANPISTOL`,
    `PICKUP_WEAPON_MARKSMANRIFLE`,
    `PICKUP_WEAPON_MARKSMANRIFLE_MK2`,
    `PICKUP_WEAPON_MG`,
    `PICKUP_WEAPON_MICROSMG`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_WEAPON_MINISMG`,
    `PICKUP_WEAPON_MOLOTOV`,
    `PICKUP_WEAPON_MUSKET`,
    `PICKUP_WEAPON_NIGHTSTICK`,
    `PICKUP_WEAPON_PETROLCAN`,
    `PICKUP_WEAPON_PIPEBOMB`,
    `PICKUP_WEAPON_PISTOL`,
    `PICKUP_WEAPON_PISTOL50`,
    `PICKUP_WEAPON_PISTOL_MK2`,
    `PICKUP_WEAPON_POOLCUE`,
    `PICKUP_WEAPON_PROXMINE`,
    `PICKUP_WEAPON_PUMPSHOTGUN`,
    `PICKUP_WEAPON_PUMPSHOTGUN_MK2`,
    `PICKUP_WEAPON_RAILGUN`,
    `PICKUP_WEAPON_RAYCARBINE`,
    `PICKUP_WEAPON_RAYMINIGUN`,
    `PICKUP_WEAPON_RAYPISTOL`,
    `PICKUP_WEAPON_REVOLVER`,
    `PICKUP_WEAPON_REVOLVER_MK2`,
    `PICKUP_WEAPON_RPG`,
    `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
    `PICKUP_WEAPON_SMG`,
    `PICKUP_WEAPON_SMG_MK2`,
    `PICKUP_WEAPON_SMOKEGRENADE`,
    `PICKUP_WEAPON_SNIPERRIFLE`,
    `PICKUP_WEAPON_SNSPISTOL`,
    `PICKUP_WEAPON_SNSPISTOL_MK2`,
    `PICKUP_WEAPON_SPECIALCARBINE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
    `PICKUP_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_STONE_HATCHET`,
    `PICKUP_WEAPON_STUNGUN`,
    `PICKUP_WEAPON_SWITCHBLADE`,
    `PICKUP_WEAPON_VINTAGEPISTOL`,
    `PICKUP_WEAPON_WRENCH`
}

CreateThread(function()
    for _, hash in pairs(disabledPickups) do
        ToggleUsePickupsForPlayer(PlayerId(), hash, false)
    end
end)
