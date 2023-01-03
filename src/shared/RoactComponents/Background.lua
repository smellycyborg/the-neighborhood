local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Roact = require(Common.Roact)

local DEFAULT_POSITION = UDim2.fromScale(0.5, 0.5)
local DEFAULT_COLOR = Color3.new(1, 1, 1)
local DEFAULT_SIZE_CONSTRAINT = Enum.SizeConstraint.RelativeXY
local DEFAULT_BORDER_PIXEL = 0

function Background(props)
    local color = props.color
    local position = props.position
    local size = props.size
    local cornerRadius = props.cornerRadius
    local sizeConstraint = props.sizeConstraint
    local borderSizePixel = props.borderSizePixel
    local layoutOrder = props.layoutOrder
    local enabled = props.enabled

    if not position then
        position = DEFAULT_POSITION
    end

    if not color then
        color = DEFAULT_COLOR
    end

    if not sizeConstraint then
        sizeConstraint = DEFAULT_SIZE_CONSTRAINT
    end

    if not BorderSizePixel then
        borderSizePixel = DEFAULT_BORDER_PIXEL
    end

    if not layoutOrder then
        layoutOrder = 0
    end

    if enabled == nil then
        enabled = true
    end

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color,
        BorderSizePixel = borderSizePixel,
        Position = position,
        Size = size,
        SizeConstraint = sizeConstraint,
        LayoutOrder = layoutOrder,
        Visible = enabled,
    }, {
        UICorner = Roact.createElement("UICorner", {
            CornerRadius = cornerRadius,
        }),
        Children = Roact.createFragment(props[Roact.Children])
    })
end

return Background