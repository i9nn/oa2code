-- [ services ] --
local TweenService = game:GetService("TweenService")

-- [ objects ] --
local model = script.Parent
local button, door, sign, exit = model.Button, model.Door, model.Sign, model.Exit
local hinge = door.PrimaryPart
local tl = sign:FindFirstChild("TextLabel", true)

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

button.Out.ClickDetector.MouseClick:Connect(function(plr)
	if tl.Text == "" and debounce == true then
		tl.Text = plr.Name:upper()
			wait()
		door_loop()
	elseif tl.Text == plr.Name:upper() then
		tl.Text = ""
	end
end)

exit.Out.ClickDetector.MouseClick:Connect(function(plr)
	if tl.Text == plr.Name:upper() then
		door_loop()
		debounce = true 
	end
end)


