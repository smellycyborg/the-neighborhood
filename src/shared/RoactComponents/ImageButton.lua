local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)
local Sift = require(Common.Sift)

function ImageButton(props)
	return Roact.createElement("ImageButton", Sift.Dictionary.mergeDeep(props, {
		Size = UDim2.fromScale(0.85, 1),
		[Roact.Children] = {
			UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 2,
			}),
		}
	}))
end

return ImageButton