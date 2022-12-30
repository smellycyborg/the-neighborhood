local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Comm = require(Common.Comm)
local Sift = require(Common.Sift)

local Sdk = {
    _playerData = {},
    _playerDataStore = DataStoreService:GetDataStore("PlayerData"),
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

function Sdk.init(options)

    sdk._defaultSchema = options.defaultSchema

    Players.PlayerAdded:Connect(playerAdded)
    Players.PlayerRemoving:Connect(playerRemoving)

end

return Sdk