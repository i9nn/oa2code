-- [ services ] --
local Players, ReplicatedStorage = game:GetService("Players"), game:GetService("ReplicatedStorage")

-- [ objects ] --
--[[ TODO: build game using structure provided: 

    - StarterGui
    ScreenGui LagSystem:
        Frame Container:
            Frame Buttons:
                TextButtons 1-5
            TextButton TextureToggle

    - Workspace
    Folder LagMode

    - ReplicatedStorage
    Folder LagModeStorage

]]--

local lag_update = ReplicatedStorage:FindFirstChild("LagUpdate", true)
local lagm, lagm_storage = workspace.LagMode, ReplicatedStorage.LagModeStorage

local cont = script.Parent.Container
local buttons, texture_tog = cont.Buttons, cont.TextureToggle

-- [ variables ] --
local textures = false

-- [ functions ] --

--// Edits all existing + new lag layers according to player presets 
local function update_lag(group, lev)
    if group == "Objects" then
        for i = 1, lev, 1 do 
            if not (lagm:FindFirstChild(tostring(i)) then
                lagm_storage[tostring(i)]:Clone().Parent = lagm

                if textures == false then
                    for _, t in pairs (lagm[tostring(i)]:GetDescendants()) do 
                        if t:IsA("Decal") or t:IsA("Texture") then
                            t.Enabled = false
                        end
                    end
                end
            end
        end

        for _, l in pairs (lagm:GetChildren()) do 
            if tonumber(l.Name) > lev then
                l:Destroy()
            end
        end
    else if group == "Textures" then
        for _, t in pairs (lagm:GetDescendants()) do 
            if t:IsA("Decal") or t:IsA("Texture") then
                t.Enabled = lev
            end
        end 
    end
end

--// Sends data to server when lag data is edited on client 
for _, b in pairs (buttons:GetChildren()) do 
    b.MouseButton1Up:Connect(function()
        lag_update:FireServer("ObjectsToggle", tonumber(b.Name))
        update_lag("Objects", tonumber(b.Name))
    end)
end

--// Toggles textures according to mouse button input
texture_tog.MouseButton1Up:Connect(function()
    if textures == false then
        texture_tog.Color = Color3.fromRGB(94, 247, 112); texture_tog.Text = "TEXTURES: ON"
    else 
        texture_tog.Color = Color3.fromRGB(247, 104, 94); texture_tog.Text = "TEXTURES: OFF"
    end
    textures = not textures 

    lag_update:FireServer("TextureToggle", textures)
end)


