local TweenService = game:GetService("TweenService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Roact = require(Common.Roact)

local TWEEN_TIME = 0.25

local tweenStart = {}
tweenStart.Size = UDim2.fromScale(0.08, 0.08)

local tweenGoal = {}
tweenGoal.Size = UDim2.fromScale(0.08 / 0.9, 0.08 / 0.9)

local tweenInfo = TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Linear)

function CloseButton(props)
    local onCloseButtonActivated = props.onCloseButtonActivated
    local enabled = props.enabled

    return Roact.createElement("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.645, 0.22),
        Size = UDim2.fromScale(0.08, 0.08),
        Font = Enum.Font.FredokaOne,
        TextScaled = true,
        TextColor3 = Color3.fromRGB(255, 24, 136),
        Text = "x",
        Visible = enabled,
        [Roact.Event.Activated] = onCloseButtonActivated,
        [Roact.Event.MouseEnter] = function(rbx)
            local onMouseEnterTween = TweenService:Create(rbx, tweenInfo, tweenGoal)
            onMouseEnterTween:Play()
        end,
        [Roact.Event.MouseLeave] = function(rbx)
            local onMouseLeaveTween = TweenService:Create(rbx, tweenInfo, tweenStart)
            onMouseLeaveTween:Play()
        end,
    }, {
        UIStroke = Roact.createElement("UIStroke", {
            Thickness = 3,
        })
    })
end

return CloseButton