	function Window:Notify(title, text, duration)
		local toastTitle = tostring(title or "Notification")
		local toastText = tostring(text or "")
		local toastDuration = tonumber(duration) or 3

		if type(text) == "number" and duration == nil then
			toastText = ""
			toastDuration = tonumber(text) or 3
		elseif type(text) == "string" and type(duration) == "string" then
			toastText = tostring(text) .. " " .. tostring(duration)
			toastDuration = 3
		end

		if not self.NotificationHolder then
			local holder = createFrame(windowGui, {
				Name = "NotificationHolder",
				Size = UDim2.new(0, 280, 0, 200),
				Position = UDim2.new(1, -300, 1, -120),
				AnchorPoint = Vector2.new(1, 1),
				BackgroundTransparency = 1,
			})
			self.NotificationHolder = holder
		end

		local toast = createFrame(self.NotificationHolder, {
			Name = "Toast",
			Size = UDim2.new(1, 0, 0, 58),
			BackgroundColor3 = self.Theme.Card,
			BackgroundTransparency = 0.07,
		})
		createCorner(toast, 10)
		createStroke(toast, self.Theme.Accent, 1, 0.35)

		local side = createFrame(toast, {
			Name = "SideBar",
			Size = UDim2.new(0, 4, 1, 0),
			BackgroundColor3 = self.Theme.Accent,
		})
		createCorner(side, 10)

		createTextLabel(toast, {
			Name = "Title",
			Text = toastTitle,
			TextColor3 = self.Theme.Text,
			TextSize = 11,
			Font = Enum.Font.GothamBlack,
			Position = UDim2.new(0, 14, 0, 8),
			Size = UDim2.new(1, -28, 0, 16),
		})
		createTextLabel(toast, {
			Name = "Text",
			Text = toastText,
			TextColor3 = self.Theme.SubText,
			TextSize = 10,
			Font = Enum.Font.Gotham,
			Position = UDim2.new(0, 14, 0, 22),
			Size = UDim2.new(1, -28, 0, 22),
			TextWrapped = true,
		})

		local current = #self.NotificationHolder:GetChildren()
		if current > 0 then
			local prev = self.NotificationHolder:FindFirstChild("Toast")
			if prev then
				prev.Position = UDim2.new(0, 0, 0, 0)
			end
		end

		task.delay(toastDuration, function()
			if toast and toast.Parent then
				TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1,
				}):Play()
				task.wait(0.2)
				safeDestroy(toast)
			end
		end)
	end