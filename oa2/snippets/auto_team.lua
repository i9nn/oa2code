-- [ services ] --
local Players, Teams = game:GetService("Players"), game:GetService("Teams")

-- [ variables ] --
local teams = {
    ["Production"] = {253, 254, 255},
    ["Head of Household"] = {251},
    ["Houseguest"] = {250},
    ["Evicted"] = {249, 248}
}

-- [ functions ] --
Players.PlayerAdded:Connect(function(plr)
    local rank = plr:GetRankInGroup(13009906)

    --// Loop through dictionary and compare ranks
    for i, t in pairs (teams) do
        if table.find(t[i], rank) then
            plr.Team = Teams[teams[i]]
        end
    end 
end)