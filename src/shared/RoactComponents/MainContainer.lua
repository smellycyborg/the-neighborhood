local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)
local Janitor = require(Common.Janitor)
local Comm = require(Common.Comm)
local signals = require(Common._signals)
local Screen = require(Common.Enums.Screen)

local RoactComponents = script.Parent
local ButtonList = require(RoactComponents.ButtonList)
local ShopScreen = require(RoactComponents.ShopScreen)
local MenuTitle = require(RoactComponents.MenuTitle)
local CloseButton = require(RoactComponents.CloseButton)
local Notification = require(RoactComponents.Notification)

local clientComm = Comm.ClientComm.new(ReplicatedStorage, false, "MainComm")
local getShopItemsInfo = clientComm:GetFunction("GetShopItemsInfo")
local BuyShopItem = clientComm:GetFunction("BuyShopItem")

local NOTIFICATION_DISPLAY_TIME = 5

local MainContainer = Roact.Component:extend("MainContainer")

function MainContainer:init()
	self.state = {
		currentScreen = nil,
		shopItemsInfo = {},
		message = nil, -- for notification
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
end

function MainContainer:didMount()

    task.spawn(function()
		local shopItemsInfo = getShopItemsInfo()

		self:setState({ shopItemsInfo = shopItemsInfo })
	end)
end

function MainContainer:didUpdate(oldProps, oldState)
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
		ShopScreen = Roact.createElement(ShopScreen, {
			shopItemsInfo = shopItemsInfo,
			enabled = currentScreen == "Shop",
			onShopItemButtonActivated = self.onShopItemButtonActivated,
		})
	})
end

return MainContainer