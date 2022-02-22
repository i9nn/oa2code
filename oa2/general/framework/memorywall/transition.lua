-- [ services ] --
local TweenService = game:GetService("TweenService")

-- [ objects ] --
local HostKitComm = game.ReplicatedStorage.HostKitComm
local wall = script.Parent
local borders, screens = wall.borders, wall.screens

-- [ variables ] --
local debounce = true

-- [ functions ] --
HostKitComm.OnServerEvent:Connect(function(plr, key, pos)
	if plr:GetRankInGroup(13009906) < 253 then
		plr:Kick("Exploiting")
	else
		if key == "BW" then
			local face = screens:FindFirstChild("hg_" .. pos, true)
			if face.Houseguest.ImageTransparency == 0 or face.Houseguest.ImageTransparency == 1 then
				if face.Houseguest.ImageTransparency == 0 then
					TweenService:Create(face.Houseguest, TweenInfo.new(), {ImageTransparency = 1; BackgroundTransparency = 1}):Play()
				else
					TweenService:Create(face.Houseguest, TweenInfo.new(), {ImageTransparency = 0; BackgroundTransparency = 0}):Play()
				end
			end
		elseif key == "ToggleWall" and debounce == true then
				wait(0.25)
			debounce = false
			local spawned = false
			for _, cir in pairs (wall:GetDescendants()) do
				if cir.Name == "Circles" then 
					local p = cir.Parent
					local done = false

					for _, c in pairs (cir:GetChildren()) do 
						local sz = tonumber(c.Name)
						local function tw()
							TweenService:Create(c,
								TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
								{Size = UDim2.new(0, sz, 0, sz); Position = UDim2.new(0, c.Position.X.Offset - (sz / 2), 0, c.Position.Y.Offset - (sz / 2))}
							):Play()
							wait(2)
					
							if done == false then
								if p.Houseguests.Visible == true then
									if spawned == false then
										game.ServerStorage.MemWallSys:Clone().Parent = workspace
										spawned = true 
									end
									
									print("ONE")
									p.Deco.Visible = false; p.Houseguests.Visible = false; p.Nominations.Visible = true
									for _, h in pairs (p.Nominations:GetDescendants()) do if h.Name == "Houseguest" then h.Image = "" h.ImageTransparency = 1 end end
								else 
									p.Deco.Visible = true; p.Houseguests.Visible = true; p.Nominations.Visible = false
									workspace.MemWallSys:Destroy()
								end
								
								done = true
							end


							TweenService:Create(c,
								TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
								{Size = UDim2.new(0, 0, 0, 0); Position = UDim2.new(0, c.Position.X.Offset + sz / 2, 0, c.Position.Y.Offset + sz / 2)}
							):Play()
						end

						local x = coroutine.create(tw)
						coroutine.resume(x)
					end
				end
			end
			debounce = true
		end
	end
end)

