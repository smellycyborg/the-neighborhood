local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Comm = require(Common.Comm)
local Roact = require(Common.Roact)
local Sift = require(Common.Sift)

local serverComm = Comm.ServerComm.new(ReplicatedStorage, "MainComm")

local Sdk = {
    _playerData = {},
    _playerDataStore = DataStoreService:GetDataStore("PlayerData"),
    _workspaceItems = {},
}

local function characterAdded(character)
    
end

local function playerAdded(player)
    local DEFAULT_SCHEMA = Sdk._defaultSchema

    local playerData
    local success, data = pcall(function()
        return Sdk._playerDataStore:GetAsync(player.UserId)
    end)

    if success then
        if data ~= nil then
                playerData = data
        else
            playerData = DEFAULT_SCHEMA
        end
    else
	playerData = DEFAULT_SCHEMA
end

    Sdk._playerData[player] = playerData
end

local function playerRemoving()
    local playerData = Sdk._playerData[player]

	local success, err = pcall(function()
        -- save player data
        self._playerDataStore:SetAsync(string.format("Player_%d", player.UserId), playerData)
    end)

    if (err) then
        warn(err)
    end

    repeat
        task.wait()
    until success

    Sdk._playerData[player] = nil
end

local function onBuyItemFunc(player, item)
    local playerData = Sdk._playerData[player]
    local itemData = ItemsData[item]
    local itemCost = itemData.cost
    local playerMoney = playerData.money 

    local canBuy = playerMoney > itemCost
    local message = canBuy and "Thank you for your purchase!" or "You need more money!"

    if canBuy then
        Sdk:decreaseValue(player, "money", itemCost)
    end

    return message
end

local function onDropItemEvent(_player, item, itemData)
    local item = ReplicatedStorage.Items:FindFirstChild(item)
    if not item then
        warn("MESSAGE/Warning:  Could not find ", item, " in Replicated Storage.")
        return
    end

    local function onPromptTriggered(player)
        local tool = ReplicatedStorage.Tools:FindFirstChild(item)
        
        local toolClone = tool:Clone()
        toolClone.Name = item
        toolClone.Parent = player.Backpack

        itemClone:Destroy()

        if itemData.money then
            Sdk:incrementValue(player, "money", itemData.money)
        end

        Sdk:removeFromWorkspace(item)
    end

    itemClone = item:Clone()
    itemClone.Name = item
    item.Parent = workspaceItems

    Sdk:addToWorkspace(item, itemData)

    local prompt = Instance.new("ProximityPrompt")
    prompt.Parent = itemClone

    prompt.Triggered:Connect(onPromptTriggered)
end

function Sdk.init(options)

    sdk._defaultSchema = options.defaultSchema

    -- folders
    workspaceItems = Instance.new("Folder")
    workspaceItems.Name = "WorkspaceItems"
    workspaceItems.parent = workspace

    -- remote events
    dropItemEvent = serverComm:CreateSignal("DropItemEvent")

    -- remote functions
    serverComm:BindFunction("BuyItemFunction", onBuyItemFunc)

    -- bindings
    dropItemEvent:Connect(onDropItemEvent)
    Players.PlayerAdded:Connect(playerAdded)
    Players.PlayerRemoving:Connect(playerRemoving)

end

function Sdk:incrementValue(player, key, amount)
    self._playerData[player][key]+=amount
end

function Sdk:decreaseValue(player, key, amount)
    self._playerData[player][key]-=amount
end

function Sdk:addToWorkspace(item, itemData)
    self._workspace[item] = itemData
end

function Sdk:removeFromWorkspace(item)
    self._workspace[item] = nil
end

return Sdk