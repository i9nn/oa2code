-- [ services ] --
local Players, Teams = game:GetService("Players"), game:GetService("Teams")

-- [ variables ] --
local teams = {
	["Production"] = {"Production", 253, 254, 255}, 
	["Head of Household"] = {"Head of Household", 251}, 
	["Houseguest"] = {"Houseguests", 250}, 
	["Evicted"] = {"Evicted", 249, 248}
}

-- [ functions ] --
Players.PlayerAdded:Connect(function(plr)
	local rank = plr:GetRankInGroup(13009906)

	--// Loop through dictionary and compare ranks
	for i, t in pairs (teams) do
		if table.find(teams[i], rank) then
			plr.Team = Teams[teams[i][1]]
			plr:LoadCharacter()
		end
	end 
end)