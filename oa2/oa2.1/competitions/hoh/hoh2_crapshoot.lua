-- [ objects ] --
local model = script.Parent
local scores, rocks, reset = model.Scores, model.Rocks, model.Reset

-- [ variables ] --
local offset = 0

-- [ functions ] --
for _, r in pairs (rocks:GetChildren()) do 
	r.Touched:Connect(function(hit)
		if hit.Parent:IsA("Tool") and hit.Parent.Name == "Ball" and r.Material == Enum.Material.Metal then 
			r.Material = Enum.Material.Neon
			
			local value = tonumber(r:FindFirstChild("TextLabel", true).Text)
			offset += value
			
			for _, s in pairs (scores:GetChildren()) do 
				local orig = s:FindFirstChild("TextLabel", true)
				orig.Text = tonumber(orig.Text) + value
				
				print(orig.Text, value)
			end
		end
	end)
end

reset.ClickDetector.MouseClick:Connect(function(plr)
	for _, s in pairs (scores:GetChildren()) do 
		local orig = s:FindFirstChild("TextLabel", true)
		orig.Text = tonumber(orig.Text) - offset
	end
	
	for _, r in pairs (rocks:GetChildren()) do 
		r.Material = Enum.Material.Metal
	end
	
	offset = 0 
end)