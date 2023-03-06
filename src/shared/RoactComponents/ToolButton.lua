local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Common = ReplicatedStorage:WaitForChild("Common")
local Sounds = ReplicatedStorage:WaitForChild("Sounds")

local Roact = require(Common.Roact)

local Countdown = require(script.Parent.Countdown)

local TWEEN_TIME = 0.25
local DEFAULT_SIZE = UDim2.fromScale(0.3, 0.9)
local GOAL_SIZE = UDim2.fromScale(0.3 / 0.9, 0.9 / 0.9)

local sound = Sounds.ButtonSound

local tweenGoal = {}
tweenGoal.Size = GOAL_SIZE

local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear)

return function(props)
    local image = props.image
    local countdown = props.countdown
    local buttonName = props.buttonName
    local onToolButtonActivated = props.onToolButtonActivated
	
	local size = not props.selected and DEFAULT_SIZE or GOAL_SIZE
	local tweenStart = {Size = size}

    return Roact.createElement("Frame", {
        AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(27, 113, 93),
		Size = size,
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
					if not onToolButtonActivated then
						return
					end
	
                    local soundClone = sound:Clone()
                    soundClone.Parent = Players.LocalPlayer.Character
                    
                    soundClone:Play()
                    soundClone.Ended:Wait()
                    soundClone:Destroy()

					props.onToolButtonActivated(buttonName, ...)
				end,
				[Roact.Event.MouseEnter] = function(rbx)
					local onMouseEnterTween = TweenService:Create(rbx.Parent.Parent, tweenInfo, tweenGoal)
					onMouseEnterTween:Play()
				end,
				[Roact.Event.MouseLeave] = function(rbx)
					local onMouseLeaveTween = TweenService:Create(rbx.Parent.Parent, tweenInfo, tweenStart)
					onMouseLeaveTween:Play()
				end,
			}),
		}),

		Countdown = countdown and Roact.createElement(Countdown, {
			countdown = countdown,
			enabled = countdown ~= 0,
		})
    })
end