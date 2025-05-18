local rs = game:GetService("ReplicatedStorage")
local buttonClone = rs:WaitForChild("TextButton")
local event = rs:WaitForChild("TradeBegin")
local add = rs:WaitForChild("TradeAdd")
local remove = rs:WaitForChild("TradeRemove")
local plr = game.Players.LocalPlayer
local gui = plr.PlayerGui.ScreenGui
local ui = gui.TradeUI
local function odds(dummy)
	local odds = 1
	local colorsum = 21944
	local charmsum = 0 --multiply by 500 at the end
	local facesum = 0
	local auraodds = 3000
	local matodds = 960
	local fireodds = 342
	local songsum = 0
	local animsum = 0
	for _, c in ipairs(workspace:WaitForChild("Charms"):GetChildren()) do
		charmsum += c.Value.Value
	end
	charmsum *= 300
	for _, c in ipairs(workspace:WaitForChild("Faces"):GetChildren()) do
		facesum += c.Value.Value
	end
	facesum -= workspace:WaitForChild("Faces"):WaitForChild("Default").Value.Value
	for _, c in ipairs(workspace:WaitForChild("Songs"):GetChildren()) do
		songsum += c.Value.Value
	end
	for _, c in ipairs(workspace:WaitForChild("Anims"):GetChildren()) do
		animsum += c.Value.Value
	end
	local data = string.split(dummy, "##")
	for i, v in ipairs(data) do
		if i < 7 then
			local props = string.split(v, "!")
			local color = BrickColor.new(props[1]).Number
			odds *= (colorsum / color)
			if props[2] ~= "Plastic" then
				odds *= matodds
			end
		else
			if i==7 then
				if v ~= workspace:WaitForChild("Faces"):WaitForChild("Default").Texture then
					odds *= (facesum / #workspace:WaitForChild("Faces"):GetChildren())
				end
			end
			if i==8 then
				if v ~= "rbxassetid://0" then
					local charm = 1
					local charms = workspace:WaitForChild("Charms")
					for _, d in ipairs(charms:GetChildren()) do
						if d.Texture == v then
							charm = d
							break
						end
					end
					odds *= (charmsum / charm.Value.Value)
				end
			end
			if i==9 then
				if v ~= "None" then
					local props = string.split(v, "!")
					local color = BrickColor.new(props[2]).Number
					odds *= (colorsum / color)
					odds *= auraodds
				end
			end
			if i==12 then
				if v ~= "none" then
					local color = BrickColor.new(v).Number
					odds *= (colorsum / color)
					odds *= fireodds
				end
			end
			if i == 13 then
				if string.split(v, " ")[1] == "Slow" then
					local songs = workspace:WaitForChild("Songs")
					local song = songs:FindFirstChild(string.gsub(v, "Slow ", ""))
					odds *= (songsum / song.Value.Value) * (622 * 2)
				elseif string.split(v, " ")[1] == "Fast" then
					local songs = workspace:WaitForChild("Songs")
					local song = songs:FindFirstChild(string.gsub(v, "Fast ", ""))
					odds *= (songsum / song.Value.Value) * (622 * 2)
				else
					local songs = workspace:WaitForChild("Songs")
					local song = songs:FindFirstChild(v)
					odds *= (songsum / song.Value.Value)
				end
			end
			if i == 14 then
				local song = workspace:WaitForChild("Anims"):FindFirstChild(v)
				odds *= (animsum / song.Value.Value)
			end
		end
	end
	return math.round(odds)
end

local function interpret(dummy)
	local data = string.split(dummy, "##")
	local ui = game.Players.LocalPlayer.PlayerGui.ScreenGui.TradeUI.Stats
	local order = {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
	for i, v in ipairs(data) do
		if i < 7 then
			local props = string.split(v, "!")
			ui:FindFirstChild(order[i]).Text = order[i] .. ": " .. props[1] .. " " .. props[2]
		else
			if i == 7 then
				local decal = v
				local decals = workspace:WaitForChild("Faces")
				for _, d in ipairs(decals:GetChildren()) do
					if d.Texture == v then
						ui.Face.Text = "Face: " .. d.Name
						break
					end
				end
			end
			if i==8 then
				if v ~= "rbxassetid://0" then
					local charm = v
					local charms = workspace:WaitForChild("Charms")
					for _, d in ipairs(charms:GetChildren()) do
						if d.Texture == v then
							ui.Charm.Text = "Charm: " .. d.Name
							break
						end
					end
				else
					ui.Charm.Text = "Charm: None"
				end
			end
			if i==9 then
				local props = string.split(v, "!")
				if props[1] == "Highlight" then
					local color = props[2]
					ui.Aura.Text = "Aura: " .. color .. " Highlight"
				elseif props[1] == "Particle" then
					local color = props[2]
					ui.Aura.Text = "Aura: " .. color .. " Particles"
				elseif props[1] == "Selection" then
					local color = props[2]
					ui.Aura.Text = "Aura: " .. color .. " Selection"
				else
					ui.Aura.Text = "Aura: None"
				end
			end
			if i==10 then
				ui.Id.Text = "Id: " .. v
			end
			if i==11 then
				ui.Title.Text = v
			end
			if i==12 then
				if v ~= "none" then
					local color = v
					ui.Fire.Text = "Fire: " .. color
				else
					ui.Fire.Text = "Fire: None"
				end
			end
			if i==13 then
				ui.Song.Text = "Song: " .. v
			end
			if i==14 then
				ui.Anim.Text = "Pose: " .. v
			end
		end
	end
	ui.Odds.Text = "Odds: 1/" .. odds(dummy)
	if ui.Odds.Text == "Odds: 1/inf" then
		ui.Odds.Text = "Odds: Unobtainable"
	end
end
function pack(dummy)
	local head = dummy.Head
	local torso = dummy.Torso
	local la = dummy["Left Arm"]
	local ra = dummy["Right Arm"]
	local ll = dummy["Left Leg"]
	local rl = dummy["Right Leg"]
	local parts = {head, torso, la, ra, ll, rl}
	local res = ""
	for _, part in ipairs(parts) do
		if res ~= "" then
			res = res .. "##"
		end
		res = res..part.BrickColor.Name.."!"..part.Material.Name
	end
	res = res.."##"..head.face.Texture
	res = res.."##"..head.BillboardGui.ImageLabel.Image
	if head:FindFirstChildOfClass("Highlight") then
		res = res.."##".."Highlight!" .. BrickColor.new(head:FindFirstChildOfClass("Highlight").FillColor).Name
	elseif head:FindFirstChildOfClass("SelectionBox") then
		res = res.."##".."Selection!" .. BrickColor.new(head:FindFirstChildOfClass("SelectionBox").Color3).Name
	elseif head:FindFirstChildOfClass("ParticleEmitter") then
		local particle = head:FindFirstChildOfClass("ParticleEmitter")
		local color3 = particle.Color.Keypoints[1].Value
		res = res.."##".."Particle!" .. BrickColor.new(color3).Name
	else
		res = res.."##".."None"
	end
	res = res.."##"..dummy:FindFirstChild("GlobalId").Value
	res = res.."##"..dummy.Name
	if head:FindFirstChildOfClass("Fire") then
		res = res.."##".. BrickColor.new(head:FindFirstChildOfClass("Fire").Color).Name
	else
		res = res .. "##none"
	end
	local song = head:FindFirstChildOfClass("Sound")
	if song.PlaybackSpeed == .75 then
		res = res .. "##Slow " .. song.Name
	elseif song.PlaybackSpeed == 1.25 then
		res = res .. "##Fast " .. song.Name
	else
		res = res .. "##" .. song.Name
	end
	local anim = dummy:FindFirstChildOfClass("Animation")
	res = res .. "##" .. anim.Name
	return res
end

function renderUI(data:string, owner:Player)
	if data == "" then return end
	data = string.split(data, "##")
	local dummy = game.ReplicatedStorage.Dummy:Clone()
	local order = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
	for i, v in ipairs(data) do
		if i < 7 then
			local part = dummy:FindFirstChild(order[i])
			local properties = string.split(v, "!")
			part.BrickColor = BrickColor.new(properties[1])
			part.Material = Enum.Material[properties[2]]
		else
			if i == 7 then
				dummy.Head.face.Texture = v
			end
			if i == 8 then
				dummy.Head.BillboardGui.ImageLabel.Image = v
				if v ~= "rbxassetid://0" then
					dummy.Head.BillboardGui.ImageLabel.Visible = true
				end
			end
			if i == 9 then
				local props = string.split(v, "!")
				if props[1] == "Highlight" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local highlight = Instance.new("Highlight")
							highlight.FillColor = color.Color
							highlight.Parent = c
						end
					end
				elseif props[1] == "Particle" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local particle = game.ReplicatedStorage.ParticleEmitter:Clone()
							particle.Parent = c
							particle.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, color.Color),
								ColorSequenceKeypoint.new(1, color.Color)
							})
						end
					end
				elseif props[1] == "Selection" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local selectionBox = Instance.new("SelectionBox")
							selectionBox.Adornee = c
							selectionBox.Parent = c
							selectionBox.Color3 = color.Color
						end
					end
				end
			end
			if i == 10 then
				dummy.GlobalId.Value = v
			end
			if i==11 then
				dummy.Name = v
			end
			if i==12 then
				if v ~= "none" then
					local color = BrickColor.new(v).Color
					local fire = Instance.new("Fire")
					fire.Parent = dummy.Head
					fire.Color = color
				end
			end
			if i==13 then
				if string.split(v, " ")[1] == "Slow" then
					local songs = workspace.Songs
					local song = songs:FindFirstChild(string.gsub(v, "Slow ", ""))
					song = song:Clone()
					song.PlaybackSpeed = .75
					song.Parent = dummy.Head
				elseif string.split(v, " ")[1] == "Fast" then
					local songs = workspace.Songs
					local song = songs:FindFirstChild(string.gsub(v, "Fast ", ""))
					song = song:Clone()
					song.PlaybackSpeed = 1.25
					song.Parent = dummy.Head
				else
					local songs = workspace.Songs
					local song = songs:FindFirstChild(v)
					song = song:Clone()
					song.Parent = dummy.Head
				end
			end
			if i==14 then
				local songs = workspace.Anims
				local song = songs:FindFirstChild(v)
				song = song:Clone()
				song.Parent = dummy
			end
		end
	end
	--dummy:PivotTo(workspace.ViewportDummy.HumanoidRootPart.CFrame)
	dummy.Owner.Value = owner
	--game.ReplicatedStorage.Cam:FireClient(owner, office.pack(dummy))
	return pack(dummy)
end
function render(data, owner)
	data = string.split(data, "##")
	local dummy = game.ReplicatedStorage.Dummy:Clone()
	local order = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

	for i, v in ipairs(data) do
		if i < 7 then
			local part = dummy:FindFirstChild(order[i])
			local properties = string.split(v, "!")
			part.BrickColor = BrickColor.new(properties[1])
			part.Material = Enum.Material[properties[2]]
		else
			if i == 7 then
				dummy.Head.face.Texture = v
			end
			if i == 8 then
				dummy.Head.BillboardGui.ImageLabel.Image = v
				if v ~= "rbxassetid://0" then
					dummy.Head.BillboardGui.ImageLabel.Visible = true
				end
			end
			if i == 9 then
				local props = string.split(v, "!")
				if props[1] == "Highlight" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local highlight = Instance.new("Highlight")
							highlight.FillColor = color.Color
							highlight.Parent = c
						end
					end
				elseif props[1] == "Particle" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local particle = game.ReplicatedStorage.ParticleEmitter:Clone()
							particle.Parent = c
							particle.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, color.Color),
								ColorSequenceKeypoint.new(1, color.Color)
							})
						end
					end
				elseif props[1] == "Selection" then
					local color = BrickColor.new(props[2])
					for _, c in ipairs(dummy:GetChildren()) do
						if c:IsA("BasePart") and c.Name ~= "HumanoidRootPart" then
							local selectionBox = Instance.new("SelectionBox")
							selectionBox.Adornee = c
							selectionBox.Parent = c
							selectionBox.Color3 = color.Color
						end
					end
				end
			end
			if i == 10 then
				dummy.GlobalId.Value = v
			end
			if i==11 then
				dummy.Name = v
			end
			if i==12 then
				if v ~= "none" then
					local color = BrickColor.new(v).Color
					local fire = Instance.new("Fire")
					fire.Parent = dummy.Head
					fire.Color = color
				end
			end
			if i==13 then
				if string.split(v, " ")[1] == "Slow" then
					local songs = workspace.Songs
					local song = songs:FindFirstChild(string.gsub(v, "Slow ", ""))
					song = song:Clone()
					song.PlaybackSpeed = .75
					song.Parent = dummy.Head
				elseif string.split(v, " ")[1] == "Fast" then
					local songs = workspace.Songs
					local song = songs:FindFirstChild(string.gsub(v, "Fast ", ""))
					song = song:Clone()
					song.PlaybackSpeed = 1.25
					song.Parent = dummy.Head
				else
					local songs = workspace.Songs
					local song = songs:FindFirstChild(v)
					song = song:Clone()
					song.Parent = dummy.Head
				end
			end
			if i==14 then
				local songs = workspace.Anims
				local song = songs:FindFirstChild(v)
				song = song:Clone()
				song.Parent = dummy
			end
		end
	end
	dummy.Parent = workspace
	dummy.Owner.Value = owner
	dummy:PivotTo(workspace.ViewportDummy.HumanoidRootPart.CFrame)
	--game.ReplicatedStorage.Cam:FireAllClients(dummy)
	return dummy
end
local function loadUI(plr, partner)
	local inven = workspace.PlayerData:FindFirstChild(plr.Name).Value
	local indivs = string.split(inven, "***")
	local sf = ui.Inventory.ScrollingFrame
	local childs = sf:GetChildren()
	for _, c in ipairs(childs) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	for i, indiv in ipairs(indivs) do
		local dummyInstance = render(indiv)
		local button = buttonClone:Clone()
		button.Text = dummyInstance.Name
		button.Dummy.Value = indiv
		button.Parent = ui.Inventory.ScrollingFrame
		button.BackgroundColor = BrickColor.new(string.split(indiv, "!")[1])
		button.Activated:Connect(function()
			local parent = button.Parent
			if parent == ui.Inventory.ScrollingFrame then
				button.Parent = ui.YourOffer.ScrollingFrame
				add:FireServer(partner, button.Dummy.Value)
			end
			if parent == ui.YourOffer.ScrollingFrame then
				button.Parent = ui.Inventory.ScrollingFrame
				remove:FireServer(partner, button.Dummy.Value)
			end
		end)
	end
end
event.OnClientEvent:Connect(function(partner)
	ui.Visible = true
	plr.PlayerGui.ScreenGui.InvenButton.Visible = false
	plr.PlayerGui.ScreenGui.TradeButton.Visible = false
	plr.PlayerGui.ScreenGui.Inventory.Visible = false
	plr.PlayerGui.ScreenGui.Roll.Visible = false
	loadUI(plr, partner)
end)
add.OnClientEvent:Connect(function(button)
	local dummyInstance = render(button)
	local buttons = buttonClone:Clone()
	buttons.Text = dummyInstance.Name
	buttons.Dummy.Value = button
	buttons.Parent = ui.TheirOffer.ScrollingFrame
	buttons.BackgroundColor = BrickColor.new(string.split(button, "!")[1])
	buttons.Activated:Connect(function()
		ui.Stats.Visible = true
		interpret(buttons.Dummy.Value)
	end)
end)
remove.OnClientEvent:Connect(function(button)
	for _, c in ipairs(ui.TheirOffer.ScrollingFrame:GetChildren()) do
		if c:IsA("UIGridLayout") then continue end
		if c.Dummy.Value == button then
			c:Destroy()
		end
	end
end)
rs:WaitForChild("TradeEnd").OnClientEvent:Connect(function()
	ui.Visible = false
	ui.Stats.Visible = false
	plr.PlayerGui.ScreenGui.InvenButton.Visible = true
	plr.PlayerGui.ScreenGui.TradeButton.Visible = true
	plr.PlayerGui.ScreenGui.Roll.Visible = true
end)
rs:WaitForChild("GetOffers").OnClientInvoke = function()
	local data = {}
	for _, c in ipairs(ui.YourOffer.ScrollingFrame:GetChildren()) do
		if not c:IsA("TextButton") then continue end
		table.insert(data, c.Dummy.Value)
		
	end
	ui.Visible = false
	ui.Stats.Visible = false
	plr.PlayerGui.ScreenGui.InvenButton.Visible = true
	plr.PlayerGui.ScreenGui.TradeButton.Visible = true
	plr.PlayerGui.ScreenGui.Roll.Visible = true
	local inventory = plr.PlayerGui.ScreenGui.Inventory.Spaces.Items:GetChildren()
	for i, c in ipairs(inventory) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	for i, c in ipairs(ui.YourOffer.ScrollingFrame:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	for i, c in ipairs(ui.TheirOffer.ScrollingFrame:GetChildren()) do
		if c:IsA("TextButton") then
			c:Destroy()
		end
	end
	return data
end
