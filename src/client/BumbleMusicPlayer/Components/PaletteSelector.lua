--!strict
--Fusion Vars
local Fusion = require(script.Parent.Parent.Fusion)
local New = Fusion.New
local Children = Fusion.Children
local State = Fusion.State
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

--Local ui settings
local uiSettings = {

    Font = Enum.Font.RobotoCondensed,

}

local ThemeColours = {Color3.fromHex("FABB14"),Color3.fromHex("E8324D"),Color3.fromHex("511CE3"),Color3.fromHex("FFFFFF"),Color3.fromHex("000000")}


--Creating the PaletteButton component
local PaletteButton = function(props)
    --Creating the size sring
    local SizeState = State(props.SizeMin)
    local SizeSpring = Spring(SizeState, 40,.8)

    --State to keep track of weather the icon is currently / hovered clicked
    local IsClicked = State(false)
    local IsHovering = State(false)

    --Creating the Draggable ImageButton
    return New "ImageButton" {

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
                Image = "rbxassetid://10145954007"
                

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

--Creating the palette selctor text tables
local TextTab = function(props)
    --Main gui settings
    local OpenSize,CloseSize = UDim2.fromScale(.37,.3), UDim2.fromScale(.35,0)
    local SelectedColour,HoverColour = Color3.fromRGB(0, 0, 0),Color3.fromRGB(110, 110, 110)

    --Gui states
    local IsHovering = State(false)

    --Creating and returning the componnent
    return New "TextButton" {

        --Base Props
        Position = props.Position,
        AnchorPoint = props.AnchorPoint,
        Size = Computed(function()
            return props.IsPaletteOpen:get() and OpenSize or CloseSize
        end),

        --Text Props
        TextScaled = true,
        RichText = true,
        Text = "<b>"..props.Text.."</b>",
        Font = uiSettings.Font,

        --Setting the style
        BackgroundTransparency = 1,
        TextColor3 = Spring(Computed(function()
            return props.MenuSelection:get() == props.Id and SelectedColour or (IsHovering:get() and HoverColour or props.SecondaryColourSpring:get())
        end),20,.7),

        --Connecting all the events
        [OnEvent "Activated"] = function()
            --Updating the menu selecction
            props.MenuSelection:set(props.Id)
        end,
        [OnEvent "MouseEnter"] = function()
            IsHovering:set(true)
        end,
        [OnEvent "MouseLeave"] = function()
            IsHovering:set(false)
        end

    }
end

--Creating the Palette Item component
local PaletteItem = function(props)
    --Creating the size sring
    local SizeState = State(props.SizeMin)
    local SizeSpring = Spring(SizeState, 40,.8)

    --State to keep track of weather the icon is currently / hovered clicked
    local IsClicked = State(false)
    local IsHovering = State(false)

    --Creating the Draggable ImageButton
    return New "ImageButton" {

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
            
            --Creating the inner circle
            New "ImageLabel" {
                
                --Sizing
                Size = Spring(Computed(function()
                    return props.SelectionColourState:get() == props.Colour and UDim2.fromScale(.7,.7) or UDim2.fromScale(.9,.9) 
                end),20,.5),
                Position = UDim2.fromScale(.5,.5),
                AnchorPoint = Vector2.new(.5,.5),
                ZIndex = 5,
                
                --Styling
                BackgroundTransparency = 1,
                ImageColor3 = props.Colour,
                Image = "rbxassetid://10140082494"

                
            },

            --Adding a aspect ratio constraint
            New "UIAspectRatioConstraint" {}
        }
        
    }

end

--Function to return an array of all the colours componenets
local function GetPaletteItems(props)
    local FinalItems = {}
    
    --Loop through all the colours avaliable and create componenets
    for _,Colour in ipairs(ThemeColours) do
        table.insert(FinalItems, PaletteItem {

             --Passing the spring parameters
            SizeMin = UDim2.fromScale(.9,.9), --Idle Size
            SizeMax = UDim2.fromScale(1,1), --Hover Size
            SizeClicked = UDim2.fromScale(.8,.8), --Clicked Size

            --Base settings
            Position = UDim2.fromScale(.15,.5),

            --Passing in all the springs
            Colour = Colour,
            SelectionColourState = props.SelectionColourState,
            SecondaryColourSpring = props.SecondaryColourSpring,

            --Passing all the required states
            MainColourState = props.MainColourState,
            SecondaryColourState = props.SecondaryColourState,

            --Setting the OnClick function
            OnClick = function()
                props.SelectionColourState:set(Colour)
                print(Colour)
            end
            

        })
    end

    --Returning all the components
    return FinalItems
end

--Creating the palettes 
local Palettes = function(props)
    --Creating and returning the palette Frame
    return New "Frame" {

        --Base Props
        Size = UDim2.fromScale(.2,1),
        AnchorPoint = Vector2.new(.5,.5),
        Position = Spring(Computed(function()
            return props.MenuSelection:get() == props.Id and UDim2.fromScale(.5,.5) or UDim2.fromScale(props.EndingPosition,.5)
        end),20,.7),

        --Styling
        Visible = Computed(function()
            return props.MenuSelection:get() == props.Id
        end),
        BackgroundTransparency = 1,

        --Creating all the palette items
        [Children] = {

            --Adding a list item
            List = New "UIListLayout" {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(.05)
            },

            --Adding a button for all the colours available
            GetPaletteItems {
                --Passing the colour springs
                SecondaryColourSpring = props.SecondaryColourSpring,

                --Passing all the required states
                SelectionColourState = props.SelectionColourState,
                IsPaletteOpen = props.IsPaletteOpen,
                MainColourState = props.MainColourState,
                SecondaryColourState = props.SecondaryColourState,
            }
        }

    }
end

--Creaint the palette selection menu
local SelectionMenu = function(props)
    --Main gui settings
    local OpenSize,CloseSize = UDim2.fromScale(.85,.8),UDim2.fromScale(0,0)


    --Creating the selection menu
    return New "Frame" {

        --Base Props
        Position = UDim2.fromScale(.5,1),
        AnchorPoint = Vector2.new(.5,.5),
        Size = Spring(Computed(function()
            return props.IsPaletteOpen:get() and OpenSize or CloseSize
        end),20,.7),

        --Styling the PaletteSelector
        BackgroundColor3 = Spring(Computed(function()
            return props.MainColourSpring:get()
        end),20,.7),

        --Adding all the children
        [Children] = {

            --Creating the frame the palettes will go on
            PaletteFrame = New "Frame" {

                --Base props
                Position = UDim2.fromScale(.5,.5),
                AnchorPoint = Vector2.new(.5,.5),
                Size = UDim2.fromScale(1,.8),

                --Styling
                BackgroundTransparency = 1,
                ClipsDescendants = false,

                --Adding the palettes
                [Children] = {
                    Primary = Palettes {
                        
                    --Base props
                    EndingPosition = .4,
                    Id = "P",
                    SelectionColourState = props.MainColourState,
                        
                    --Passing in all the springs
                    MainColourSpring = props.MainColourSpring,
                    SecondaryColourSpring = props.SecondaryColourSpring,

                    --Passing in all the required states
                    IsPaletteOpen = props.IsPaletteOpen,
                    MenuSelection = props.MenuSelection,
                    MainColourState = props.MainColourState,
                    SecondaryColourState = props.SecondaryColourState,

                    },
                    
                    Secondary = Palettes {
                        
                        --Base props
                        EndingPosition = .6,
                        Id = "S",
                        SelectionColourState = props.SecondaryColourState,
                            
                        --Passing in all the springs
                        MainColourSpring = props.MainColourSpring,
                        SecondaryColourSpring = props.SecondaryColourSpring,
    
                        --Passing in all the required states
                        IsPaletteOpen = props.IsPaletteOpen,
                        MenuSelection = props.MenuSelection,
                        MainColourState = props.MainColourState,
                        SecondaryColourState = props.SecondaryColourState,
    
                        }
                }

            },
            

            --Rounding the palette selector
            Rounding = New "UICorner" {
                CornerRadius = UDim.new(.2,0)
            },

            --Adding the ui stroke
            Stroke = New "UIStroke" {
                Thickness = Spring(Computed(function()
                    return props.IsPaletteOpen:get() and 10 or 0
                end),20,.3),
                Color = Spring(Computed(function()
                    return props.SecondaryColourSpring:get()
                end),20,.7)
            }

        }

    }
end

--Creating the palette selector ui
local PaletteSelector = function(props)
    --Palette Slection States
    local MenuSelection = State("P") --The menu the user is on

    --Main gui settings
    local OpenSize,CloseSize = UDim2.fromScale(.55,.25),UDim2.fromScale(0,0)

    --Creating the palette selector
    return New "Frame" {

        --Base Props
        Position = UDim2.fromScale(.56,.5),
        AnchorPoint = Vector2.new(0.5,.5),
        Size = Spring(Computed(function()
            return props.IsPaletteOpen:get() and OpenSize or CloseSize
        end),20,1),

        --Styling the PaletteSelector
        BackgroundColor3 = Spring(Computed(function()
            return props.MainColourSpring:get()
        end),20,.7),

        --Adding all the children
        [Children] = {

            --Creating the selection menu
            SelectionMenu = SelectionMenu {

                
                --Passing in all the springs
                MainColourSpring = props.MainColourSpring,
                SecondaryColourSpring = props.SecondaryColourSpring,

                --Passing in al the required states
                MenuSelection = MenuSelection,
                IsPaletteOpen = props.IsPaletteOpen,
                MainColourState = props.MainColourState,
                SecondaryColourState = props.SecondaryColourState,

            },

            --Creating the text tabs
            PrimaryTab = TextTab {

                --Base Props
                Position = UDim2.fromScale(.1,.1),
                AnchorPoint = Vector2.new(0,0),
                Text = "PRIMARY",
                Id = "P",

                --Passing in all the springs
                SecondaryColourSpring = props.SecondaryColourSpring,

                --Passing in al the required states
                MenuSelection = MenuSelection,
                IsPaletteOpen = props.IsPaletteOpen


            },

            SecondaryTab = TextTab {

                --Base Props
                Position = UDim2.fromScale(.9,.1),
                AnchorPoint = Vector2.new(1,0),
                Text = "SECONDARY",
                Id = "S",

                --Passing in all the springs
                SecondaryColourSpring = props.SecondaryColourSpring,

                --Passing in al the required states
                MenuSelection = MenuSelection,
                IsPaletteOpen = props.IsPaletteOpen


            },

            --Rounding the palette selector
            Rounding = New "UICorner" {
                CornerRadius = UDim.new(.2,0)
            },

            --Adding the ui stroke
            Stroke = New "UIStroke" {
                Thickness = Spring(Computed(function()
                    return props.IsPaletteOpen:get() and 10 or 0
                end),20,.3),
                Color = Spring(Computed(function()
                    return props.SecondaryColourSpring:get()
                end),20,.7)
            }

        }

    }

end


local function PaletteUi(props)
    --Creating the main components
    local PaletteBttn = PaletteButton {

        --Passing the spring parameters
        SizeMin = UDim2.fromScale(.36,.36), --Idle Size
        SizeMax = UDim2.fromScale(.41,.41), --Hover Size
        SizeClicked = UDim2.fromScale(.34,.34), --Clicked Size

        --Base settings
        Position = UDim2.fromScale(.15,.5),

        --Passing in all the springs
        MainColourSpring = props.MainColourSpring,
        SecondaryColourSpring = props.SecondaryColourSpring,

        --Setting the OnClick function
        OnClick = function()
            props.IsPaletteOpen:set(not props.IsPaletteOpen:get())
        end

    }
    
    --Creating the palette selector
    local PaletteSelector = PaletteSelector {


        --Passing in all the springs
        MainColourSpring = props.MainColourSpring,
        SecondaryColourSpring = props.SecondaryColourSpring,

        --Passing all the required States
        IsPaletteOpen = props.IsPaletteOpen,
        MainColourState = props.MainColourState,
        SecondaryColourState = props.SecondaryColourState,

    }

    return {
        PaletteUi = New "Frame" {
        --Setting the base props
        Position = props.Position,
        AnchorPoint = Vector2.new(.5,.5),
        Size = props.Size,

        --Styling the main frame
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),

        --Creating all the children
        [Children] = {
            --Adding a aspect ratio constraint
            Aspect = New "UIAspectRatioConstraint" {
                AspectRatio = 2
            },

            --Adding all the components
            PaletteBttn,
            PaletteSelector
        }

    },
}
    
end

--Returning the final component
return PaletteUi



--HoarceKat Setup
-- return function(target)
--     --Main props
--     local MainColourState = State(Color3.fromHex("FABB14"))
--     local SecondaryColourState = State(Color3.fromRGB(255, 255, 255))
    
--     --Main springs
--     local MainColourSpring = Spring(Computed(function()
--         return MainColourState:get()
--     end),20,.7)
--     local SecondaryColourSpring = Spring(Computed(function()
--         return SecondaryColourState:get()
--     end),20,.7)

--     --Main states
--     local IsPaletteOpen = State(true)

--     --Creating the Palette Ui
--     local TestPaletteUi = PaletteUi {
        
--         --Setting the hoarceKat parent
--         Parent = target,

--         --Base settings
--         Size = UDim2.fromScale(.9,1),
--         Position = UDim2.fromScale(.5,.5),
        
--         --Passing the colour springs
--         MainColourSpring = MainColourSpring,
--         SecondaryColourSpring = SecondaryColourSpring,

--         --Passing all the required states
--         IsPaletteOpen = IsPaletteOpen,
--         MainColourState = MainColourState,
--         SecondaryColourState = SecondaryColourState,

--     }

--     --HoarceKat destroy callback
--     return function()
--         TestPaletteUi.PaletteUi:Destroy()
--      end
-- end