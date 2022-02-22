-- [ objects ] --
local button = script.Parent

-- [ functions ] --
button.MouseButton1Up:Connect(function()
	if workspace:FindFirstChild("LagMode") then
		workspace.LagMode.Parent = game.ReplicatedStorage
		button.ImageColor3 = Color3.fromRGB(210, 210, 210)
	else
		game.ReplicatedStorage.LagMode.Parent = workspace
		button.ImageColor3 = Color3.fromRGB(50, 50, 50)
	end
end)