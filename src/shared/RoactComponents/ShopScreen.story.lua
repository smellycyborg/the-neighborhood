local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)

local ShopScreen = require(script.Parent.ShopScreen)

return function(target)
	local roactTree = Roact.mount(Roact.createElement(ShopScreen), target)

	return function()
		Roact.unmount(roactTree)
	end
end