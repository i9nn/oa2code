-- [ services ] --
local Players, ReplicatedStorage, TweenService = game.Players, game.ReplicatedStorage, game:GetService("TweenService")

-- [ objects ] --
local HostKitActive, HostKitComm, HostKitStorage = workspace.HostKitActive, ReplicatedStorage.HostKitComm, game.ServerStorage.HostKitServerStorage

-- [ variables ] --
local can_fade, active_track = true, "Track1"

-- [ functions ] --

--// Add music tables sent from Server + update scrolling frames 
Players.PlayerAdded:Connect(function(plr)
	local comps, music = {}, {}
	for _, c in pairs (HostKitStorage.Comps:GetChildren()) do table.insert(comps, c.Name) end
	for _, m in pairs (HostKitStorage.Music:GetChildren()) do table.insert(music, m.Name) end
	
	HostKitComm:FireClient(plr, comps, music)
end)

HostKitComm.OnServerEvent:Connect(function(plr, key, item, parent)
	if plr:GetRankInGroup(13009906) < 253 then
        plr:Kick("Exploiting!")
    end
	
	if key == "Spawn" then
		if parent == "Comps" then

            --// Add comp spawning + delete if pre-existing
			if not HostKitActive.Comps:FindFirstChild(item) then
				HostKitStorage.Comps[item]:Clone().Parent = workspace.HostKitActive.Comps
			else HostKitActive.Comps[item]:Destroy() end
		elseif parent == "Music" then

            --// Alter two track music crossfade
			if can_fade == true then
				if not (string.find(item, "SFX")) then
                    --// Set up tracks
					can_fade = false; local new_track = "Track1"
					if active_track == "Track1" then new_track = "Track2" end
					HostKitActive.Music[new_track].SoundId = HostKitStorage.Music[item].SoundId
					
                    --// Tween old tracks into new ones
					local inf = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
					TweenService:Create(HostKitActive.Music[active_track], inf, {Volume = 0}):Play()
					TweenService:Create(HostKitActive.Music[new_track], inf, {Volume = 0.5}):Play()
					active_track = new_track
					
                    --// Reset for next track call
					HostKitActive.Music[new_track].Playing = true; HostKitActive.Music[new_track].TimePosition = 0
					HostKitActive.Music[active_track].Playing = true
						wait(2)
					can_fade = true
				end
			end
		end
	elseif key == "BW" then
		
	end
end)