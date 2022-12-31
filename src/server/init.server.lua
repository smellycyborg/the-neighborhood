local Sdk = require(script.Sdk)

local options = {
    defaultSchema = {
        health = 100,
        armor = 0,
        money = 0,
        crystals = 0,
        rank = 0,
        properties = {},
        weapons = {},
        printers = {},
        distillers = {},
    },
}

Sdk.init(options)
