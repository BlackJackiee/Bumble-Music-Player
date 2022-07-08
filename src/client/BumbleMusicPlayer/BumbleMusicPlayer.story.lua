--!strict
--Main Music Player Components
local Components = script.Parent.Components
local DraggableIcon = require(Components.DraggableIcon)
local DraggableIconModified = require(Components.DraggableIconModified)
local MediaPlayer = require(Components.MediaPlayer)
local MediaDisplayer = require(Components.MediaDisplayer)
local VolumeController = require(Components.VolumeController)
local PaletteSelector = require(Components.PaletteSelector)
local MusicPlayer = require(Components.MusicPlayer)

--Fusion Vars
local Fusion = require(script.Parent.Fusion)
local New = Fusion.New
local State = Fusion.State
local Children = Fusion.Children
local Spring = Fusion.Spring
local Computed = Fusion.Computed



--Creating the music player
local MusicPlayer = function(props)
    --Main Music Theme States
    local MainThemeColour = State(Color3.fromHex("FFFFFF"))
    local SecondaryThemeColour = State(Color3.fromHex("000000"))
    
    --Making the colour springs
    local MainColourSpring = Spring(MainThemeColour,2,.9)
    local SecondaryColourSpring = Spring(SecondaryThemeColour,2,.9)
    
    --Main Music Player States
    local Volume = State(.5)
    local IsVolumePanelOn = State(false)
    local IsPaletteOpen = State(false)
    local MainGuiShowing = State(false)
    local IsPlaying = State(false)
    local MediaData = State({

        Artwork = nil,
        Artist = "",
        Song = "",
        SoundId = 0,

    })

    --Creating the music player
    local MusicPlayer = MusicPlayer {

        Volume = Volume,
        IsPlaying = IsPlaying,
        MediaData = MediaData,

    }

    --Creating the MediaDisplayer
    local MediaDisplayer = MediaDisplayer {
        
        --Setting the hoarceKat parent
        Size = .6,
        MainColourSpring = MainColourSpring,
        SecondaryColourSpring = SecondaryColourSpring,
        IsPlaying = IsPlaying,
        MediaData = MediaData,
        
    }
    
    --Creating the media controls
    local MediaControls = MediaPlayer {
        
        --Base props
        MainColourSpring = MainColourSpring,
        SecondaryColourSpring = SecondaryColourSpring,
        IsPlaying = IsPlaying,
        MainGuiShowing = MainGuiShowing,
        

        --Setting up the functions
        Skip = MusicPlayer.Skip,
        Previous = MusicPlayer.Previous
        
    }

    local VolumeController = VolumeController {
        
        --Base settings
        Size = UDim2.fromScale(.8,1),
        Position = UDim2.fromScale(1.07,.32),
        MainColourSpring = MainColourSpring,
        SecondaryColourSpring = SecondaryColourSpring,

        --Main Player states
        IsVolumePanelOn = IsVolumePanelOn,
        Volume = Volume
    }

    --Making the palette selector
    local Palette = PaletteSelector {
            -- Base settings
            Size = UDim2.fromScale(1.1,1),
            Position = UDim2.fromScale(1.225,.55),
            
            --Passing the colour springs
            MainColourSpring = MainColourSpring,
            SecondaryColourSpring = SecondaryColourSpring,

            --Passing all the required states
            IsPaletteOpen = IsPaletteOpen,
            MainColourState = MainThemeColour,
            SecondaryColourState = SecondaryThemeColour,
    }

    --Creating the Main media player
    local MediaPlayer = DraggableIconModified {
        
        --Setting the type of gui
        Type = "ImageButton",
        
        --Passing the spring parameters
        SizeMin = UDim2.fromScale(2.3,2.3), --Idle Size
        SizeMax = UDim2.fromScale(2.5,2.5), --Hover Size
        SizeClicked = UDim2.fromScale(2,2), --Clicked Size
        RotationClosed = -20,
        
        --Base settings
        MainGuiShowing = MainGuiShowing,
        StartPosition = UDim2.fromScale(.2,.4),
        
        --Spring settings
        SpringSettings = {45,0.8},
        
        --Passing all the required states
        IsPaletteOpen = IsPaletteOpen,
        IsVolumePanelOn = IsVolumePanelOn,
        
        --Sizing the icon
        Props = {},
        
        PropChildren = {
            --Creating all the music player components
            MediaDisplayer = MediaDisplayer,--Creating the Media Displayer
            MediaControls = MediaControls,--Creating the media controls
            VolumeController = VolumeController.VolumeController,--Creating the Volume Controller
            PaletteSelector = Palette.PaletteUi, --Creating the palette selector
        },
    }

    --Creating the draggable icon
    local MainIcon =  DraggableIcon {

        --Setting the type of gui
        Type = "ImageButton",

        --Passing the spring parameters
        SizeMin = UDim2.fromScale(.15,.15), --Idle Size
        SizeMax = UDim2.fromScale(.175,.175), --Hover Size
        SizeClicked = UDim2.fromScale(.15,.15), --Clicked Size
        
        --Base settings
        StartPosition = UDim2.fromScale(.05,.1),
        
        --Spring settings
        SpringSettings = {45,0.8},
        MainGuiShowing = MainGuiShowing,
        PositionSpring = MediaPlayer.PositionSpring,
        
        --Setting up the OnClick function
        OnClick = function()
            MainGuiShowing:set(not MainGuiShowing:get())
            IsVolumePanelOn:set(false)
            IsPaletteOpen:set(false)
        end,
        
        --Sizing the icon
        Props = {
            --Setting the base settings
            Image = "rbxassetid://10140015275",
            BackgroundTransparency = 1,
            ZIndex = 4,
            ImageColor3 = Computed(function()
                return SecondaryColourSpring:get()
            end),
            
        },
        
        PropChildren = {
            --Adding a aspect ratio constraint
            New "UIAspectRatioConstraint" {},
            
            --Creating the inner circle
            New "ImageLabel" {

                --Sizing
                Size = UDim2.fromScale(1,1),
                ZIndex = 6,
                
                --Styling
                BackgroundTransparency = 1,
                ImageColor3 = Computed(function()
                    return SecondaryColourSpring:get()
                end),
                Image = "rbxassetid://10140015468"
                

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
                    return MainColourSpring:get()
                end),
                Image = "rbxassetid://10140082494"

                
            }
            
        }
    }

    --Making the Main Music Player Frame
    return {
        Gui = New "Frame" {

        --Setting up the music player correctly
        Parent = props.Parent,
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,

        --Creating all the music player components
        [Children] = {

            --Creating the Main Draggable Icon
            Icon = MainIcon.Icon,
            
            --Creating the Main media player
            MediaPlayer = MediaPlayer.Icon,
        }
    },

    Destroy = function()
        Palette.PaletteUi:Destroy()
        VolumeController.Disconnect()
        MediaDisplayer:Destroy()
        MediaPlayer.Disconnect()
        MainIcon.Disconnect()
        MusicPlayer.Destroy()
    end

}
end

-- return MusicPlayer


-- HoarceKat Setup
return function(target)

    --Creating the music player
    local MusicPlayer = MusicPlayer {
        Parent = target,
    }

    --Returning the destroy function
    return function()
        MusicPlayer.Destroy()
        MusicPlayer.Gui:Destroy()
    end

end