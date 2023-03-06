local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DEFAULT_MODEL_TYPE = "printer"
local DISTANCE_THRESHOLD = 10
local DEFAULT_HEALTH_DAMAGE = 33.3
local FALLBACK_POSITION = Vector3.new(5, 5, 5)

local printer = {}
local printerPrototype = {}
local printerPrivate = {}

local modelCache = {}

local function _getCloneModel(modelName)
    if not modelCache[modelName] then
        modelCache[modelName] = ReplicatedStorage:FindFirstChild(modelName)
    end

    return modelCache[modelName]
end

local function _calculateCurrencyToAdd(private)
    return private.level * private.multiplier + private.amountToAdd
end

local function _getCharacterPosition(player)
    local character = player.Character
    if not character then
        warn("Character does not exist.")
       return 
    end

    -- Todo research character positon..  cuz might use cframe
    return player.Character.HumanoidRootPart.Position
end

local function _printerCheck(player, private)
    local rootPartPosition = _getCharacterPosition(player)
    if not rootPartPosition then
        warn("MESSAGE/Warn:  Could not get character positon.")

        return
    end

    local instancePosition = private.object.Position
    local playerCameraPosition = player.Camera.CFrame.Position

    local distance = (rootPartPosition - private.object.Position).Magnitude

    local instanceObject = private.object

    if distance > DISTANCE_THRESHOLD then
        return false
    end

    local ray = Ray.new(playerCameraPosition, (instancePosition - playerCameraPosition).Unit * distance)
    local part, hitPosition = workspace:FindPartOnRayWithWhitelist(ray, {instanceObject})

    return part == instanceObject
end

local function _destroy(self)
    local private = printerPrivate[self]
    
    private.object:Destroy()
    printerPrivate[self] = nil
end

function printer.new(player: Player, typeOf: string, rank: string, color3: Color3)
    assert(player, "argument 1 missing or nil")
    assert(typeOf, "argument 2 missing or nil")
    assert(rank, "argument 3 missing or nil")
    assert(color3, "argument 4 missing or nil")

    local instance = {}
    local private = {}

    private.owner = player
    private.typeOf = typeOf or DEFAULT_MODEL_TYPE
    private.xp = 0
    private.level = 1
    private.health = 100
    private.rank = rank
    private.color3 = color3

    printerPrivate[instance] = private

    return setmetatable(instance, printerPrototype)
end

function printerPrototype:getInfo()
    local private = printerPrivate[self]

    return {
        owner = private.owner,
        xp = private.xp,
        level = private.level,
        health = private.health,
        rank = private.rank,
        color3 = private.color3,
    }
end

function printerPrototype:spawn() 
    local private = printerPrivate[self]

    local model = _getCloneModel(private.typeOf) or _getCloneModel(DEFAULT_MODEL_TYPE)

    local clone = model:Clone()
    clone.Position = _getCharacterPosition(private.owner) or FALLBACK_POSITION
    clone.Parent = workspace

    private.object = clone
end

function printerPrototype:adjustStats(...)
    local private = printerPrivate[self]

    local stats = {...}
    for _, stat in stats do
        if stat == "xp" then
            private.xp+=1

            if private.xp ~= 100 then
               continue
            end

            private.xp = 0
        elseif stat == "currency" and private.xp == 42 then
            private.currency += _calculateCurrencyToAdd(private)
        end
    end

    print("MESSAGE/Info:  We've made adjustments to .. ", private)
end

function printerPrototype:boost()
    local private = printerPrivate[self]

    local isPrinter = _printerCheck(player, private)
    if not isPrinter then
        print("MESSAGE/Info:  This is not the right printer.")
        return nil
    end

    if not private.multiplier then
        private.multiplier = 1.1
        
        return
    end

    private.multiplier+=0.1

    print("MESSAGE/Info:  We've boosted printer .. multiplier:  ", private.multiplier)
end

function printerPrototype:getPrint(player)
    local private = printerPrivate[self]

    local isPrinter = _printerCheck(player, private)
    if not isPrinter then
        print("MESSAGE/Info:  This is not the right printer.")
        return nil
    end

    local currency = private.currency

    private.currency = 0

    return currency
end

function printerPrototype:dealDamage(damage)
    local private = printerPrivate[self]

    private.health -= damage or DEFAULT_HEALTH_DAMAGE

    if private.health <=0 then
        _destroy(self)
    end
end

function printerPrototype:getObject()
    assert(printerPrivate[self].object, "Object does not exit yet.")

    local private = printerPrivate[self]

    return private.object
end

-- Todo decide on ui handle for print and boost

printerPrototype.__index = printerPrototype
printerPrototype.__metatable = "This metatable is locked."

return printer