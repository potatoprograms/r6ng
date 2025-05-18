script.Parent.Activated:Connect(function()
	local frame = script.Parent.Parent.PlayersToTrade.ScrollingFrame
	if frame.Parent.Visible then
		frame.Parent.Visible = false
		for _, c in ipairs(frame:GetChildren()) do
			if c:IsA("UIListLayout") then continue end
			c:Destroy()
		end
	else
		frame.Parent.Visible = true
		local players = game.Players:GetPlayers()
		if #players ==1 then return end
		players = table.remove(players, table.find(players, game.Players.LocalPlayer))
		for i, player in ipairs(players) do
			local template = game:GetService("ReplicatedStorage"):WaitForChild("PlayerTemplate"):Clone()
			local text = template.Player
			local image = template.Icon
			text.Text = player.Name
			local Players = game:GetService("Players")

			local userId = player.UserId -- Replace with a real UserId
			local thumbnailType = Enum.ThumbnailType.HeadShot
			local thumbnailSize = Enum.ThumbnailSize.Size420x420

			local content, isReady = Players:GetUserThumbnailAsync(userId, thumbnailType, thumbnailSize)
			image.Image = content
			template.Parent = frame
			template.Name = player.Name
			local conn
			conn = text.Activated:Connect(function()
				local to = game.Players:FindFirstChild(text.Text)
				if not to then return end
				game:GetService("ReplicatedStorage"):WaitForChild("TradePopup"):FireServer(to)
				frame.Parent.Visible = false
				conn:Disconnect()
			end)
		end
	end
end)
