-- [ services ] --
local TweenService = game:GetService("TweenService")

-- [ objects ] --
local model = script.Parent
local door = model.Door
local hinge = door.PrimaryPart

-- [ variables ] --
local debounce = true
local rotate = -100

-- [ functions ] --
function swing()
	TweenService:Create(hinge, TweenInfo.new(1.6, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
		CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(rotate), 0)
	}):Play()
	rotate *= -1
end

function door_loop()
	for i = 1, 2, 1 do
		if debounce == true then
			debounce = false
			swing()

			wait(2)
			debounce = true
		end
	end
end

door.PrimaryPart.Out.ClickDetector.MouseClick:Connect(function(plr)
	if debounce == true then
		door_loop()
    end
end)


 
