--[ Services ] --
local ServerStorage = game:GetService("ServerStorage")
local Teams = game:GetService("Teams")
local TweenService = game:GetService("TweenService")

-- [ Objects ] --
local sys = script.Parent
local pick, sel, turn = sys.KeyBoxPickUp, sys.KeySelector, sys.KeyBoxKeyTurn
local key, keyBox = ServerStorage.Key, ServerStorage["Key Box"]

local wall = workspace.MemoryWall

-- [ Functions ] --
for _, slot in pairs (sel.KeySlots:GetChildren()) do
	slot.KeyClick.ClickDetector.MouseClick:Connect(function(plr)
		if plr.Team == Teams["Head of Household"] then
			local k = key:Clone()
			k.DecalValue.Value = slot.Disc.Houseguest.Texture
			k.Parent = plr.Backpack
			slot.KeyClick:Destroy()
		end
	end) 
end

pick.Touch.Touched:Connect(function(hit)
	local keys = pick.Keys
	local k1, k2 = keys.Key1, keys.Key2

	local function turnOn(r, h)
		r.DecalValue.Value = hit.Parent.DecalValue.Value
		r.Transparency = 0
		h.Parent:Destroy()
	end

	if hit.Parent.Name == "Key" then
		if k1.Transparency == 1 then
			turnOn(k1, hit)
		elseif k2.Transparency == 1 then
			turnOn(k2, hit)
			pick.Touch.ClickDetector.MaxActivationDistance = 10
		end
	end
end)

pick.Touch.ClickDetector.MouseClick:Connect(function(plr)
	local k = keyBox:Clone()

	for i, key in pairs (pick.Keys:GetChildren()) do
		k["Key" .. i].DecalValue.Value = pick.Keys["Key" .. i].DecalValue.Value
	end
	k.Parent = plr.Character

	pick:Destroy()
end)

turn.Touch.Touched:Connect(function(hit)
	if hit.Parent.Name == "Key Box" then
		for _, obj in pairs (turn:GetDescendants()) do
			if obj:IsA("BasePart") then 
				obj.Transparency = 0
				obj.CanCollide = true
				if obj.Name == "Touch" then
					obj.Transparency = 1
				end
			elseif obj:IsA("Decal") then
				obj.Transparency = 0.5
			end
		end

		local tracks = hit.Parent.Parent:FindFirstChild("Humanoid"):GetPlayingAnimationTracks()
		for _, track in pairs (tracks) do
			track:Stop()
			track:Remove()
		end

		for i, key in pairs (turn.Keys:GetChildren()) do 
			turn.Keys["Key" .. i].Key.DecalValue.Value = hit.Parent["Key" .. i].DecalValue.Value
			turn.Keys["Key" .. i].Key.ClickDetector.MaxActivationDistance = 8
		end

		hit.Parent:Destroy(); turn.Touch:Destroy()
	end
end)

for _, key in pairs (turn.Keys:GetChildren()) do
	key.Key.ClickDetector.MouseClick:Connect(function(plr)
		if plr.Team == Teams["Head of Household"] and key.Turned.Value == false then
			local tween = TweenService:Create(key.PrimaryPart, TweenInfo.new(), {
				CFrame = key.PrimaryPart.CFrame * CFrame.Angles(math.rad(90), 0, 0)
			})

			if key.Turned.Value == false then
				tween:Play()
			end

			local s = string.sub(key.Name, 4)
			local nom = wall:FindFirstChild("Nom" .. s, true)

			nom.Houseguest.Image = key.Key.DecalValue.Value
			nom.Houseguest.NomFade.Disabled = false
			key.Turned.Value = true
		end
	end)
end