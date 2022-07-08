--!strict
--Fusion Vars
local Fusion = require(script.Parent.Parent.Fusion)
local New = Fusion.New
local OnChange = Fusion.OnChange
local State = Fusion.State
local Computed = Fusion.Computed

--Making the music player component
local MusicPlayer = function(props)
    --Storing the music queue
    local MusicQueue = {
        {
            Artwork = "rbxasset://sounds/Asap.jpg",
            Artist = "A$AP Rocky",
            Song = "Praise The Lord (Da Shine)",
            SoundId = "A$AP Rocky - Praise The Lord (Da Shine) (Official Video) ft. Skepta.mp3",
        },
        {
            Artwork = "rbxasset://sounds/We.jpg",
            Artist = "Lil Baby x 42 Dugg",
            Song = "We Paid",
            SoundId = "Lil Baby x 42 Dugg - We Paid.mp3",
        },
        {
            Artwork = "rbxasset://sounds/w.jpg",
            Artist = "Radiohead",
            Song = "A Wolf At the Door",
            SoundId = "Radiohead- A Wolf At the Door.mp3",
        },
        {
            Artwork = "rbxasset://sounds/d.jpg",
            Artist = "Dynamite MC",
            Song = "Bounce",
            SoundId = "Dynamite MC- Bounce.mp3",
        },
        {
            Artwork = "rbxasset://sounds/h.jpg",
            Artist = "J.I.D",
            Song = "Slick Talk",
            SoundId = "slick.mp3",
        }
    }

    --Creating all the required states
    local PlaybackLoudness = State(0)

    --Making the sound instance that will play all the music 
    local Sound = New "Sound" {

        --Base props
        Parent = game:GetService("Workspace"),
        Volume = Computed(function()
            return props.Volume:get()
        end),

        --Setting the sound id
        SoundId = Computed(function()
            return "rbxasset://sounds/"..tostring(props.MediaData:get().SoundId)
        end),
    }

    --Updating the playback loudness state
    local prevLoudness = 0
    game:GetService("RunService").RenderStepped:Connect(function()
        if Sound.PlaybackLoudness ~= prevLoudness then
            prevLoudness = Sound.PlaybackLoudness
            PlaybackLoudness:set(Sound.PlaybackLoudness)
        end
    end)


    
    --Pausing and playing the sound
    local Toggle = New "BoolValue" {
        
        Name = "IsPlaying",
        Parent = Sound,
        
        Value = Computed(function()
            if props.IsPlaying:get() then
                -- print("PLaying")
                Sound:Resume()
            else
                Sound:Pause()
            end
            return props.IsPlaying:get()
        end)
        
    }

    --Setting the media data
    props.MediaData:set(MusicQueue[1])
    
    --Writing the music control Functions
    local Skip = function()
        if #MusicQueue == 1 then
            props.IsPlaying:set(true)
            Sound:Play()
        else
            props.IsPlaying:set(true)
            table.remove(MusicQueue,1)
            table.insert(MusicQueue,props.MediaData:get())
            props.MediaData:set(MusicQueue[1])
            Sound:Play()
        end
    end
    
    local Previous = function()
        if #MusicQueue == 1 then
            props.IsPlaying:set(true)
            Sound:Play()
        else
            props.IsPlaying:set(true)
            props.MediaData:set(MusicQueue[#MusicQueue])
            table.remove(MusicQueue,#MusicQueue)
            table.insert(MusicQueue,1,props.MediaData:get())
            Sound:Play()
        end
    end

    --Returning all the info
    return {

        Sound = Sound,
        PlaybackLoudness = PlaybackLoudness,
        Skip = Skip,
        Previous = Previous,
        Destroy = function()
            Sound:Destroy()
            table.clear(MusicQueue)
        end
    }


end

--Returning the music player
return MusicPlayer