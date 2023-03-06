local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Common = ReplicatedStorage:WaitForChild("Common")
local Comm = require(Common.Comm)
local Bezier = require(Common.Bezier)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local clientComm = Comm.ClientComm.new(ReplicatedStorage, false, "MainComm")
local activatedToolEvent = clientComm:GetFunction("ActivatedTool")
local sendRocketEvent = clientComm:GetSignal("SendRocketEvent")

local mouse = Players.LocalPlayer:GetMouse()

local NOHANDOUT_ID = 04484494845
local STAB_ID = 12371407888
local TOOL_NONE_ID = 507768375

local stabAnimation = Instance.new("Animation")
stabAnimation.AnimationId = "http://www.roblox.com/asset/?id=" .. STAB_ID

local stabAnimationTrack = character:WaitForChild("Humanoid"):FindFirstChild("Animator"):LoadAnimation(stabAnimation)
stabAnimationTrack.Priority = Enum.AnimationPriority.Action

local toolAnimation = Instance.new("Animation")
toolAnimation.AnimationId = "http://www.roblox.com/asset/?id=" .. TOOL_NONE_ID

local toolAnimationTrack = character:WaitForChild("Humanoid"):FindFirstChild("Animator"):LoadAnimation(toolAnimation)
toolAnimationTrack.Priority = Enum.AnimationPriority.Action

local isEquipped = false

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local function disableDefaultToolAnimation()
    local Animator = character.Animate
    if not Animator then
        return
    end

    local Animation = Instance.new("Animation")
    Animation.AnimationId = "http://www.roblox.com/asset/?id=" .. NOHANDOUT_ID

    local ToolNone = Animator:FindFirstChild("toolnone")
    if ToolNone then
	    local NewTool = Instance.new("StringValue")
	    NewTool.Name = "toolnone"

	    Animation.Name = "ToolNoneAnim"
	    Animation.Parent = NewTool

	    ToolNone:Destroy()

	    NewTool.Parent = Animator
    end
end
disableDefaultToolAnimation()

local function onEquipped()
    isEquipped = true
end

local function onUnequipped()
    isEquipped = false
end

local function onChildAdded(child)
    if not child:IsA("Tool") then
        return
    end

    onEquipped()

    -- Todo create animation default animation
    local isBazooka = character:FindFirstChild("bazooka")
    if isBazooka then
        toolAnimationTrack:Play()
    end
end

local function onChildRemoved()
    onUnequipped()

    toolAnimationTrack:Stop()
end

local function onMouseClick()
    if not isEquipped then
        return
    end

    local target = mouse.target
    if not target then
        return
	end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        return
    end

    local result = activatedToolEvent(mouse.Hit.Position)
    if not result then
        return
    end

    local isBazooka = character:FindFirstChild("bazooka")
    if not isBazooka then
        stabAnimationTrack:Play()
    end
end

-- fire all clients (this creates the rocket that will appear for all clients)
local function onSendRocket(args)
    local startPosition = args.startPosition
    local endPosition = args.endPosition

    local rocketClone = ReplicatedStorage:FindFirstChild("Rocket")
    if not rocketClone then
        warn("MESSAGE/Warn:  Rocket is nil..")
        return
    end

    local lastingTime = nil
    local curveTime = nil
    local midPointAdditon = nil

    Bezier:MakeCurve(rocketClone, lastingTime, curveTime, startPosition, midPointAdditon, endPosition)
end

character.ChildAdded:Connect(onChildAdded)
character.ChildRemoved:Connect(onChildRemoved)
mouse.Button1Up:Connect(onMouseClick)
sendRocketEvent:Connect(onSendRocket)