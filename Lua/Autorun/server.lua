if CLIENT then
    print("SERVERSIDE script running on CLIENT; disabling.. (this is not an error)")
    return
end

local clearDeadTimer = 0 -- placeholder value that is constantly running
local clearDeadDelay = 180 -- 3 minutes

local clearDuffelBagsTimer = 0 -- placeholder value that is constantly running
local clearDuffelBagsDelay = 1440 -- 24 minutes

local function ClearBodies()
    Game.ExecuteCommand("despawnnow")
    Game.Log("Cleared Dead Bodies [This function will only work if cheats are enabled on the server. Otherwise bodies will not passively despawn.]", ServerLogMessageType.ConsoleUsage)
end

function ClearDuffelBags()
    local numBagsRemoved = 0
    for _, theItem in pairs(Item.ItemList) do
        if (theItem.Prefab.Identifier == ('duffelbag')) then
            Entity.Spawner.AddItemToRemoveQueue(theItem)
            numBagsRemoved = numBagsRemoved + 1
        end
    end
    Game.SendMessage("Cleared " .. numBagsRemoved .. " Duffel Bags", 0)
end

-- hooks

Hook.Add('think', 'cleardead', function()
    if Game.RoundStarted then
        if Timer.GetTime() < clearDeadTimer then return end

        ClearBodies()

        clearDeadTimer = Timer.GetTime() + clearDeadDelay
    end
end)

Hook.Add('think', 'clearbags', function()
    if Game.RoundStarted then
        if Timer.GetTime() < clearDuffelBagsTimer then return end

        ClearDuffelBags()

        clearDuffelBagsTimer = Timer.GetTime() + clearDuffelBagsDelay
    end
end)

--[[ old code
Hook.Add('think', 'optimize', function()
    if Game.RoundStarted then
        if Timer.GetTime() < clearDeadTimer then
            ClearBodies()
            clearDeadTimer = Timer.GetTime() + clearDeadDelay
        end

        if Timer.GetTime() < clearDuffelBagsTimer then
            ClearDuffelBags()
            clearDuffelBagsTimer = Timer.GetTime() + clearDuffelBagsDelay
        end

        if Timer.GetTime() < VerifyMessageTimer then
            Verify()
            VerifyMessageTimer = Timer.GetTime() + VerifyMessageDelay
        end

        if Timer.GetTime() < ServerMessageTimer then
            ServerMessage()
            ServerMessageTimer = Timer.GetTime() + ServerMessageDelay
        end
    end
end)
--]]