local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)
local Background = require(script.Parent.Background)
local CloseButton = require(script.Parent.CloseButton)

return function(props)
    return Roact.createElement(Background, {
        size = UDim2.fromScale(0.6, 0.35),
        sizeConstraint = Enum.SizeConstraint.RelativeYY,
        color = Color3.fromRGB(27, 113, 93),
        enabled = props.enabled,
    }, {
        Background = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.975, 0.975),
            BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        }, {
            NotificationLabel = Roact.createElement("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0.9, 0.3),
                TextScaled = true,
                TextColor3 = Color3.fromRGB(255, 24, 136),
                Font = Enum.Font.FredokaOne,
                Text = props.message,
            }, {
                UIStroke = Roact.createElement("UIStroke", {
                    Thickness = 3,
                })
            }),
            CloseButton = Roact.createElement(CloseButton, {
                onCloseButtonActivated = props.onNotificationCloseButtonActivated,
            })
        })
    })
end