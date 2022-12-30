--[[

    lockers are inside of properties (check to see if players have locker access, if not they have to buy)
    -- group based
    -- players can pick up guns when they have access to lockers
    -- anyone in the group can buy the property with another group memebers approval

]]

local Sdk = require(script.Sdk)

local options = {
    defaultSchema = {
        money = 0,
        crystals = 0,
        rank = 0,
        lockers = {}, 
    },
}

Sdk.init(options)
