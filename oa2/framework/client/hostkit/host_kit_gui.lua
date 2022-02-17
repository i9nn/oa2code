-- [ services ] --
local  RunService = game:GetService("RunService")

-- [ objects ] --
local frame = script.Parent
local buttons, container, title = frame.Buttons, frame.Container, frame.Title

local HostKitComm = game.ReplicatedStorage.HostKitComm

-- [ functions ] --

--// Allows for collapsable host box
title.ToggleBar.MouseButton1Up:Connect(function()
	local text = title.ToggleBar.Text
	if text == "[ o ] OA2 Hosting Gui" then
		frame:TweenPosition(UDim2.new(0.989, 0, 1.51, 0))
		title.ToggleBar.Text = "[ x ] OA2 Hosting Gui"
	else
		frame:TweenPosition(UDim2.new(0.989, 0, 0.979, 0))
		title.ToggleBar.Text = "[ o ] OA2 Hosting Gui"
	end
end)

--// Scrolling bars added via Container buttons
for _, b in pairs (buttons.FrameButtons:GetChildren()) do 
	if b:IsA("TextButton") then
		b.MouseButton1Up:Connect(function()
			for _, f in pairs (container:GetChildren()) do f.Visible = false end
			container[b.Name].Visible = true
		end)
	end
end

--// Receive information from server to update Comps / Music
HostKitComm.OnClientEvent:Connect(function(comps, music)
	local t = container.Comps.Holder.Template
	for _, c in pairs (comps) do 
		local new_t = t:Clone()
		new_t.Name = c; new_t.Text = c
		new_t.Parent = container.Comps.Holder
	end
	t:Destroy()
	
	t = container. Music.Holder.Template
	for _, m in pairs (music) do 
		local new_t = t:Clone()
		new_t.Name = m; new_t.Text = m
		new_t.Parent = container.Music.Holder
	end
	t:Destroy()
end)

for _, b in pairs (container:GetDescendants()) do 
	if b:IsA("TextButton") then
		b.MouseButton1Up:Connect(function()
			if b:FindFirstAncestor("Comps") or b:FindFirstAncestor("Music") then
				HostKitComm:FireServer("Spawn", b.Name, b.Parent.Parent.Name);
			elseif b:FindFirstAncestor("Wall") then
				HostKitComm:FireServer("BW", b.Name, b.Parent.Name)
			end
		end)
		
		RunService.Heartbeat:Connect(function()
			if workspace.HostKitActive.Comps:FindFirstChild(b.Name) then
				b.BackgroundColor3 = Color3.new(1, 1, 1)
			else b.BackgroundColor3 = Color3.new(0, 0, 0) end
		end)
	end
end

