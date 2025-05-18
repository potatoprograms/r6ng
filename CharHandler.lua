game.ReplicatedStorage.EquipDummy.OnServerEvent:Connect(function(plr, dummy)
	local po= require(script.Parent.Roll.PostOffice)
	local char = po.renderAsChar(dummy, plr)
end)
