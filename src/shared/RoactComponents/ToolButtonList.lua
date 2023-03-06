local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Roact = require(Common.Roact)

local RoactComponents = Common.RoactComponents
local ToolButton = require(RoactComponents.ToolButton)

return function(props)
    local toolInfo = props.toolInfo
    local onToolButtonActivated = props.onToolButtonActivated
    local selected = props.selected
    local countdowns = props.countdowns

    local buttons = {}
    for button, info in pairs(toolInfo) do
        buttons[button] = Roact.createElement(ToolButton, {
            image = info.image,
            countdown = countdowns and countdowns[button],
            onToolButtonActivated = onToolButtonActivated,
            selected = button == selected,
            buttonName = button,
        })
    end

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.9),
		Size = UDim2.fromScale(0.45, 0.125),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
    }, {
        UIListLayout = Roact.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0.05, 0.05),
            FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),
        Buttons = Roact.createFragment(buttons)
    })
end