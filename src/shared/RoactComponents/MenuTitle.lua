local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)

return function(props)
    local title = props.title
    local enabled = props.enabled

    return Roact.createElement("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.2),
        Size = UDim2.fromScale(0.5, 0.1),
        BackgroundTransparency = 1,
        TextScaled = true,
        TextColor3 = Color3.fromRGB(255, 24, 136),
        Font = Enum.Font.FredokaOne,
        Text = title,
        Visible = enabled,
    }, {
        UIStroke = Roact.createElement("UIStroke", {
            Thickness = 3,
        })
    })
end