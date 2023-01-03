local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Common = ReplicatedStorage:WaitForChild("Common")

local PlayerData = require(Common.PlayerData)
local Comm = require(Common.Comm)
local Roact = require(Common.Roact)
local Sift = require(Common.Sift)
local Janitor = require(Common.Janitor)
local signals = require(Common._signals)
local ShopItems = require(Common.ShopItems)
local ObjectHandler = require(Common.ObjectHandler)

local isServer = RunService:IsServer()

local serverComm = Comm.ServerComm.new(ReplicatedStorage, "MainComm")

local Sdk = {
    _workspaceItems = {},
    _playerConnections = {},
}

local function characterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    local humanoid = character:FindFirstChild("Humanoid")

    Sdk._playerConnections[player] = {}
    Sdk._playerConnections[player]._janitor = Janitor.new()

    PlayerData._playerData[player].health = humanoid.Health

    local function onHealthChanged(newHealth)
        if newHealth == 0 then
            return
        end

        local oldHealth = PlayerData._playerData[player].health
        local isIncrement = oldHealth < newHealth
        if isIncrement then
            return
        end
        
        local amountChanged = math.floor(oldHealth - newHealth)

        PlayerData:setValue(player, "health", newHealth)

        for _, plr in pairs(Players:GetPlayers()) do
            sendValueChangedGuiEvent:Fire(plr, {
                character = character, 
                amount = amountChanged, 
                isIncrement = isIncrement,
                imageType = "health",
            })
        end
    end

    local function onDied()
		Sdk._playerConnections[player]._janitor:Cleanup()
	end

	Sdk._playerConnections[player]._janitor:Add(humanoid.HealthChanged:Connect(onHealthChanged))
	Sdk._playerConnections[player]._janitor:Add(humanoid.Died:Connect(onDied))

    print("MESSAGE/Info:  character has been added..")
end

local function characterRemoving(character)
    local player = Players:GetPlayerFromCharacter(character)

    Sdk._playerConnections[player]._janitor:Destroy()
    Sdk._playerConnections[player] = nil
end

local function playerAdded(player)
    PlayerData:createData(player)

    -- bindings
    player.CharacterAdded:Connect(characterAdded)
    player.CharacterRemoving:Connect(characterRemoving)
end

local function playerRemoving(player)
    PlayerData:removeData(player)
end

local function onBuyShopItem(player, item)
    local playerData = PlayerData._playerData[player]
    local itemData = ShopItems[item]
    local itemCost = itemData.cost
    local playerMoney = playerData.money 

    local canBuy = playerMoney > itemCost
    local message = canBuy and "Thank you for your purchase!" or "You need more money!"

    -- this chunk is for testing purpsoes only
    if isServer then
        canBuy = true
    end

    if canBuy then
        PlayerData:decreaseValue(player, "money", itemCost)

        local character = player.Character
        if not character then
            return
        end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then
            return
        end

        local position = character:FindFirstChild("HumanoidRootPart").Position

        local objectData = {
            player = player,
            itemData = itemData,
            position = position,
        }

        ObjectHandler:spawnObject(objectData)
    end

    return message
end

local function onGetShopItemsInfo()
    return require(Common.ShopItems)
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
            PlayerData:incrementValue(player, "money", itemData.money)
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

local function onPlayerPressedBillboardButton(player, buttonName, objectValue)
    signals.playerPressedButtonSignal:Fire({ player = player, name = buttonName, object = objectValue })
end

local function updateBillboardGui(billboardGui, objectData) 
    for _, element in pairs(billboardGui:GetDescendants()) do
        if element.Name == "Money" and element:IsA("TextLabel") then
            element.Text = ("money: " .. objectData.currency)
        elseif element == "LevelTitle" and element:IsA("TextLabel") then
            element.Text = ("level " .. tostring(objectData.level))
        elseif element.Name == "LevelStat" and element:IsA("Frame") then
            element:TweenSize(UDim2.fromScale(objectData.xp / objectData.xpToNextLevel, 1))
        elseif element.Name == "MoneyStat" and element:IsA("Frame") then
            element:TweenSize(UDim2.fromScale(objectData.timeAdded / objectData.timeUntilPrint, 1))
        elseif element.Name == "MoneyTitle" and element:IsA("TextLabel") then
            element.Text = tostring(math.floor(objectData.timeAdded / objectData.timeUntilPrint * 100)) .. "%"
        end
    end
end

local function updateBillboardGuis(player)
    for _, billboardGui in pairs(player.PlayerGui:GetChildren()) do
        if not billboardGui:IsA("BillboardGui") then
            continue
		end
		
		local object = billboardGui.Adornee
		local objectData = ObjectHandler:getObjectData(object)
		if not objectData then
			continue
		end
        
        updateBillboardGui(billboardGui, objectData)
    end         
end

function Sdk.init(options)

    PlayerData._defaultSchema = options.defaultSchema

    -- folders
    workspaceItems = Instance.new("Folder")
    workspaceItems.Name = "WorkspaceItems"
    workspaceItems.Parent = workspace
    local printersFolder = Instance.new("Folder")
    printersFolder.Name = "Printers"
    printersFolder.Parent = workspace
    local crystallersFolder = Instance.new("Folder")
    crystallersFolder.Name = "Crystallers"
    crystallersFolder.Parent = workspace

    -- remote events
    dropItemEvent = serverComm:CreateSignal("DropItemEvent")
    sendValueChangedGuiEvent = serverComm:CreateSignal("ValueChangedGuiEvent")
    local playerPressedBillboardButton = serverComm:CreateSignal("PlayerPressedBillboardButton")

    -- remote functions
    serverComm:BindFunction("BuyShopItem", onBuyShopItem)
    serverComm:BindFunction("GetShopItemsInfo", onGetShopItemsInfo)

    -- bindings
    dropItemEvent:Connect(onDropItemEvent)
    playerPressedBillboardButton:Connect(onPlayerPressedBillboardButton)  -- remove event for player pressing button that is a descendant of billboard gui
    Players.PlayerAdded:Connect(playerAdded)
    Players.PlayerRemoving:Connect(playerRemoving)

    while task.wait() do
        for _, player in pairs(Players:GetPlayers()) do
            updateBillboardGuis(player)
        end
    end
end

function Sdk:addToWorkspace(item, itemData)
    self._workspace[item] = itemData
end

function Sdk:removeFromWorkspace(item)
    self._workspace[item] = nil
end

return Sdk