game.ReplicatedStorage.RenameEvent.OnServerEvent:Connect(function(plr, dummy, text)
	local inven = workspace.PlayerData:FindFirstChild(plr.Name)
	local indivs = string.split(inven.Value, "***")
	local bigres = ""
	local res = ""
	for index, indiv in ipairs(indivs) do
		if indiv == dummy then
			local values = string.split(indiv, "##")
			  -- Reset res inside the loop for each renamed indiv

			for i, value in ipairs(values) do
				if i ~= 11 then
					-- Append normally
					if i == #values then
						res = res .. value
					else
						res = res .. value .. "##"
					end
				else
					-- Replace the 11th value with text, add ## if not last
					if i == #values then
						res = res .. text
					else
						res = res .. text .. "##"
					end
				end
			end

			-- Append to bigres with "***" only if NOT last indiv
			if index == #indivs then
				bigres = bigres .. res
			else
				bigres = bigres .. res .. "***"
			end

		else
			-- Append original indiv with "***" only if NOT last indiv
			if index == #indivs then
				bigres = bigres .. indiv
			else
				bigres = bigres .. indiv .. "***"
			end
		end
	end
	-- After building bigres completely:
	if bigres:sub(-3) == "***" then
		bigres = bigres:sub(1, -4) -- remove last 3 chars
	end

	inven.Value = bigres
	print(bigres)
	game.ReplicatedStorage.RenameEvent:FireClient(plr, dummy, res, text)

end)
