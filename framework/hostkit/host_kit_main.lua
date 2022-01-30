-- [ services ] --
local Players, ReplicatedStorage, TweenService = game.Players, game.ReplicatedStorage, game:GetService("TweenService")

-- [ objects ] --
local HostKitActive, HostKitComm, HostKitStorage = workspace.HostKitActive, ReplicatedStorage.HostKitComm, game.ServerStorage.HostKitServerStorage

-- [ variables ] --
local can_fade, active_track = true, "Track1"

-- [ functions ] --
Players.PlayerAdded:Connect(function(plr)
	local comps, music = {}, {}
	for _, c in pairs (HostKitStorage.Comps:GetChildren()) do table.insert(comps, c.Name) end
	for _, m in pairs (HostKitStorage.Music:GetChildren()) do table.insert(music, m.Name) end
	
	HostKitComm:FireClient(plr, comps, music)
end)

HostKitComm.OnServerEvent:Connect(function(plr, key, item, parent)
	-- add kick function!!
	
	if key == "Spawn" then
		if parent == "Comps" then
			if not HostKitActive.Comps:FindFirstChild(item) then
				HostKitStorage.Comps[item]:Clone().Parent = workspace.HostKitActive.Comps
			else HostKitActive.Comps[item]:Destroy() end
		elseif parent == "Music" then
			if can_fade == true then
				if not (string.find(item, "SFX")) then
					can_fade = false; local new_track = "Track1"
					if active_track == "Track1" then new_track = "Track2" end
					HostKitActive.Music[new_track].SoundId = HostKitStorage.Music[item].SoundId
					
					local inf = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
					TweenService:Create(HostKitActive.Music[active_track], inf, {Volume = 0}):Play()
					TweenService:Create(HostKitActive.Music[new_track], inf, {Volume = 0.5}):Play()
					active_track = new_track
					
					HostKitActive.Music[new_track].Playing = true; HostKitActive.Music[new_track].TimePosition = 0
					HostKitActive.Music[active_track].Playing = true
						wait(2)
					can_fade = true
				end
			end
		end
	end
end)