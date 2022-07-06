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



--Creating the background
local Background = function(props)
    return New "Frame" {

        --Setting the size and position of the background
        Size = UDim2.fromScale(1,1),
        Position = UDim2.fromScale(.5,.5),
        AnchorPoint = Vector2.new(.5,.5),
        ZIndex = 0,

        --Styling the background
        BackgroundColor3 = Computed(function()
            return props.SecondaryColourSpring:get()
        end),

        --Creating all the children of the background
        [Children] = {

            --Making the background round
            Corner = New "UICorner" {

                CornerRadius = UDim.new(.8,0)

            }

        }

    }
end

--Creating the skip button component
local SkipButton = function(props)
    
    --Creating the size sring
    local SizeState = State(props.Size)
    local SizeSpring = Spring(SizeState, 20,.5)

    --Mouse States
    local IsHovering = State(false)
    local IsHeld = State(false)
    
    --Sizing Vars
    local MinMultiplier,MaxMultiplier = .9, 1.1

    --Creating and returning the skip button
    return New "ImageButton" {

        --Setting the main props
        Size = Computed(function()
            return UDim2.fromScale(SizeSpring:get(),SizeSpring:get())
        end),
        Position = props.Position,
        AnchorPoint = Vector2.new(.5,.5),
        Name = props.Name,
        Rotation = props.Rotation,
        ZIndex = 1,


        --Styling the Skip button
        BackgroundTransparency = 1,
        Image = "rbxassetid://10138364880",

        --Creating the hover animations
        [OnEvent "MouseEnter"] = function()
            IsHovering:set(true)
            if IsHeld:get() then return end
            SizeState:set(props.Size*MaxMultiplier)
        end,
        [OnEvent "MouseLeave"] = function()
            IsHovering:set(false)
            if IsHeld:get() then return end
            SizeState:set(props.Size)
        end,

        --Creating the click animation and running the onClick animnation
        [OnEvent "MouseButton1Down"] = function()
            SizeState:set(props.Size*MinMultiplier)
            IsHeld:set(true)
            if props.OnClick then
                props.OnClick()
            end
        end,
        [OnEvent "MouseButton1Up"] = function()
            IsHeld:set(false)
            SizeState:set(IsHovering:get() and props.Size*MaxMultiplier or props.Size)
        end,


        --Creating all the children of the skip button
        [Children] = {

            --Adding a aspect ratio constraint
            New "UIAspectRatioConstraint" {}

        }

    }

end

--Creating the play button component
local PlayButton = function(props)
    
    --Creating the size spring
    local SizeState = State(props.Size)
    local SizeSpring = Spring(SizeState, 20,.5)

    --Mouse States
    local IsHovering = State(false)
    local IsHeld = State(false)
    
    --Sizing Vars
    local MinMultiplier,MaxMultiplier = .9, 1.1

    --Creating and returning the skip button
    return New "ImageButton" {

        --Setting the main props
        Size = Computed(function()
            return UDim2.fromScale(SizeSpring:get(),SizeSpring:get())
        end),
        Position = UDim2.fromScale(.5,.5),
        AnchorPoint = Vector2.new(.5,.5),
        Name = props.Name,
        Rotation = props.Rotation,
        ZIndex = 1,


        --Styling the play button
        BackgroundColor3 = Computed(function()
            return props.MainColourSpring:get()
        end),

        --Creating the hover animations
        [OnEvent "MouseEnter"] = function()
            IsHovering:set(true)
            if IsHeld:get() then return end
            SizeState:set(props.Size*MaxMultiplier)
        end,
        [OnEvent "MouseLeave"] = function()
            IsHovering:set(false)
            if IsHeld:get() then return end
            SizeState:set(props.Size)
        end,

        --Creating the click animation and running the onClick animnation
        [OnEvent "MouseButton1Down"] = function()
            SizeState:set(props.Size*MinMultiplier)
            IsHeld:set(true)
            if props.OnClick then
                props.OnClick()
            end
        end,
        [OnEvent "MouseButton1Up"] = function()
            IsHeld:set(false)
            SizeState:set(IsHovering:get() and props.Size*MaxMultiplier or props.Size)
        end,


        --Creating all the children of the skip button
        [Children] = {

            --Adding the status image
            StatusImage = New "ImageLabel" {

                --Setting the main props
                Position = UDim2.fromScale(.5,.5),
                AnchorPoint = Vector2.new(.5,.5),
                Size = UDim2.fromScale(1.5,1.5),
                
                --Styling the background
                ImageColor3 = Computed(function()
                    return props.SecondaryColourSpring:get()
                end),
                BackgroundTransparency = 1,
                Image = Computed(function()
                    return props.IsPlaying:get() and "rbxassetid://10138901421" or "rbxassetid://10139041489"
                end)

            },

            --Adding a aspect ratio constraint
            UIConstraint = New "UIAspectRatioConstraint" {},
            
            --Rounding the ui
            Corner = New "UICorner" {
                
                CornerRadius = UDim.new(1,0)
                
            }
        }

    }
    
end

--Creating the Media PLayer component
local MediaPlayer = function(props)
    --Creating and returning the Media Player
    return New "Frame" {
    
    --Setting the size and position of the background
    Visible = Computed(function() 
        return props.MainGuiShowing:get()
    end),
    Size = UDim2.fromScale(.7,.7),
    Position = UDim2.fromScale(.5,.83),
    AnchorPoint = Vector2.new(.5,.5),
    
    --Styling the main media player
    BackgroundTransparency = 1,
    
    --Creating all the children media player
    [Children] = {
        
        --Creating the play button
        PlayButton {

            --Setting the hoarceKat parent
            Size = .8,
            ThemeColour = props.ThemeColour,
            IsPlaying = props.IsPlaying,
            MainColourSpring = props.MainColourSpring,
            SecondaryColourSpring = props.SecondaryColourSpring,

            --Setting the OnClick func
            OnClick = function()
                props.IsPlaying:set(not props.IsPlaying:get())
                print("Play")
            end
            
        },
        
        --Creating the previous and next buttons
        Previous = SkipButton {
            
            --Setting the main props
            Name = "Previous",
            Size = .5,
            Position = UDim2.fromScale(.2,.5),
            Rotation = 0,
            
            --Setting the OnClick func
            OnClick = function()
                print("Previous")
            end
            
        },
        
        Next = SkipButton {
            
            --Setting the main props
            Name = "Previous",
            Size = .5,
            Position = UDim2.fromScale(.8,.5),
            Rotation = 180,
            
            --Setting the OnClick func
            OnClick = function()
                print("Next")
            end
            
        },

        --Creating the media player background
        Background = Background {

            SecondaryColourSpring = props.SecondaryColourSpring

        },
        
        --Adding a aspect ratio constraint
        UIConstraint = New "UIAspectRatioConstraint" {
            AspectRatio = 3.5,
        },
    }

}
end

--Returning the final component
return MediaPlayer


--HoarceKat Setup
-- return function(target)
    
--     --Creating the Media PLayer
--     local MainThemeColour = State(Color3.fromHex("FABB14"))
--     local IsPlaying = State(true)
--     local TestPlayer = MediaPlayer {

--         --Setting the hoarceKat parent
--         Parent = target,
--         ThemeColour = MainThemeColour,
--         IsPlaying = IsPlaying,

--     }

--     --HoarceKat destroy callback
--     return function()
--         TestPlayer:Destroy()
--      end

-- end