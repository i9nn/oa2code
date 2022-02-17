-- [ services ] --
local ServerStorage, Teams, TweenService = game:GetService("ServerStorage"), game:GetService("Teams"), game:GetService("TweenService")

-- [ objects ] --
local sys = script.Parent
local k_pick, k_sel, k_turn = sys.KeyBoxPickUp, sys.KeySelector, sys.KeyBoxKeyTurn
local key, k_box = ServerStorage.Tools.Key, ServerStorage.Tools["Key Box"]

local wall = workspace:FindFirstChild("MemoryWall", true)

-- [ functions ] --
for _, slot in pairs (k_pick.Slots:GetChildren()) do 
    slot.Key.MouseClick:Connect(function(plr)
        if plr.Team == game.Teams["Head of Household"] then
            local hg_key = key:Clone()
            hg_key.Headshot.Value = slot.Disc.Headshot.Texture

            hg_key.Parent = plr.Character; slot.Key:Destroy()
        end
    end)
end

k_pick.Touch.Touched:Connect(function(hit)
    local keys = k_pick.Keys 
    local k_1, k_2 = keys.Key1, keys.Key2

    local function turn_on(r, h)
        r.Headshot.Value = h.Parent.Headshot.Value
        r.Transparency = 0
        h.Parent:Destroy()
    end

    if hit.Parent.Name == "Key" then
        if k_1.Transparency == 1 then
            turn_on(k_1, hit)
        else
            turn_on(k_2, hit)
            k_pick.Touch.ClickDetector.MaxActivationDistance = 10
        end
    end
end)


k_pick.Touch.ClickDetector.MouseClick:Connect(function(plr)
    local n_box = k_box:Clone()
    for i, k in pairs (k_pick.Keys:GetChildren()) do 
        k["Key" .. i].Headshot.Value = k_pick.Keys["Key" .. i].Headshot.Value
    end
    n_box.Parent = plr.Character

    k_pick:Destroy
end)

k_turn.Touch.Touched:Connect(function(hit)
	if hit.Parent.Name == "Key Box" then
		for _, obj in pairs (k_turn:GetDescendants()) do
			if obj:IsA("BasePart") then 
				obj.Transparency = 0; obj.CanCollide = true

				if obj.Name == "Touch" then
					obj.Transparency = 1
				end
			elseif obj:IsA("Decal") then
				obj.Transparency = 0.5
			end
		end
		
		for _, track in pairs (hit.Parent.Parent:FindFirstChild("Humanoid"):GetPlayingAnimationTracks()) do
			track:Stop()
			track:Remove()
		end
		
		for i, key in pairs (k_turn.Keys:GetChildren()) do 
            local k = k_turn.Keys["Key" .. i].Key

			k.Headshot.Value = hit.Parent["Key" .. i].Headshot.Value
			k.Key.ClickDetector.MaxActivationDistance = 8
		end
		
		hit.Parent:Destroy(); k_turn.Touch:Destroy()
	end
end)

for _, key in pairs (k_turn.Keys:GetChildren()) do
	key.Key.ClickDetector.MouseClick:Connect(function(plr)
		if plr.Team == Teams["Head of Household"] and key.Turned.Value == false then

			if key.Turned.Value == false then
				TweenService:Create(key.PrimaryPart, TweenInfo.new(), {CFrame = key.PrimaryPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)}):Play()
			end
			
			local nom = wall.Screens.Screen1:FindFirstChild("Nom" .. string.sub(key.Name, 4), true)
			nom.Houseguest.Image = key.Key.Headshot.Value
			nom.Houseguest.NomFade.Disabled = false

			key.Turned.Value = true
		end
	end)
end

