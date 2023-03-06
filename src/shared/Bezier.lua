local Bezier = {}
local Debris = game:GetService("Debris")


function MakeAttachement(Part)
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = Part
    return Attachment
end

function MakeBeam(Part,Attch1,Attach2)
    local Beam = Instance.new("Beam")
    Beam.Parent = Part
    Beam.Attachment0 = Attch1
    Beam.Attachment1 = Attach2
    Beam.Color = ColorSequence.new(Color3.new(1, 0, 0.0156863))
    Beam.Transparency = NumberSequence.new(0.9)
    return Beam
end

function CreatePart(Parent,Pos)
    local part = Instance.new("Part")
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.Parent = Parent
    part.Position = Pos
    return part
end

function CreateDebug(MidPointPart,Mid,Start,End)
    MidPointPart = Instance.new("Part")
    local Start =  CreatePart(MidPointPart,Start)
    local End =  CreatePart(MidPointPart,End)
    local Attachment1 = MakeAttachement(MidPointPart)
    local Attachemnt2 = MakeAttachement(MidPointPart)
    local Attachment3 = MakeAttachement(MidPointPart)
    Attachemnt2.Parent = Start
    Attachment3.Parent = End
    local MakeBeam1 = MakeBeam(MidPointPart,Attachment1,Attachemnt2)
    local Beam2 = MakeBeam(MidPointPart,Attachment1,Attachment3)
    
    MidPointPart.Parent = workspace
    MidPointPart.Anchored = true
    MidPointPart.CanCollide = false
    MidPointPart.Position = Mid
    MidPointPart.BrickColor = BrickColor.new("Really red")
    MidPointPart.Material = Enum.Material.Neon
    MidPointPart.Transparency = 0.5
    return MidPointPart
end


function Lerp(p0,p1,t)
    return p0*(1-t) + p1*t
end
function Quad(p0,p1,p2,t)
    local l1 = Lerp(p0,p1,t)
    local l2 = Lerp(p1,p2,t)
    local Quad = Lerp(l1,l2,t)
    return Quad
end


function Bezier:MakeCurve(Projectile : Part,Time : number,CurveTime : number,Start : Vector3 ,MidPointAddition : Vector3,End : Vector3,Debug : boolean)
    local Mid = Start + End / 2 + MidPointAddition
    local MidPointPart
    
    if Debug and Debug == true then
        MidPointPart = CreateDebug(MidPointPart,Mid,Start,End)
    end
    
    for i =  1,CurveTime do
        local t = i/CurveTime
        local Updated = Quad(Start,Mid,End,t)
        local LookUpUpdate = Quad(Start,Mid,End,t - 0.1)
        Projectile.CFrame = CFrame.new(Updated,LookUpUpdate)
        task.wait(Time)
    end
    
    if Debug and Debug == true then
        Debris:AddItem(MidPointPart,0.1,Start,End)
    end

    local Compeleted = true
    
    return Compeleted
end


return Bezier