local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)
local Janitor = require(Common.Janitor)
local Comm = require(Common.Comm)
local Sift = require(Common.Sift)
local signals = require(Common._signals)
local Screen = require(Common.Enums.Screen)

local RoactComponents = script.Parent
local ButtonList = require(RoactComponents.ButtonList)
local ShopScreen = require(RoactComponents.ShopScreen)
local MenuTitle = require(RoactComponents.MenuTitle)
local CloseButton = require(RoactComponents.CloseButton)
local Notification = require(RoactComponents.Notification)
local ToolButtonList = require(RoactComponents.ToolButtonList)

local clientComm = Comm.ClientComm.new(ReplicatedStorage, false, "MainComm")
local getShopItemsInfo = clientComm:GetFunction("GetShopItemsInfo")
local BuyShopItem = clientComm:GetFunction("BuyShopItem")
local handleToolEvent = clientComm:GetSignal("HandleToolEvent")
local updateCountdownUi = clientComm:GetSignal("UpdateCountdownUi")

local NOTIFICATION_DISPLAY_TIME = 5

local MainContainer = Roact.Component:extend("MainContainer")

function MainContainer:init()
	self.state = {
		currentScreen = nil,
		shopItemsInfo = {},
		message = nil, -- for notification
		toolInfo = {
			bazooka = {
				image = "rbxassetid://12350289279",
			},
			dagger = {
				image = "rbxassetid://12350257919",
			},
			hammer = {
				image = "rbxassetid://12350268893",
			},
		},
		toolSelected = nil,
		countdowns = {
			bazooka = nil,
			dagger = nil,
			hammer = nil,
		},
	}

	self._janitor = Janitor.new()

	self.onButtonActivated = function(rbx)
		self:setState({currentScreen = self.state.currentScreen == rbx and Roact.None or rbx})
	end

	self.onCloseButtonActivated = function()
		self:setState({currentScreen = Roact.None})
	end

	self.onNotificationCloseButtonActivated = function()
		print("should be closing notification")
		self:setState({ message = Roact.None })
	end

	self.onShopItemButtonActivated = function(rbx)
		local message = BuyShopItem(rbx)

		self:setState({ message = message })
	end

	self.onToolButtonActivated = function(rbx)
		self:setState({toolSelected = self.state.toolSelected == rbx and Roact.None or rbx})
		handleToolEvent:Fire(self.state.toolSelected)
	end
end

function MainContainer:didMount()
	self._janitor:Add(updateCountdownUi:Connect(function(timeLeft, toolName)
		self:setState(function(state)
			return {countdowns = Sift.Dictionary.merge(state.countdowns, {[toolName] = timeLeft})}
		end)
	end))

    task.spawn(function()
		local shopItemsInfo = getShopItemsInfo()

		self:setState({ shopItemsInfo = shopItemsInfo })
	end)
end

function MainContainer:didUpdate(_oldProps, oldState)
	if self.state.message and oldState.message ~= self.state.message then
		local message = self.state.message

		task.delay(NOTIFICATION_DISPLAY_TIME, function()
			if message ~= self.state.message then
				-- The notification changed again since this function call
				-- Let the next didUpdate function call handle this logic
				return
			end

			self:setState({ message = Roact.None })
		end)
	end
end

function MainContainer:willUnmount()
	self._janitor:Destroy()
end

function MainContainer:render()
	local currentScreen = self.state.currentScreen
	local shopItemsInfo = self.state.shopItemsInfo
	local message = self.state.message
	local toolInfo = self.state.toolInfo
	local toolSelected = self.state.toolSelected
	local countdowns = self.state.countdowns

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		CloseButton = Roact.createElement(CloseButton, {
			onCloseButtonActivated = self.onCloseButtonActivated,
			enabled = currentScreen ~= nil,
		}),
		MenuTitle = Roact.createElement(MenuTitle, {
			title = currentScreen,
			enabled = currentScreen ~= nil,
		}),
		Notification = Roact.createElement(Notification, {
			message = message,
			onNotificationCloseButtonActivated = self.onNotificationCloseButtonActivated,
			enabled = message ~= nil,
		}),
		ButtonList = Roact.createElement(ButtonList, {
			buttonNames = { Screen.Shop, Screen.Settings, Screen.GamePasses, Screen.Tips },
			onButtonActivated = self.onButtonActivated,
		}),
		ToolButtonList = Roact.createElement(ToolButtonList, {
			toolInfo = toolInfo,
			onToolButtonActivated = self.onToolButtonActivated,
			selected = toolSelected,
			countdowns = countdowns,
		}),
		ShopScreen = Roact.createElement(ShopScreen, {
			shopItemsInfo = shopItemsInfo,
			enabled = currentScreen == "Shop",
			onShopItemButtonActivated = self.onShopItemButtonActivated,
		})
	})
end

return MainContainer