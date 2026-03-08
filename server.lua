-- server.lua - infronix_gruppe6 (FINAL: Clean, secure, tablet removed ONLY after final cash payout)
local cooldowns = {}
local activeRoutes = {}

local function now() return os.time() end
local function onCooldown(id) return cooldowns[id] and cooldowns[id] > now() end
local function setCooldown(id, seconds) cooldowns[id] = now() + seconds end

local function buildRandomRoute()
    local poolBanks = Config.Pool.banks or {}
    local poolCash = Config.Pool.cash or {}
    local bankSize = #poolBanks
    local cashSize = #poolCash

    -- shuffle helper
    local function shuffledIndices(n)
        local idx = {}
        for i = 1, n do idx[i] = i end
        for i = n, 2, -1 do
            local j = math.random(1, i)
            idx[i], idx[j] = idx[j], idx[i]
        end
        return idx
    end

    -- select loan stops from banks
    local loan = {}
    if bankSize > 0 then
        local idx = shuffledIndices(bankSize)
        for i = 1, math.min(Config.LoanRouteCount, bankSize) do
            table.insert(loan, poolBanks[idx[i]])
        end
    end

    -- select cash stops from ATMs (cash pool)
    local cash = {}
    if cashSize > 0 then
        local idx = shuffledIndices(cashSize)
        for i = 1, math.min(Config.CashRouteCount, cashSize) do
            table.insert(cash, poolCash[idx[i]])
        end
    end

    -- fallback: if cash pool smaller than required, fill with random banks
    while #cash < Config.CashRouteCount do
        if bankSize > 0 then
            table.insert(cash, poolBanks[math.random(1, bankSize)])
        else
            -- if there are no banks either, break to avoid infinite loop
            break
        end
    end

    return { loan = loan, cash = cash }
end

RegisterNetEvent("infronix_gruppe6:server:RequestSchedule", function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local cooldownKey = "schedule_"..citizenid

    if onCooldown(cooldownKey) then
        local timeLeft = cooldowns[cooldownKey] - now()
        TriggerClientEvent("infronix_gruppe6:client:ScheduleCooldown", src, timeLeft)
        return
    end

    local route = buildRandomRoute()
    activeRoutes[citizenid] = { route = route, created = now() }
    setCooldown(cooldownKey, Config.Cooldowns.Schedule)
    
    -- Give GPS item if they don't have one
    local count = exports.ox_inventory:GetItemCount(src, 'g6_route_gps')
    if count == 0 then
        exports.ox_inventory:AddItem(src, 'g6_route_gps', 1)
    end
    
    TriggerClientEvent("infronix_gruppe6:client:ReceiveSchedule", src, route)
end)

-- LOAN PHASE PAYMENT (only once)
RegisterNetEvent("infronix_gruppe6:server:CompleteLoanPhase", function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    if not activeRoutes[citizenid] or activeRoutes[citizenid].loanDone then return end

    Player.Functions.AddMoney('bank', Config.LoanPayout)
    activeRoutes[citizenid].loanDone = true
end)

-- FINAL CASH PHASE PAYMENT
-- -> pay player, THEN remove tablet, THEN cleanup and set full-job cooldown
RegisterNetEvent("infronix_gruppe6:server:CompleteCashPhase", function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    if not activeRoutes[citizenid] then return end

    -- Pay final wages
    Player.Functions.AddMoney('bank', Config.CashPayout)

    -- REMOVE TABLET ONLY AFTER FINAL PAYMENT
    local count = exports.ox_inventory:GetItemCount(src, 'g6_route_gps')
    if count > 0 then
        exports.ox_inventory:RemoveItem(src, 'g6_route_gps', 1)
    end

    -- Clean up route and set cooldown
    activeRoutes[citizenid] = nil
    setCooldown("schedule_"..citizenid, Config.Cooldowns.FullJob)
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if Player then
        local citizenid = Player.PlayerData.citizenid
        activeRoutes[citizenid] = nil
        cooldowns["schedule_"..citizenid] = nil
    end
end)

-- GPS Item Usage
exports.qbx_core:CreateUseableItem("g6_route_gps", function(source, item)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    local citizenid = Player.PlayerData.citizenid
    
    -- Check if player has an active route
    if not activeRoutes[citizenid] then
        return
    end
    
    -- Open the GPS UI with their active route
    TriggerClientEvent("infronix_gruppe6:client:OpenGPS", src)
end)

print("^2[infronix_gruppe6]^7 Script loaded successfully!")
