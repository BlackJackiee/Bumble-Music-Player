--!strict
--[[

    Args -->>
    ({

        Speed: Vector2, --The speed of the gui in the x/y dir
        TileSize Vector2, --The size of the tile in the x/y direction
        
        Props = { --The properties of the gui
            DO NOT USE:
            Size,
            Position,
            TileSize,
            ScaleType,
        }

    })

    Return -->>
    {
        .MovingBg, --Final Moving Image Label
        .Play(), --Used to play the animation
        .Pause(), --Used to pause the animation
        .setSpeed(NewSpeed: Vector2) --Update the speed of the animation
    }

]]

--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("RunService")

--Fusion
local Fusion = require(ReplicatedStorage.Fusion)
local New = Fusion.New
local State = Fusion.State
local Computed = Fusion.Computed


--Moving Gui
local MovingGui = function(props)
    --Setting States Required
    local DistanceX = State(0)
    local DistanceY = State(0)
    local secondsPerCycleX = State(props.Speed.X)
    local secondsPerCycleY = State(props.Speed.Y)
    local SpeedX = Computed(function()
        return 1/secondsPerCycleX:get()
    end)
    local SpeedY = Computed(function()
        return 1/secondsPerCycleY:get()
    end)

    --The moving background mechanic
    local MovingBgStep: RBXScriptConnection?
    local UpdateGuiDistance =  function(dt)
        DistanceX:set((DistanceX:get() + dt * SpeedX:get())%1)
        DistanceY:set((DistanceY:get() + dt * SpeedY:get())%1)
    end

    --Playing the moving animation
    MovingBgStep = rs.RenderStepped:Connect(UpdateGuiDistance)

    --Functions to get the x and y gui pos
    local PosX = Computed(function()
        return secondsPerCycleX:get() ~= 0 and DistanceX:get() * props.TileSize.X - (props.TileSize.X) or 0
    end)
    local PosY = Computed(function()
        return secondsPerCycleY:get() ~= 0 and DistanceY:get() * props.TileSize.Y - (props.TileSize.Y) or 0
    end)

    --Adding the user props to the final props
    local FinalProps = {

        --Setting the base position info
        Size = UDim2.fromScale(5,5),
        Position = Computed(function()
           return UDim2.fromOffset(PosX:get(), PosY:get())
        end),
        TileSize = UDim2.fromOffset(props.TileSize.X,props.TileSize.Y),

        --Styling the moving gui
        ScaleType = "Tile",

    } 

    for k,v in pairs(props.Props) do
        assert(FinalProps[k] == nil, ("Cannot Overwrite: (%q)!"):format(k))
        FinalProps[k] = v
    end

    return {
        
        --Making the imagelabel
        MovingBg = New "ImageLabel" (FinalProps),
        
        --Return functions to play and pause the moving animation
        Play = function()
            --If the animation is already playing do nothing
            if MovingBgStep == nil then
                MovingBgStep = rs.RenderStepped:Connect(UpdateGuiDistance)
            end
        end,

        Pause = function()
            --If the animations is playing then stop it
            if MovingBgStep then
                MovingBgStep:Disconnect()
            end
        end,
    
        --Returning the speed state so they can edit it
        setSpeed = function(NewSpeed: Vector2)
            secondsPerCycleX:set(NewSpeed.X)
            secondsPerCycleY:set(NewSpeed.Y)
        end,

}
end

return MovingGui



--Creating the hoarcekat story
-- return function(target)
--     --Creating the moving bg
--     local MovingBg = MovingGui {

--         Speed = Vector2.new(-.2,1),
--         TileSize = Vector2.new(50,50),
        
--         Props = {
--             Image = "http://www.roblox.com/asset/?id=9290502731",
--             BackgroundTransparency = 1,
--             -- ImageTransparency = 1,
--         }
--     }
    
--     local MainFrame = New "Frame" {
        
--         -- BackgroundTransparency = 1,
--         Parent = target,
--         ClipsDescendants = true,
--         -- Rotation = 1,
--         Position = UDim2.fromScale(.5, .5),
--         AnchorPoint = Vector2.new(.5, .5),
--         Size = UDim2.fromScale(.5,.5),
--         [Children] = MovingBg.MovingBg

--     }
    
--     print("Started")
--     return function() 
--         MovingBg.Pause()
--         MovingBg.MovingBg:Destroy()
--         MainFrame:Destroy()
--     end
-- end