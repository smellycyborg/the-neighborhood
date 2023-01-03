local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Signal = require(Common.Signal)

return  {
        playerPressedButtonSignal = Signal.new(),
        incrementPlayerStat = Signal.new(),
        sendNotification = Signal.new(),
    }