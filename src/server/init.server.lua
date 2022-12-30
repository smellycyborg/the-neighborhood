--[[

    jail system
    - 5 minutes jail time

    billboard guis for door mechanics
    - prompt gui appears when player hovers over (or is near on mobile/console) door for lock/unlock option, open/close option

    instructions
    - gives player instructions on how to play the game

    game passes
    #Job - players can buy employment with robux
    #Money
    #Rank
    #Gun duffle bag
    #Hit man 

    distller mechanics
    - buy distillers (put in printer menu)
    - can only hold 4 crystals until explode
    - pick up crystals 
    - have to go sell crystals for money
    - if player leaves distiller destroys

    printer mechancis
    - buy printers (have side button)
    - print levels 
    - printer self upgrades
    - printers money
    - surface gui on printer
    - gamepass to have 10 printers instead of 5
    - if player leaves printers destroy

    basic properties are properties players can buy while they're in the game
    -- gives access to lock doors
    -- other players can't buy property until player owner leaves game

    lockers are inside of properties (check to see if players have locker access, if not they have to buy)
    -- group based
    -- players can pick up guns when they have access to lockers
    -- anyone in the group can buy the property with another group memebers approval

    players hve option to buy their stuff back on death
    -- can turn off option in settings

    Weapons
    - 2 pump shotgun
    - spaz shotgun
    - pistol
    - ar
    - sub machine
    - knife
    - machete

    #Settings
    -- turn off options on respawn
    -- low quality performance or high quality performance

]]

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
