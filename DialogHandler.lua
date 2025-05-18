local server = game.ReplicatedStorage.Dialog.ServerDialog
local client = game.ReplicatedStorage.Dialog.ClientDialog

server.Event:Connect(function(plr, dialog, partner, opts)
	print(plr, dialog, partner, opts)
	client:FireClient(plr, dialog, partner, opts)
end)
client.OnServerEvent:Connect(function(plr, dialog, partner)
	if dialog == "I want the badge!" and partner.Name == "Sheriff" then
		client:FireClient(plr, "First, you must get arrested 10 times.", partner, {"Sure can do!", "No thanks."})
	elseif dialog == "Sure can do!" and partner.Name == "Sheriff" and workspace.Arests:FindFirstChild(plr.Name).Value >= 10 then
		client:FireClient(plr, "Excellent, now you must find me a doubloon for my troubles.", partner, {"Got it.", "No thanks."})
	elseif dialog == "Got it." and partner.Name == "Sheriff" and (plr.Backpack:FindFirstChild("Doubloon") or plr.Character:FindFirstChild("Doubloon")) then
		client:FireClient(plr, "Great job! Here you go!", partner, {"Thanks!"})
		if plr.Backpack:FindFirstChild("Doubloon") then
			plr.Backpack:FindFirstChild("Doubloon"):Destroy()
		elseif plr.Character:FindFirstChild("Doubloon") then
			plr.Character:FindFirstChild("Doubloon"):Destroy()
		end
	elseif dialog == "I want an egg salad sandwich" and partner.Name == "Sheriff" then
		client:FireClient(plr, "That will be one doubloon, please.", partner, {"Yes, sir!", "No thanks."})
	elseif dialog == "Yes, sir!" and partner.Name == "Sheriff" and (plr.Backpack:FindFirstChild("Doubloon") or plr.Character:FindFirstChild("Doubloon")) then
		client:FireClient(plr, "Great job! Here you go!", partner, {"Thanks!"})
		if plr.Backpack:FindFirstChild("Doubloon") then
			plr.Backpack:FindFirstChild("Doubloon"):Destroy()
		elseif plr.Character:FindFirstChild("Doubloon") then
			plr.Character:FindFirstChild("Doubloon"):Destroy()
		end
	elseif dialog == "What?" and partner.Name == "Robert Robingson the 9th" then
		client:FireClient(plr,"Go rob the bank and ill split the profit",partner,{"Sure can do!","No."})
	elseif dialog == "Sure can do!" and partner.Name == "Robert Robingson the 9th" and workspace.HasRobbed:FindFirstChild(plr.Name).Value then
		client:FireClient(plr,"Good now scram",partner,{"Ok"})
	end
end)
