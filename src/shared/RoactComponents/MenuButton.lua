local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Common = ReplicatedStorage:WaitForChild("Common")

local Roact = require(Common.Roact)

local TWEEN_TIME = 0.25

local tweenStart = {}
tweenStart.Size = UDim2.fromScale(0.8, 0.175)

local tweenGoal = {}
tweenGoal.Size = UDim2.fromScale(0.8 / 0.9, 0.175 / 0.9)

local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear)

function MenuButton(props)
	return Roact.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(27, 113, 93),
		Size = UDim2.fromScale(0.8, 0.175),
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0.1),
		}),
		ImageHolder = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.9, 0.9),
		}, {
			ImageLabel = Roact.createElement("ImageButton", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.8, 0.8),
				Image = props.image,
				ScaleType = Enum.ScaleType.Fit,
				[Roact.Event.Activated] = function(...)
					if not props.onButtonActivated then
						return
					end
	
					props.onButtonActivated(props.buttonName, ...)
				end,
				[Roact.Event.MouseEnter] = function(rbx)
					local onMouseEnterTween = TweenService:Create(rbx.Parent.Parent, tweenInfo, tweenGoal)
					onMouseEnterTween:Play()
				end,
				[Roact.Event.MouseLeave] = function(rbx)
					local onMouseLeaveTween = TweenService:Create(rbx.Parent.Parent, tweenInfo, tweenStart)
					onMouseLeaveTween:Play()
				end,
			})
		})
	})
end

return MenuButton