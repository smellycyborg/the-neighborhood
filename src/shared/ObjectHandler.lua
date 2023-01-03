local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Common = ReplicatedStorage:WaitForChild("Common")

local PlayerData = require(Common.PlayerData)
local ShopItems = require(Common.ShopItems)
local signals = require(Common._signals)

local ObjectHandler = {
    _objects = {},
}

signals.playerPressedButtonSignal:Connect(function(args)
    ObjectHandler:handleButtonPress(args)
end)

local function getFolder(objectType)
    local objectFolder
    if objectType == "printer" then
        objectFolder = "Printers"
    elseif objectType == "crystaller" then
        objectFolder = "Crytallers"
    end
    return objectFolder
end

local function getStat(name)
    local stat
    if name == "Print" then
        stat = "money"
    elseif name == "Pull" then
        stay = "crystals"
    end
    return stat
end

local function getGui(objectType)
    local gui
    if objectType == "printer" then
        gui = ReplicatedStorage.Guis["PrinterBillboardGui"]
    elseif objectType == "crystaller" then
        gui = nil
    end
    return gui
end

local function getCategory(objectType)
    local category 
    if objectType == "printer" then
        category = "printers"
    elseif objectType == "crystaller" then
        objectType = "crystallers"
    end
    return category
end

local function initButton(button, handler, args)
    button.MouseButton1Up:Connect(
        handler(args)
    )
end

function ObjectHandler:takeCurrency(player, name, object)
    local currency = self._objects[object].currency

    self._objects[object].currency = 0
end

function ObjectHandler:handleButtonPress(args)
    local player = args.player
    local name = args.name
    local object = args.object

    local stat = getStat(name)
    local currency = ObjectHandler:getCurrency(object)

    if name == "Print" or name == "Pull" then
        ObjectHandler:takeCurrency(player, name, object)
    elseif name == "Boost" then
        ObjectHandler:upgradePrinter()
    end

    PlayerData:incrementValue(player, stat, currency)
end

function ObjectHandler:getObjectData(object)
    return self._objects[object]
end

function ObjectHandler:getOwner(object)
    return self._objects[object].owner
end

function ObjectHandler:getType(object)
    return self._objects[object].type
end

function ObjectHandler:getCode(object)
    return self._objects[object].code
end

function ObjectHandler:getCurrency(object)
    return self._objects[object].currency
end

function ObjectHandler:spawnObject(args)
    local player = args.player
    local itemData = args.itemData
    local position = args.position

    local objectType = itemData.objectType
    local objectFolder = getFolder(objectType)

    local objectClone = ReplicatedStorage[objectType]:Clone()
    objectClone.Position = position
    objectClone.Anchored = true
    objectClone.Parent = workspace[objectFolder]

    self._objects[objectClone] = {}
    self._objects[objectClone].owner = player
    self._objects[objectClone].xp = 0
    self._objects[objectClone].xpToNextLevel = 100
    self._objects[objectClone].timeUntilPrint = 45
    self._objects[objectClone].timeAdded = 0
    self._objects[objectClone].level = 1
    self._objects[objectClone].currency = 0
    self._objects[objectClone].currencyToGive = 26
    self._objects[objectClone].type = objectType
    self._objects[objectClone].moneyMultiplier = 1.1
    self._objects[objectClone].hasPrinted = false
    self._objects[objectClone].code = tostring(HttpService:GenerateGUID(true))

    task.spawn(function()
        while task.wait(1) do
            ObjectHandler:statsManager(objectClone)
        end
    end)

    objectClone.Name = self._objects[objectClone].type

    local objectCategory = getCategory(objectType)
    PlayerData:pushValue(player, objectCategory, objectClone)

    for _, player in pairs(Players:GetPlayers()) do
        local objectGuiClone = getGui(objectType):Clone()
        objectGuiClone.Adornee = objectClone
        objectGuiClone.Parent = player.PlayerGui

        local rankLabel = objectGuiClone:FindFirstChild("Rank", true)
        rankLabel.Text = itemData.name
        rankLabel.TextColor3 = itemData.color
    end
end

function ObjectHandler:destroyObject(object)
    local objectType = ObjectHandler:getType(object)
    local objectCode = ObjectHandler:getCode(object)
    local objectData = ObjectHandler:getObjectData(object)

    for _, player in pairs(Players:GetPlayers()) do
        local foundGui = player.PlayerGui:FindFirstChild(objectCode)
        if not foundGui then
            continue
        end

        foundGui:Destroy()
    end
    
    object:Destroy()
    self._objects[object] = nil

    local player = objectData.owner
    PlayerData:removeValue(player, objectType, object)
end

function ObjectHandler:statsManager(objectClone)
    local data = self._objects[objectClone]

    data.xp = data.xp + 1
    data.timeAdded = data.timeAdded + 1

    if data.xp >= data.xpToNextLevel then
        data.level = data.level + 1

        -- puts cap on time until print
        if data.timeUntilPrint >= 30 then
            data.timeUntilPrint-=1
        end
        
        data.xp = data.xp - data.xpToNextLevel
        data.xpToNextLevel = math.ceil(data.xpToNextLevel * 1.35) -- Increase XP needed for next level by 35%

        print("curr level:  " .. data.level .. "  XP needed: " .. data.xpToNextLevel )
    else
        print("need more xp: ", data.xpToNextLevel - data.xp)
    end

    task.spawn(function()
        if data.hasPrinted then
            return
        end

        data.timeAdded = 0
        data.currencyToGive = (math.floor(data.currencyToGive * data.moneyMultiplier))
        data.currency += data.currencyToGive
        data.hasPrinted = true
        warn("Gave printer money ")

        task.wait(data.timeUntilPrint)

        data.hasPrinted = false
    end)
end

return ObjectHandler