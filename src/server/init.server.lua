local Sdk = require(script.Sdk)

local options = {
    defaultSchema = {
        health = 100,
        armor = 0,
        money = 0,
        crystals = 0,
        rank = 0,
        properties = {},
        weapons = {
            hammer = {},
            dagger = {},
            bazooka = {},
        },
        printers = {},
        distillers = {},
    },
}

Sdk.init(options)
