loadstring(game:HttpGet("https://raw.githubusercontent.com/riieiieie91-byte/slash/refs/heads/main/DiveExecutor_v1.3_350x250.lua"))()


--==================================================
-- ADD X BUTTON FOR SAVED FILES
--==================================================
task.spawn(function()
    local CoreGui = game:GetService("CoreGui")

    -- Chờ Dive Executor gốc tạo giao diện
    local gui
    repeat
        task.wait(0.2)
        gui = CoreGui:FindFirstChild("DiveExecutor")
    until gui

    local frame = gui:FindFirstChild("MainFrame")
    if not frame then return end

    local fileList = frame:FindFirstChild("FileList")
    if not fileList then return end

    local function addDeleteButton(row)
        if not row or not row:IsA("TextButton") then return end
        if row:FindFirstChild("FileDeleteButton") then return end

        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Name = "FileDeleteButton"
        deleteBtn.Parent = row
        deleteBtn.Text = "X"
        deleteBtn.Size = UDim2.new(0, 26, 0, 26)
        deleteBtn.Position = UDim2.new(1, -30, 0, 3)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
        deleteBtn.TextColor3 = Color3.new(1, 1, 1)
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 12
        deleteBtn.BorderSizePixel = 0
        deleteBtn.ZIndex = 100

        local corner = Instance.new("UICorner")
        corner.Parent = deleteBtn
        corner.CornerRadius = UDim.new(0, 6)

        deleteBtn.MouseButton1Click:Connect(function()
            if not delfile then
                return
            end

            -- Lấy tên file từ dòng đang hiển thị
            local displayName = row.Text or ""
            local fileName = displayName:gsub("^📄%s*", "")

            if fileName == "" then
                return
            end

            local path = "DiveExecutor/" .. fileName

            local success, err = pcall(function()
                delfile(path)
            end)

            if success then
                row:Destroy()

                -- Cập nhật CanvasSize
                task.defer(function()
                    local layout = fileList:FindFirstChildOfClass("UIListLayout")
                    if layout then
                        fileList.CanvasSize = UDim2.new(
                            0, 0, 0, layout.AbsoluteContentSize.Y + 10
                        )
                    end
                end)
            end
        end)
    end

    -- Thêm X cho các file đang có
    for _, child in ipairs(fileList:GetChildren()) do
        addDeleteButton(child)
    end

    -- File mới được refresh cũng tự có X
    fileList.ChildAdded:Connect(function(child)
        task.defer(function()
            addDeleteButton(child)
        end)
    end)
end)


--==================================================
-- ADD OPEN / CLOSE ICON ANIMATION
--==================================================
task.spawn(function()
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    local gui
    repeat
        task.wait(0.2)
        gui = CoreGui:FindFirstChild("DiveExecutor")
    until gui

    local mainFrame = gui:FindFirstChild("MainFrame", true)
    if not mainFrame then return end

    local tweenInfo = TweenInfo.new(
        0.22,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )

    local busy = false
    local opened = true

    local function tween(obj, props)
        if obj and obj.Parent then
            TweenService:Create(obj, tweenInfo, props):Play()
        end
    end

    -- Tìm icon/nút dùng để đóng hoặc mở giao diện hiện tại.
    local iconButton
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
            local n = string.lower(obj.Name)
            if n:find("icon") or n:find("toggle")
                or n:find("minimize") or n:find("open")
                or n:find("close") then
                iconButton = obj
                break
            end
        end
    end

    if not iconButton then
        return
    end

    -- Chỉ lưu kích thước. Không lưu Position vì MainFrame có thể được
    -- kéo tới vị trí mới và vị trí đó phải được giữ lại khi đóng/mở.
    local originalSize = mainFrame.Size

    local function openUI()
        if busy then return end
        busy = true
        opened = true

        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(
            originalSize.X.Scale * 0.92,
            originalSize.X.Offset * 0.92,
            originalSize.Y.Scale * 0.92,
            originalSize.Y.Offset * 0.92
        )

        -- Không tween Position: giữ nguyên vị trí hiện tại của Hub.
        tween(mainFrame, {
            Size = originalSize
        })

        task.delay(0.24, function()
            busy = false
        end)
    end

    local function closeUI()
        if busy then return end
        busy = true
        opened = false

        local smallSize = UDim2.new(
            originalSize.X.Scale * 0.92,
            originalSize.X.Offset * 0.92,
            originalSize.Y.Scale * 0.92,
            originalSize.Y.Offset * 0.92
        )

        tween(mainFrame, {
            Size = smallSize
        })

        task.delay(0.18, function()
            if not opened and mainFrame then
                mainFrame.Visible = false
            end
            busy = false
        end)
    end

    -- Nếu script gốc đã có sự kiện MouseButton1Click,
    -- sự kiện này vẫn được thêm vào mà không thay đổi code cũ.
    iconButton.MouseButton1Click:Connect(function()
        if opened then
            closeUI()
        else
            openUI()
        end
    end)
end)
