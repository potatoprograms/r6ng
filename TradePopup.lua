local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("TradePopup")

event.OnClientEvent:Connect(function(from)
	local frame = script.Parent
	local text = frame.Player
	local image = frame.Icon
	game.Players.LocalPlayer.PlayerGui.PopupSound:Play()
	if frame.Visible then return end
	frame.Visible = true
	text.Text = from.Name .. " wants to trade!"
	local Players = game:GetService("Players")

	local userId = from.UserId -- Replace with a real UserId
	local thumbnailType = Enum.ThumbnailType.HeadShot
	local thumbnailSize = Enum.ThumbnailSize.Size420x420

	local content, isReady = Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
	image.Image = content
	task.wait(6)
	frame.Visible = false
end)
