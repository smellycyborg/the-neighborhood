local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Comm = require(Common.Comm)

local clientComm = Comm.ClientComm.new(ReplicatedStorage, false, "MainComm")
local playerPressedBillboardButton = clientComm:GetSignal("PlayerPressedBillboardButton")

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

local function handleBillboardButtons(billboard)
    for _, button in pairs(billboard:GetDescendants()) do
        if not button:IsA("TextButton") then
            continue
        end
        
        button.MouseButton1Up:Connect(function()
            playerPressedBillboardButton:Fire(button.Name)
        end)
    end
end

for _, billboard in pairs(playerGui:GetChildren()) do
    if billboard:IsA("BillboardGui") then
        handleBillboardButtons(billboard)
    end
end

local function onBillboardAdded(billboard)
    if billboard:IsA("BillboardGui") then
        handleBillboardButtons(billboard)
    end
end

playerGui.ChildAdded:Connect(onBillboardAdded)

