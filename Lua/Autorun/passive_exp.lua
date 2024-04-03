if CLIENT and Game.IsMultiplayer then return end -- lets this run if on the server-side, if it's multiplayer, doesn't let it run on the client, and if it's singleplayer, lets it run on the client.

local amountExperience = 1700
local passiveExperienceDelay = 360
local passiveExperienceTimer = 0 -- placeholder value that is constantly running

Hook.Add("think", "examples.passiveExperience", function()
    if Timer.GetTime() < passiveExperienceTimer then return end

    for k, v in pairs(Character.CharacterList) do
        if not v.IsDead and v.Info ~= nil then
            v.Info.GiveExperience(amountExperience)
        end
    end

    passiveExperienceTimer = Timer.GetTime() + passiveExperienceDelay
end)