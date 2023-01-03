local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Roact = require(Common.Roact)

local RoactComponents = script.Parent
local MenuButton = require(RoactComponents.MenuButton)

local SHOP_IMAGE_ID = "rbxassetid://11988957536"
local SETTINGS_IMAGE_ID = "rbxassetid://11988957403"
local GAME_PASSES_IMAGE_ID = "rbxassetid://11988957192"
local TIPS_IMAGE_ID = "rbxassetid://11988977243"

function ButtonList(props)
	local buttonNames = props.buttonNames

	local buttons = {}
	for _, buttonName in pairs(buttonNames) do

		local buttonImage
		if buttonName == "Shop" then
			buttonImage = SHOP_IMAGE_ID
		elseif buttonName == "Settings" then
			buttonImage = SETTINGS_IMAGE_ID
		elseif buttonName == "GamePasses" then
			buttonImage = GAME_PASSES_IMAGE_ID
		elseif buttonName == "Tips" then
			buttonImage = TIPS_IMAGE_ID
		end

		buttons[buttonName] = Roact.createElement(MenuButton, {
			image = buttonImage,
			buttonName = buttonName,
			onButtonActivated = props.onButtonActivated,
		})
	end

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(0.1, 0.5),
		Position = UDim2.fromScale(0.1, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0.05, 0.05),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
		Buttons = Roact.createFragment(buttons)
	})
end

return ButtonList