local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Guis = ReplicatedStorage:WaitForChild("Guis")

local Printer = require(Common.Printer)

local TEST_MESSAGE = "TEST/Info:  Waiting.. "
local TEST_WAIT_TIME = 2

local testPrinters = {}

return function(signal)
    -- phase 1 create instance of class
    local testConfig = {
        "crockpoti", -- player
        "printer", -- type of
        "Bronze", -- rank
        Color3.fromRGB(1, 1, 1) -- color
    }

    local testInstance = table.insert(testPrinters, Printer.new(table.unpack(testConfig)))

    print(TEST_MESSAGE, "Created Class.", testInstance)

    task.wait(TEST_WAIT_TIME)

    -- phase 2 for each instance in test printers use spawn method and get position
	local function testPrinterPositions()
        for testInstIndex, testInst in testPrinters do
            testInst:spawn()

            -- phase 3 testing ui for instance
            -- this function sends to all clients the gui for the printer instance
            local function firePrinterUi()
                for _, player in pairs(Players:GetPlayers()) do
                    local objectGuiClone = Guis:FindFirstChild("PrinterBillboardGui"):Clone()
                    objectGuiClone.Adornee = testInst:getObject()
                    objectGuiClone.Parent = player.PlayerGui
            
                    local testInstInfo = testInst:getInfo()
                    local rankLabel = objectGuiClone:FindFirstChild("Rank", true)
                    rankLabel.Text = testInstInfo.rank
                    rankLabel.TextColor3 = testInstInfo.color3
                end
            end
        
            firePrinterUi()

            -- phase 4 this tests our stats being added and destroying of our printer instance
            local countForDestroyTest = 0
            task.spawn(function()
                while testInst do
                    task.wait(0.9)

                    testInst:adjustStats("xp", "level")

                    print(testInst:getInfo())

                    countForDestroyTest += 1
                    if countForDestroyTest == 10 then
						testInst:dealDamage(100)
						testInst = nil
						testPrinters[testInstIndex] = nil
						break 
                    end
                end
            end)

            task.delay(1, function()
                local instanceObject = testInst:getObject()
                print(TEST_MESSAGE, "Called Spawn Method. Fetching instance object..", instanceObject.Position)
            end)
        end
    end

    testPrinterPositions()

    task.wait(TEST_WAIT_TIME)
end