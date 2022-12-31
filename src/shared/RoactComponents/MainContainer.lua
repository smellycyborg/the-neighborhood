local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Roact = require(Common.Roact)
local Janitor = require(Common.Janitor)
local Comm = require(Common.Comm)
local Screen = require(Common.Enums.Screen)

local RoactComponents = script.Parent
local ButtonList = require(RoactComponents.ButtonList)

local clientComm = Comm.ClientComm.new(ReplicatedStorage, false, "MainComm")
local setPlayerStepsLabelColor = clientComm:GetSignal("SetPlayerStepsLabelColor")

local MainContainer = Roact.Component:extend("MainContainer")

function MainContainer:init()
	self.state = {
		currentScreen = nil,
	}

	self._janitor = Janitor.new()

	self.onButtonActivated = function(rbx)
		self:setState({currentScreen = currentScreen == rbx.Name and Roact.None or rbx.Name})
	end
end

function MainContainer:didMount()
    
end

function MainContainer:willUnmount()
	self._janitor:Destroy()
end

function MainContainer:render()
	local currentScreen = self.state.currentScreen

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		ButtonList = Roact.createElement(ButtonList, {
			buttonNames = { Screen.Shop, Screen.Settings, Screen.GamePasses, Screen.Tips },
			onButtonActivated = self.onButtonActivated,
		}),
	})
end

return MainContainer