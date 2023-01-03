local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Roact = require(Common.Roact)

local Background = require(script.Parent.Background)

return function(props)
    local cost = props.cost
    local name = props.name
    local image = props.image
    local color = props.color
    local layoutOrder = props.layoutOrder
    local onShopItemButtonActivated = props.onShopItemButtonActivated
    local isOwned = props.isOwned

    local buyText = isOwned and "Owned" or cost

    return Roact.createElement(Background, {
        color = Color3.fromRGB(0, 85, 127),
        cornerRadius = UDim.new(0.12, 0),
        layoutOrder = layoutOrder,
    }, {
        SecondBackground = Roact.createElement(Background, {
            color = Color3.fromRGB(24, 171, 234),
            size = UDim2.fromScale(0.945, 0.945),
            cornerRadius = UDim.new(0.1, 0),
        }, {
            ThirdBackground = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.89, 0.89),
            }, {
                UIListLayout = Roact.createElement("UIListLayout", {
                    Padding = UDim.new(0.045, 0),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
                Title = Roact.createElement("TextLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0.2),
                    Text = name,
                    TextScaled = true,
                    LayoutOrder = 1,
                    Font = Enum.Font.FredokaOne,
                    TextColor3 = color,
                }, {
                    UIStroke = Roact.createElement("UIStroke", {
                        Thickness = 2,
                    })
                }),
                ImageLabel = Roact.createElement("ImageLabel", {
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0),
                    Size = UDim2.fromScale(1, 0.5),
                    Image = image,
                    LayoutOrder = 2,
                    ScaleType = Enum.ScaleType.Fit,
                }),
                ButtonHolder = Roact.createElement("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0),
                    BackgroundColor3 = Color3.fromRGB(73, 157, 43),
                    Size = UDim2.fromScale(0.6, 0.3),
                    LayoutOrder = 3,
                }, {
                    UICorner = Roact.createElement("UICorner", {
    
                    }),
                    Button = Roact.createElement("TextButton", {
                        Size = UDim2.fromScale(1, 0.8),
                        BackgroundColor3 = Color3.fromRGB(0, 255, 43),
                        Text = buyText,
                        TextScaled = true,
                        TextColor3 = Color3.fromRGB(255, 24, 136),
                        Font = Enum.Font.FredokaOne,
                        [Roact.Event.Activated] = function(...)
                            if not props.onShopItemButtonActivated then
                                return
                            end
            
                            props.onShopItemButtonActivated(props.buttonName, ...)
                        end,
                    }, {
                        UICorner = Roact.createElement("UICorner", {
    
                        }),
                        UIStroke = Roact.createElement("UIStroke", {
                            Thickness = 2,
                        })
                    })
                })
            })
        })
    })
end