--!strict
--Services
local uis = game:GetService("UserInputService")
local runs = game:GetService("RunService")

--Fusion Vars
local Fusion = require(script.Parent.Parent.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

--Viewport info
local ViewportSize = workspace.CurrentCamera.ViewportSize

--Global vars
local VolumeRange = {.2,.97} --The range used by the volume panel



--Utility Functions
local function lerp(a,b,t)
     return a * (1-t) + b * t
end


--Creating the VolumeButton component
local VolumeButton = function(props)
    --Creating the size sring
    local SizeState = State(props.SizeMin)
    local SizeSpring = Spring(SizeState, 40,.8)

    --State to keep track of weather the icon is currently / hovered clicked
    local IsClicked = State(false)
    local IsHovering = State(false)


    --Creating the Draggable ImageButton
    return New "ImageButton" {

        --Setting the base props
        Parent = props.Parent,

        --Base Settings
        Size = Computed(function() return SizeSpring:get() end),
        AnchorPoint = Vector2.new(.5,.5),
        Position = props.Position,
        
        --Styling the volume button
        --Setting the base settings
        Image = "rbxassetid://10140015275",
        BackgroundTransparency = 1,
        ZIndex = 4,
        ImageColor3 = Computed(function()
            return props.SecondaryColourSpring:get()
        end),

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
        end,
        [OnEvent "MouseButton1Up"] = function()
            IsClicked:set(false)
            
            --Run the OnClick func if it exists
            if props.OnClick then
                props.OnClick()
            end
            
            --If the user is still hovering, set it to the hover size
            SizeState:set(IsHovering:get() == true and props.SizeMax or props.SizeMin)
        end,

        --Creating all the children
        [Children] = {
            
            --Creating the inner icon
            New "ImageLabel" {

                --Sizing
                Size = UDim2.fromScale(1,1),
                ZIndex = 6,
                
                --Styling
                BackgroundTransparency = 1,
                ImageColor3 = Computed(function()
                    return props.SecondaryColourSpring:get()
                end),
                Image = "rbxassetid://10144268174"
                

            },
            
            --Creating the inner circle
            New "ImageLabel" {
                
                --Sizing
                Size = UDim2.fromScale(.9,.9),
                Position = UDim2.fromScale(.5,.5),
                AnchorPoint = Vector2.new(.5,.5),
                ZIndex = 5,
                
                --Styling
                BackgroundTransparency = 1,
                ImageColor3 = Computed(function()
                    return props.MainColourSpring:get()
                end),
                Image = "rbxassetid://10140082494"

                
            },

            --Adding a aspect ratio constraint
            New "UIAspectRatioConstraint" {}
        }
        
    }

end

--Creating the Draggable Volume Button component
local DraggableButton = function(props)
    --Creating the size sring
    local SizeState = State(props.SizeMin)
    local SizeSpring = Spring(SizeState, 40,.8)

    --State to keep track of weather the icon is currently / hovered clicked
    local IsClicked = State(false)
    local IsHovering = State(false)

    
    --Volume Adjusting functions
    local function AdjustVolume()
        --Converting the mouse pos to scale
        local MouseX = math.clamp(uis:GetMouseLocation().X / ViewportSize.X,VolumeRange[1],VolumeRange[2])

        --Calculating the new volume
        local Volume = (MouseX - VolumeRange[1]) / (VolumeRange[2] - VolumeRange[1])

        --Setting the volume
        props.VolumeState:set(Volume)
    end
    local VolumeAdjuster: RBXScriptConnection?

    --Creating the Draggable ImageButton
    return {
        Button = New "ImageButton" {

        --Base Settings
        Size = Computed(function() return SizeSpring:get() end),
        AnchorPoint = Vector2.new(.5,.5),
        Position = props.Position,
        
        --Styling the volume button
        --Setting the base settings
        Image = "rbxassetid://10140015275",
        BackgroundTransparency = 1,
        ZIndex = 4,
        ImageColor3 = Computed(function()
            return props.SecondaryColourSpring:get()
        end),

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

            --Begin adjusting the volume
            if VolumeAdjuster == nil then 
                VolumeAdjuster = runs.RenderStepped:Connect(AdjustVolume)
            end
        end,
        [OnEvent "MouseButton1Up"] = function()
            IsClicked:set(false)
            
            --Disable the volume adjuster
            if VolumeAdjuster then
                VolumeAdjuster:Disconnect()
                VolumeAdjuster = nil
            end
            
            --If the user is still hovering, set it to the hover size
            SizeState:set(IsHovering:get() == true and props.SizeMax or props.SizeMin)
        end,

        --Creating all the children
        [Children] = {
            
            --Creating the inner circle
            New "ImageLabel" {
                
                --Sizing
                Size = UDim2.fromScale(.9,.9),
                Position = UDim2.fromScale(.5,.5),
                AnchorPoint = Vector2.new(.5,.5),
                ZIndex = 5,
                
                --Styling
                BackgroundTransparency = 1,
                ImageColor3 = Computed(function()
                    return props.MainColourSpring:get()
                end),
                Image = "rbxassetid://10140082494"

                
            },

            --Adding a aspect ratio constraint
            New "UIAspectRatioConstraint" {}
        }
    }, 

    Disconnect = function()
        --Disable the volume adjuster
        if VolumeAdjuster then
            VolumeAdjuster:Disconnect()
        end
    end

}
end

--Creating the horizontal bar component
local HorizontalBar = function(props)
    return New "Frame" {

        --Setting the base props
        Size = UDim2.fromScale(.95,.25),
        AnchorPoint = Vector2.new(0,.5),
        Position = UDim2.fromScale(0,.5),
    
        --Styling the panel
        BackgroundColor3 = Computed(function()
            return props.SecondaryColourSpring:get()
        end),
    
        --Adding all the children
        [Children] = {

            --Rounding the ui
            Round = New "UICorner" {
                CornerRadius = UDim.new(1,0)
            },

            --Adding all the prop children
            props.Children
    
        }
    }
end

--Creating the adjustable horizontal bar
local AdjustableHorizontalBar = function(props)
    
    --Creating the volume computed value adjusted to the movement range
    local VolumeSpringRange = Spring(Computed(function()
        return lerp(VolumeRange[1],VolumeRange[2],props.Volume:get())
    end),20,.7)

    --Creating the draggable button
    local DragButton = DraggableButton {
                
        --Passing the spring parameters
        SizeMin = UDim2.fromScale(10,10), --Idle Size
        SizeMax = UDim2.fromScale(13,13), --Hover Size
        SizeClicked = UDim2.fromScale(9.5,9.5), --Clicked Size

        --Base settings
        Position = Computed(function()
            return UDim2.fromScale(1,.5)
        end),

        --Passing in all the springs
        MainColourSpring = props.MainColourSpring,
        SecondaryColourSpring = props.SecondaryColourSpring,

        --Passing alll the states required
        VolumeState = props.Volume,
        
    }

    return {
        Bar = New "Frame" {

        --Setting the base props
        Size = Computed(function()
            return UDim2.fromScale(VolumeSpringRange:get(),.3)
        end),
        AnchorPoint = Vector2.new(0,.5),
        Position = UDim2.fromScale(0,.5),
    
        --Styling the panel
        BackgroundColor3 = Computed(function()
            return props.MainColourSpring:get()
        end),
    
        --Adding all the children
        [Children] = {
            
            --Creating the draggable component
            DraggableButton = DragButton.Button,

            --Rounding the ui
            Round = New "UICorner" {
                CornerRadius = UDim.new(1,0)
            },
    
        }
    },
    
    Disconnect = DragButton.Disconnect
}
end


--Creating the volume panel component
local VolumePanel = function(props)
    --Creating the adjustable horizontal bar
    local AdjustableBar = AdjustableHorizontalBar {
        --Passiung all the colour springs
        MainColourSpring = props.MainColourSpring,
        SecondaryColourSpring = props.SecondaryColourSpring,

        --Passing all the required states
        Volume = props.Volume,
    }

    return {VolumePanel = New "Frame" {

        --Setting the base props
        Size = Spring(Computed(function()
            return props.IsVolumePanelOn:get() and UDim2.fromScale(.8,.2) or UDim2.fromScale(0,.2)
        end),20,.7),
        AnchorPoint = Vector2.new(0,.5),
        Position = props.Position,

        --Styling the panel
        BackgroundColor3 = Computed(function()
            return props.MainColourSpring:get()
        end),

        --Adding all the children
        [Children] = {

            --Adding the inner volume controller
            VolumeController = HorizontalBar {
                SecondaryColourSpring = props.SecondaryColourSpring,

                --Creating the children
                Children = {
                    --Adding the adjustable horizontal bar
                    AdjustableHorizontalBar = AdjustableBar.Bar,
                }
            },

            --Rounding the ui
            Round = New "UICorner" {
                CornerRadius = UDim.new(1,0)
            },

            --Adding the stroke
            Stoke = New "UIStroke" {

                Color = Computed(function()
                    return props.SecondaryColourSpring:get()
                end),
                Thickness = 12,

            }

        }

    },

     Disconnect = AdjustableBar.Disconnect
    }
end



local function VolumeController(props)
    --Creating the main components
    local VolumeBttn = VolumeButton {

        --Passing the spring parameters
        SizeMin = UDim2.fromScale(.5,.5), --Idle Size
        SizeMax = UDim2.fromScale(.575,.575), --Hover Size
        SizeClicked = UDim2.fromScale(.45,.45), --Clicked Size

        --Base settings
        Position = UDim2.fromScale(.15,.5),

        --Passing in all the springs
        MainColourSpring = props.MainColourSpring,
        SecondaryColourSpring = props.SecondaryColourSpring,

        --Setting the OnClick function
        OnClick = function()
            props.IsVolumePanelOn:set(not props.IsVolumePanelOn:get())
        end

    }
    
    local Panel = VolumePanel {

        --Setting the base props
        Position = VolumeBttn.Position,
        
        --Passing in all the springs
        MainColourSpring = props.MainColourSpring,
        SecondaryColourSpring = props.SecondaryColourSpring,

        --Passing all the required states
        IsVolumePanelOn = props.IsVolumePanelOn,
        Volume = props.Volume,
    }

    return {
        VolumeController = New "Frame" {
        --Setting the base props
        Parent = props.Parent,
        Position = props.Position,
        AnchorPoint = Vector2.new(.5,.5),
        Size = props.Size,

        --Styling the main frame
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),

        --Creating all the children
        [Children] = {
            
            --Adding a aspect ratio constraint
            New "UIAspectRatioConstraint" {
                AspectRatio = 2
            },

            --Adding all the components
            VolumeButton = VolumeBttn,
            VolumePanel = Panel.VolumePanel,
        }

    },

    Disconnect = Panel.Disconnect
}
    
end

--Returning the component
return VolumeController



--HoarceKat Setup
-- return function(target)
--     --Main props
--     local MainColourSpring = State(Color3.fromRGB(233, 171, 25))
--     local SecondaryColourSpring = State(Color3.fromRGB(255, 255, 255))

--     --Creating the Volume Controller
--     local TestVolumeController = VolumeController {
        
--         --Setting the hoarceKat parent
--         Parent = target,

--         --Base settings
--         Size = UDim2.fromScale(.9,1),
--         Position = UDim2.fromScale(.5,.5),
--         MainColourSpring = MainColourSpring,
--         SecondaryColourSpring = SecondaryColourSpring,

           --Main states
    --    IsVolumePanelOn = State(true)
    --    Volume = State(.5)

--     }

--     --HoarceKat destroy callback
--     return function()
--         TestVolumeController.Disconnect()
--         TestVolumeController.VolumeController:Destroy()
--      end
-- end