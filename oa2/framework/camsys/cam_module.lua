-- [ services ] --
local TweenService = game:GetService("TweenService")

-- [ objects ] --
local cutscenes = workspace:WaitForChild("Cutscenes")

-- [ module ] --
local cam = {}

cam.players_loaded = {}

--// sets camera state to new state
function cam.camera_state(s:string)
	
	local cc = workspace.CurrentCamera
	
	repeat cc.CameraType = Enum.CameraType[s]
	until cc.CameraType == Enum.CameraType[s]

end

--// activates or deactivates wallpaper
function cam.wallpaper(gui, toggle:string)
	
	local container = {
		["on"] = {0, {1, 1.6, 2}},
		["off"] = {1, {2, 1.6, 1}}
	}
	
	TweenService:Create(gui.Container, TweenInfo.new(container[toggle][2][1], Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Transparency = container[toggle][1]}):Play()
	TweenService:Create(gui.Container.Vignette, TweenInfo.new(container[toggle][2][2], Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {ImageTransparency = container[toggle][1]}):Play()
	TweenService:Create(gui.Container.Icon, TweenInfo.new(container[toggle][2][3], Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {ImageTransparency = container[toggle][1]}):Play()

end

--// starts cutscene for player
function cam.scene_play(gui, cs:string)
	
	local cc = workspace.CurrentCamera
	local scene = workspace.Cutscenes[cs]
	
	cam.camera_state("Scriptable")
	cam.wallpaper(gui, "on")
		wait(2)
	table.insert(cam.players_loaded, game.Players.LocalPlayer)
	
	while #cam.players_loaded < #game.Players:GetPlayers() do
		wait()
	end
	
	cc.CFrame = scene["View1"].CFrame
	cam.wallpaper(gui, "off")
	
	for i = 1, #scene:GetChildren(), 1 do
		local v = scene["View" .. i]
		local speed, del = v.Speed.Value, v.Delay.Value

		TweenService:Create(
			cc, 
			TweenInfo.new(speed, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
			{CFrame = v.CFrame}
		):Play()
		
		wait(speed + del)
	end
	
	cam.wallpaper(gui, "on")
		wait(2)
	cam.camera_state("Custom")
	cam.wallpaper(gui, "off")
	cam.players_loaded = {}
	
end

return cam