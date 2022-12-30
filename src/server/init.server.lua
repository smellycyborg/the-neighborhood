local Sdk = require(script.Sdk)

local options = {
    defaultSchema = {
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
