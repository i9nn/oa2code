--[[
    Base framework for handling host_kit functions. 
]]--

-- [ service ] --
local Players, RunService = game:GetService("Players"), game:GetService("RunService")

-- [ objects ] --
local HostEvent = game.ReplicatedStorage.HostEvent

-- [ variables ] --
local whitelist = {}

-- [ functions ] --
--// remove gui from players who don't have access
Players.PlayerAdded:Connect(function(plr)
    local gui = plr.PlayerGui.host_kit
    if table.find(whitelist, plr.Name) then
      gui.Enabled = true
    else 
      gui:Destroy())
    end
end)

--// checks host event for any blacklisted players
HostEvent.OnServerEvent:Connect(function(plr, ev)
    if not table.find(whitelist, plr.Name) then
		plr:Kick("Please do not exploit.")
	else
		-- run the code required from said HostEvent
	end
end)

--// check every frame to make sure it's not there
RunService.Heartbeat:Connect(function()
  for _, p in pairs (Players:GetPlayers()) do 
    if p.PlayerGui:FindFirstChild("host_kit") and not table.find(whitelist, plr.Name) then
      p.PlayerGui.host_kit:Destroy()
    end
  end
end)
