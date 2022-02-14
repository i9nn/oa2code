-- [ services ] --
local DataStoreService, Players, ReplicatedStorage = game:GetService("DataStoreService"), game:GetService("Players"), game:GetService("ReplicatedStorage")

-- [ objects ] --
local lag_update = ReplicatedStorage:FindFirstChild("LagUpdate", true)

-- [ stores ] --
local lag_data = DataStoreService:GetDataStore("oa21_lag_data")

-- [ functions ] --
local function save(plr)
    local success, error = pcall(function()
        local save_data = {}

        for _, v in pairs (plr.lag_data:GetChildren()) do 
            save_data[v.Name] = v.Value
        end
        lag_data:SetAsync(plr.UserId, sava_data)
    end)
end

local function store(plr)
    local success, error = save(plr)
    if error then
        print(error); return(error)
    end
end

Players.PlayerAdded:Connect(function(plr)
    local cont = Instance.new("Folder", plr)
    cont.Name = "lag_data";

    local level, texture_tog = Instance.new("IntValue", cont), Instance.new("BoolValue", cont)
    level.Name = "Level"; texture_tog.Name = "TextureToggle"
    level.Value = 1; texture_tog.Value = true 

    local data = lag_data:GetAsync(plr.UserId)
	if data then
		for _, v in pairs (cont:GetChildren()) do
			v.Value = data[v.Name]
		end
	end
end)

lag_update.OnServerEvent:Connect(function(plr, title, value)
    plr.lag_data[title].Value = value
end)

Players.PlayerRemoving:Connect(function(plr)
    store(plr)
end)

game:BindToClose(function()
    for _, plr in pairs (Players:GetPlayers()) do 
        store(plr)
    end
    wait(2)
)