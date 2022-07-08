local BumbleMusicPlayer = require(script.Parent.BumbleMusicPlayer)

local BumbleGui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
BumbleGui.Name,BumbleGui.ZIndexBehavior,BumbleGui.IgnoreGuiInset = "BumbleMusicPlayer", Enum.ZIndexBehavior.Sibling, true
BumbleGui.ResetOnSpawn = false

local MusicPlayer = BumbleMusicPlayer {

    Parent = BumbleGui

}