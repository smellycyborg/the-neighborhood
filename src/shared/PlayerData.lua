local DataStoreService = game:GetService("DataStoreService")

local PlayerData = {
    _playerData = {},
    _playerDataStore = DataStoreService:GetDataStore("PlayerData"),
}

function PlayerData:createData(player)
    local DEFAULT_SCHEMA = self._defaultSchema

    local playerData
    local success, data = pcall(function()
        return self._playerDataStore:GetAsync(player.UserId)
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

    self._playerData[player] = playerData

    warn("MESSAGE/Info:  This is the data that is being set..", playerData)
end

function PlayerData:removeData(player)
    local playerData = self._playerData[player]

    warn("MESSAGE/Info:  This is the data that is being set..", playerData)

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

    self._playerData[player] = nil
end

function PlayerData:incrementValue(player, key, amount)
    self._playerData[player][key]+=amount
end

function PlayerData:decreaseValue(player, key, amount)
    self._playerData[player][key]-=amount
end

function  PlayerData:setValue(player, key, value)
    self._playerData[player][key] = value
end

function PlayerData:pushValue(player, key, value)
    table.insert(self._playerData[player][key], value)
end

function PlayerData:removeValue(player, key, value)
    local valueIndex = table.find(self._playerData[player][key][value])
    table.remove(self._playerData[player][key], valueIndex)
end

return PlayerData