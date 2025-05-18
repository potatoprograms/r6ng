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
	local ui = game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Spaces.Stats
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


script.Parent.Activated:Connect(function()
	local mini = script.Parent.Parent.Selected.Value
	if mini then
		local dummy = mini.Dummy.Value
		local ui = game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Spaces.Stats
		if ui.Visible and script.Parent.Viewing.Value == mini then
			ui.Visible = false
			script.Parent.Viewing.Value = nil
		else
			ui.Visible = true
			interpret(dummy)
			script.Parent.Viewing.Value = mini
		end
	end
end)
script.Parent.Parent.Selected.Changed:Connect(function()
	if game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Spaces.Stats.Visible == true and script.Parent.Parent.Selected.Value then
		local mini = script.Parent.Parent.Selected.Value
		if mini then
			local dummy = mini.Dummy.Value
			local ui = game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Spaces.Stats
			if ui.Visible and script.Parent.Viewing.Value == mini then
				ui.Visible = false
				script.Parent.Viewing.Value = nil
			else
				ui.Visible = true
				interpret(dummy)
				script.Parent.Viewing.Value = mini
			end
		end
	end
end)
