-- [ services ] --
local ts = game:GetService("TweenService") 

-- [ objects ] --
local icon = script.Parent

-- [ functions ] --
while true do
	icon.Rotation = -0 
	ts:Create(icon, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Rotation = 360}):Play() 
	wait(1.7)
end
