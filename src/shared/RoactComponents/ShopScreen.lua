local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)
local Background = require(script.Parent.Background)
local ShopItem = require(script.Parent.ShopItem)

return function(props)
    local shopItemsInfo = props.shopItemsInfo
    local enabled = props.enabled
    local onShopItemButtonActivated = props.onShopItemButtonActivated

    local shopItems = {}
    for index, shopItem in pairs(shopItemsInfo) do
        shopItems[shopItem] = Roact.createElement(ShopItem, {
            cost = shopItem.cost,
            name = shopItem.name,
            image = shopItem.image,
            color = shopItem.color,
            layoutOrder = shopItem.layoutOrder,
            onShopItemButtonActivated = onShopItemButtonActivated,
            buttonName = index,
        })
    end

    return Roact.createElement(Background, {
        size = UDim2.fromScale(0.7, 0.48),
        sizeConstraint = Enum.SizeConstraint.RelativeYY,
        color = Color3.fromRGB(27, 113, 93),
        enabled = enabled,
    }, {
        Background = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.975, 0.975),
            BackgroundColor3 = Color3.fromRGB(163, 162, 165),
        }, {
            UIGridLayout = Roact.createElement("UIGridLayout", {
                CellPadding = UDim2.fromScale(0.022, 0.05),
                CellSize = UDim2.fromScale(0.3, 0.43),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            ShopItems = Roact.createFragment(shopItems),
        })
    })
end