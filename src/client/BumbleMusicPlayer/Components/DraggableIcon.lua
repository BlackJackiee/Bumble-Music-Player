--!strict
--Services
local uis = game:GetService("UserInputService")
local guis = game:GetService("GuiService")
local runs = game:GetService("RunService")

--Fusion Vars
local Fusion = require(script.Parent.Parent.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

--Local gui settings
local guiSettings = {
    --Timing Settings
    HoldActivationTime = 0.7, --How long to hold the icon before it follows the mouse position
}



--Creating the DraggableIcon component
local DraggableIcon = function(props)
    --Creating the size sring
    local SizeState = State(props.SizeMin)
    local SizeSpring = Spring(SizeState, table.unpack(props.SpringSettings))

    --Creating the position sring
    local PositionState = State(props.StartPosition)
    local PositionSpring = Spring(PositionState, table.unpack(props.SpringSettings))

    --State to keep track of weather the icon is currently / hovered clicked
    local IsClicked = State(false)
    local IsHovering = State(false)
    local IsHolding = State(false)

    --Function to move the position of the icon to the pos of the mouse
    local function SetPosToMousePosition()
        --Getting the mouse position in 2d
        local mousePos = uis:GetMouseLocation() - Vector2.new(0, guis:GetGuiInset().Y)

        --Getting the size of the gui
        local halfGui = Vector2.new(SizeSpring:get().X.Scale/2,SizeSpring:get().Y.Scale/2)

        --Setting the position of icon to folow
        PositionState:set(UDim2.new(-halfGui.X, mousePos.X, -halfGui.Y, mousePos.Y))
    end

    --Storing any connections used
    local Connections: {[string] : RBXScriptConnection?} = {

        --The connection that moves the icon the mouse position
        MouseFollow = nil,

    }

    --Function to listen for if the user is holding the icon
    local function ListenForHold()
        --Get the start time
        local StartTime = tick()

        --Keep checking the user has held the min amount of time
        while IsClicked:get() do
            --Yeild so guy doesnt die ;<
            task.wait()
            
            --Checking if the icon was held long enough
            if tick() - StartTime >= guiSettings.HoldActivationTime then
                --Updating the is holding state
                IsHolding:set(true)
                
                --Connecting the position follow func
                if Connections.MouseFollow == nil then
                    Connections.MouseFollow = runs.RenderStepped:Connect(SetPosToMousePosition)
                end
                
                --Setting the size of the icon to max
                SizeState:set(props.SizeMax)
                
                break--Stopping the loop
            end
            
        end
    end
    
    --Function to stop the icon from following the mouse
    local function StopMouseFollow()
        --Updating the is holding state
        IsHolding:set(false)

        --Dissconnecting the follow connection
        if Connections.MouseFollow then
            Connections.MouseFollow:Disconnect()
            Connections.MouseFollow = nil
        end
    end
    
    --Creating all the properies of the final image label
    local FinalProps = {

        --Base Settings
        Size = Computed(function() return SizeSpring:get() end),
        Position = Computed(function() return PositionSpring:get() end),

        --Connecting all the size events
        [OnEvent "MouseEnter"] = function()
            IsHovering:set(true)
            if IsClicked:get() then return end
            SizeState:set(props.SizeMax)
        end,
        [OnEvent "MouseLeave"] = function()
            IsHovering:set(false)
            if IsClicked:get() then return end
            SizeState:set(props.SizeMin)
        end,
        [OnEvent "MouseButton1Down"] = function()
            IsClicked:set(true)
            SizeState:set(props.SizeClicked)
            task.spawn(ListenForHold) --Begin listening for icon hold
        end,
        [OnEvent "MouseButton1Up"] = function()
            IsClicked:set(false)

            --Getting the new size target
            local TargetSize = IsHovering:get() == true and props.SizeMax or props.SizeMin
            TargetSize = IsHolding:get() and props.SizeMin or TargetSize
            
            --Run the OnClick func if the ui wasnt dragged
            if IsHolding:get() == false then
                props.OnClick()
            end

            --If the user is still hovering, set it to the hover size
            SizeState:set(TargetSize)
            
            --Stopping the icon from following the mouse button
            StopMouseFollow()
        end,

        --Creating all the children
        [Children] = {
            --Adding all the children passed in
            props.PropChildren
        }

    }

    --Adding all the props passed in
    for k, v in pairs(props.Props) do
        FinalProps[k] = v
    end

    --Creating the Draggable ImageButton
    return {
        --Retuning the gui
        Icon = New(props.Type)(FinalProps),

        --Returning a destroy function (Must call to dissconnect any connections)
        Disconnect = function()
            for _,Connection in pairs(Connections) do
                if Connection then 
                    Connection:disconnect()
                end
            end
        end


    }

end

--Returning the component
return DraggableIcon



--HoarceKat Setup
-- return function(target)

--     --Creating the DraggableIcon
--     local TestDraggableIcon = DraggableIcon {

--         --Setting the hoarceKat parent
--         Parent = target,
        
--         --Setting the type of gui
--         Type = "ImageButton",

--         --Passing the spring parameters
--         SizeMin = UDim2.fromScale(.15,.15), --Idle Size
--         SizeMax = UDim2.fromScale(.175,.175), --Hover Size
--         SizeClicked = UDim2.fromScale(.15,.15), --Clicked Size

--         --Base settings
--         StartPosition = UDim2.fromScale(0,0),

--         --Spring settings
--         SpringSettings = {45,0.8},

--         --Sizing the icon
--         Props = {
--             --Setting the base settings
--             Image = "rbxassetid://10135799398",
--             BackgroundTransparency = 1,

--             --Styling the icon

--         },

--         PropChildren = {

--             --Adding a aspect ratio constraint
--             New "UIAspectRatioConstraint" {}

--         }

--     }

--     --HoarceKat destroy callback
--     return function()
--         TestDraggableIcon.Disconnect()
--          TestDraggableIcon.Icon:Destroy()
--      end

-- end