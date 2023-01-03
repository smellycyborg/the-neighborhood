local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)

local MainContainer = require(script.Parent.MainContainer)

return function(target)
	local roactTree = Roact.mount(Roact.createElement(MainContainer), target)

	return function()
		Roact.unmount(roactTree)
	end
end
