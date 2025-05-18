local rs = game:GetService("ReplicatedStorage")
local event = rs:WaitForChild("TradeBegin")
script.Parent.Activated:Connect(function()
	local text= script.Parent.Parent.Player.Text
	text = string.gsub(text, " wants to trade!", "")
	local player = game.Players:FindFirstChild(text)
	if not player then return end
	event:FireServer(player)
	script.Parent.Parent.Visible = false
end)
