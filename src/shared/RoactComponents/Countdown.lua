local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)

return function(props)
    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Visible = props.enabled,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.9, 0.9),
    }, {
        CountdownLabel = Roact.createElement("TextLabel", {
            BackgroundTransparency = 1,
            Rotation = 13,
            Size = UDim2.fromScale(1, 1),
            Font = Enum.Font.FredokaOne,
            Text = props.countdown,
            TextScaled = true,
            TextColor3 = Color3.new(1, 1, 1),
        })
    })
end