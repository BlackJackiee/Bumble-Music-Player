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

--Local ui settings
local uiSettings = {

    Font = Enum.Font.RobotoCondensed,

}



--Creating the background
local MediaDisplayer = function(props)


    return New "Frame" {

        --Setting the size and position of the MediaDisplayer
        Size = UDim2.fromScale(props.Size, props.Size),
        Position = UDim2.fromScale(.5,.5),
        AnchorPoint = Vector2.new(.5,.5),
        ZIndex = -10,

        --Styling the MediaDisplayer button
        BackgroundColor3 = Computed(function()
            return props.MainColourSpring:get()
        end),

        --Creating all the children of the MediaDisplayer
        [Children] = {

            --Making the MediaDisplayer round
            Corner = New "UICorner" {

                CornerRadius = UDim.new(1,0)

            },

            --Creating the artwork
            Artwork = New "ImageLabel" {

                --Styling the artwork
                BackgroundTransparency = 0,
                BackgroundColor3 = Computed(function()
                    return props.SecondaryColourSpring:get()
                end),
                ImageColor3 = Computed(function()
                    return props.MediaData:get().Artwork ~= nil and Color3.fromRGB(255, 255, 255) or props.SecondaryColourSpring:get()
                end),
                Image = Computed(function()
                    local Artwork = props.MediaData:get().Artwork ~= nil and props.MediaData:get().Artwork or "rbxassetid://10139426544"
                    return Artwork
                end),


                --Sizing and position the artwork
                Size = UDim2.fromScale(.6,.6),
                Position = UDim2.fromScale(.5,.38),
                AnchorPoint = Vector2.new(.5,.5),
                ZIndex = -9,

                --Adding all the artwork children
                [Children] = {
                    --Making the MediaDisplayer round
                    Corner = New "UICorner" {
                        CornerRadius = UDim.new(1,0)
                    },
                }

            },

            --Creating the song name ui
            SongName = New "TextLabel" {

                --Sizing and position the artwork
                Size = UDim2.fromScale(.4,.1),
                Position = UDim2.fromScale(.5,.74),
                AnchorPoint = Vector2.new(.5,.5),
                ZIndex = -9,

                --Styling the artwork
                RichText = true,
                Font = uiSettings.Font,
                BackgroundTransparency = 1,
                TextScaled = true,
                Text = Computed(function()
                    return "<b>"..props.MediaData:get().Song.."</b>"
                end)
            },

            -- Creating the artist name ui
            ArtistName = New "TextLabel" {

                --Sizing and position the artwork
                Size = UDim2.fromScale(.4,.04),
                Position = UDim2.fromScale(.5,.805),
                AnchorPoint = Vector2.new(.5,.5),
                ZIndex = -9,

                --Styling the artwork
                RichText = true,
                TextColor3 = Color3.fromHex("676565"),
                Font = uiSettings.Font,
                BackgroundTransparency = 1,
                TextScaled = true,
                Text = Computed(function()
                    return props.MediaData:get().Artist
                end)
            },

            --Adding a stroke
            Stoke = New "UIStroke" {

                Color = Computed(function()
                    return props.SecondaryColourSpring:get()
                end),

                Thickness = 20,

            },

            --Adding a aspect ratio constraint
            UIConstraint = New "UIAspectRatioConstraint" {},

        }

    }
end

--Retrurnging the main component
return MediaDisplayer


-- HoarceKat Setup
-- return function(target)
    
--     --Creating the Media Displayer
--     local MainThemeColour = State(Color3.fromHex("FABB14"))
--     local SecondaryThemeColour = State(Color3.fromRGB(255, 255, 255))
--     local IsPlaying = State(true)

--     local MediaData = State({

--         Artwork = "http://www.roblox.com/asset/?id=6990052749",
--         Artist = "Paul Williams",
--         Song = "Ordinary Fool"

--     })

--     local TestPlayer = Background {

--         --Setting the hoarceKat parent
--         Parent = target,
--         Size = .8,
--         ThemeColour = MainThemeColour,
--         ThemeSecondaryColour = SecondaryThemeColour,
--         IsPlaying = IsPlaying,
--         MediaData = MediaData,

--     }

--     --HoarceKat destroy callback
--     return function()
--         TestPlayer:Destroy()
--      end

-- end