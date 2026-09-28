--[[ Dive Executor v1.3 ]]--

pcall(function()
game.CoreGui.DiveExecutor:Destroy()
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local gui = Instance.new("ScreenGui")
gui.Name = "DiveExecutor"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

--==================================================
-- MAIN FRAME
--==================================================

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.3, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner")
frameCorner.Parent = frame
frameCorner.CornerRadius = UDim.new(0, 12)

--==================================================
-- BACKGROUND IMAGE
--==================================================

local background = Instance.new("ImageLabel")
background.Parent = frame
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundTransparency = 1
background.BorderSizePixel = 0
background.Image = "rbxassetid://121698497637602"
background.ScaleType = Enum.ScaleType.Stretch
background.ZIndex = 0

local backgroundCorner = Instance.new("UICorner")
backgroundCorner.Parent = background
backgroundCorner.CornerRadius = UDim.new(0, 12)

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Dive Executor"
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
title.TextColor3 = Color3.fromRGB(180, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner")
titleCorner.Parent = title
titleCorner.CornerRadius = UDim.new(0, 8)

--==================================================
-- CLOSE BUTTON
--==================================================

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = frame
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 10

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeBtn
closeCorner.CornerRadius = UDim.new(0, 6)

--==================================================
-- FLOATING ICON
--==================================================

local openBtn = Instance.new("ImageButton")
openBtn.Parent = gui
openBtn.Name = "DiveIcon"
openBtn.Size = UDim2.new(0, 65, 0, 65)
openBtn.Position = UDim2.new(0, 15, 0.5, -32)
openBtn.Image = "rbxassetid://76913689473312"
openBtn.BackgroundTransparency = 1
openBtn.BorderSizePixel = 0
openBtn.Visible = false
openBtn.ZIndex = 100
openBtn.AutoButtonColor = false

local iconCorner = Instance.new("UICorner")
iconCorner.Parent = openBtn
iconCorner.CornerRadius = UDim.new(1, 0)

--==================================================
-- DRAG ICON
--==================================================

local dragging = false
local dragStart
local startPos
local moved = false

openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        moved = false
        dragStart = input.Position
        startPos = openBtn.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart

        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            moved = true
        end

        openBtn.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        if dragging and not moved then
            frame.Visible = true
            openBtn.Visible = false
        end
        dragging = false
    end
end)

--==================================================
-- CLOSE / OPEN
--==================================================

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    openBtn.Visible = true
end)

--==================================================
-- TAB BAR
--==================================================

local tabBar = Instance.new("Frame")
tabBar.Parent = frame
tabBar.Size = UDim2.new(0, 300, 0, 27)
tabBar.Position = UDim2.new(0, 10, 0, 40)
tabBar.BackgroundTransparency = 1
tabBar.BorderSizePixel = 0
tabBar.ClipsDescendants = true

local tabs = {}
local currentTab = 1
local nextTabId = 1

--==================================================
-- TEXTBOX
--==================================================

local textbox = Instance.new("TextBox")
textbox.Parent = frame
textbox.PlaceholderText = "-- Paste script here..."
textbox.Text = ""
textbox.Position = UDim2.new(0.05, 0, 0.31, 0)
textbox.Size = UDim2.new(0.9, 0, 0.40, 0)
textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.TextXAlignment = Enum.TextXAlignment.Left
textbox.TextYAlignment = Enum.TextYAlignment.Top
textbox.ClearTextOnFocus = false
textbox.MultiLine = true
textbox.TextWrapped = true
textbox.Font = Enum.Font.Code
textbox.TextSize = 12
textbox.BorderSizePixel = 0

local boxCorner = Instance.new("UICorner")
boxCorner.Parent = textbox
boxCorner.CornerRadius = UDim.new(0, 8)

--==================================================
-- NOTIFICATION
--==================================================

local function notify(message, color)
    local msg = Instance.new("TextLabel")
    msg.Parent = gui
    msg.Size = UDim2.new(0, 220, 0, 35)
    msg.Position = UDim2.new(0.35, 0, 0.05, 0)
    msg.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
    msg.Text = message
    msg.Font = Enum.Font.Gotham
    msg.TextColor3 = Color3.new(1, 1, 1)
    msg.TextScaled = true
    msg.BorderSizePixel = 0
    msg.ZIndex = 200

    local corner = Instance.new("UICorner")
    corner.Parent = msg
    corner.CornerRadius = UDim.new(0, 8)

    task.spawn(function()
        task.wait(2.5)

        for i = 1, 10 do
            msg.TextTransparency += 0.1
            msg.BackgroundTransparency += 0.1
            task.wait(0.05)
        end

        msg:Destroy()
    end)
end

--==================================================
-- CREATE TAB
--==================================================

local function createTabButton(tab)
    local button = Instance.new("TextButton")
    button.Parent = tabBar
    button.Name = "TabButton"
    button.Size = UDim2.new(0, 72, 0, 25)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 10
    button.BorderSizePixel = 0
    button.Text = tab.name

    local corner = Instance.new("UICorner")
    corner.Parent = button
    corner.CornerRadius = UDim.new(0, 5)

    local delete = Instance.new("TextButton")
    delete.Parent = button
    delete.Name = "Delete"
    delete.Text = "X"
    delete.Size = UDim2.new(0, 18, 0, 18)
    delete.Position = UDim2.new(1, -20, 0, 3)
    delete.BackgroundTransparency = 1
    delete.TextColor3 = Color3.fromRGB(255, 100, 100)
    delete.Font = Enum.Font.GothamBold
    delete.TextSize = 10
    delete.BorderSizePixel = 0

    button.MouseButton1Click:Connect(function()
        if currentTab ~= tab.id then
            tabs[currentTab].text = textbox.Text
            currentTab = tab.id
            textbox.Text = tab.text
        end
    end)

    delete.MouseButton1Click:Connect(function()
        if #tabs <= 1 then
            notify("Cannot delete the last tab", Color3.fromRGB(255, 80, 80))
            return
        end

        for i, t in ipairs(tabs) do
            if t == tab then
                table.remove(tabs, i)
                break
            end
        end

        button:Destroy()

        for i, t in ipairs(tabs) do
            t.id = i

            if t.button then
                t.button.Position = UDim2.new(0, (i - 1) * 75, 0, 0)
            end
        end

        currentTab = math.clamp(currentTab, 1, #tabs)
        textbox.Text = tabs[currentTab].text
    end)

    tab.button = button
    button.Position = UDim2.new(0, (#tabs - 1) * 75, 0, 0)
end

--==================================================
-- FIRST TAB
--==================================================

local firstTab = {
    id = 1,
    name = "Script 1",
    text = ""
}

table.insert(tabs, firstTab)
createTabButton(firstTab)

--==================================================
-- ADD TAB
--==================================================

local addTabBtn = Instance.new("TextButton")
addTabBtn.Parent = frame
addTabBtn.Text = "+"
addTabBtn.Size = UDim2.new(0, 25, 0, 25)
addTabBtn.Position = UDim2.new(1, -35, 0, 40)
addTabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
addTabBtn.TextColor3 = Color3.new(1, 1, 1)
addTabBtn.Font = Enum.Font.GothamBold
addTabBtn.TextSize = 18
addTabBtn.BorderSizePixel = 0

local addCorner = Instance.new("UICorner")
addCorner.Parent = addTabBtn
addCorner.CornerRadius = UDim.new(0, 5)

addTabBtn.MouseButton1Click:Connect(function()
    tabs[currentTab].text = textbox.Text

    nextTabId += 1

    local newTab = {
        id = #tabs + 1,
        name = "Script " .. nextTabId,
        text = ""
    }

    table.insert(tabs, newTab)
    currentTab = newTab.id
    createTabButton(newTab)
    textbox.Text = ""

    notify(
        "➕ " .. newTab.name .. " created",
        Color3.fromRGB(50, 180, 120)
    )
end)

--==================================================
-- ATTACH
--==================================================

local attachBtn = Instance.new("TextButton")
attachBtn.Parent = frame
attachBtn.Text = "Attach"
attachBtn.Size = UDim2.new(0, 70, 0, 28)
attachBtn.Position = UDim2.new(0.05, 0, 0.82, 0)
attachBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 200)
attachBtn.TextColor3 = Color3.new(1, 1, 1)
attachBtn.Font = Enum.Font.GothamBold
attachBtn.TextScaled = true
attachBtn.BorderSizePixel = 0

local attachCorner = Instance.new("UICorner")
attachCorner.Parent = attachBtn
attachCorner.CornerRadius = UDim.new(0, 8)

attachBtn.MouseButton1Click:Connect(function()
    notify(
        "Attached to Roblox Player",
        Color3.fromRGB(0, 200, 255)
    )
end)

--==================================================
-- CLEAR
--==================================================

local clearBtn = Instance.new("TextButton")
clearBtn.Parent = frame
clearBtn.Text = "Clear"
clearBtn.Size = UDim2.new(0, 70, 0, 28)
clearBtn.Position = UDim2.new(0.39, 0, 0.82, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 180)
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextScaled = true
clearBtn.BorderSizePixel = 0

local clearCorner = Instance.new("UICorner")
clearCorner.Parent = clearBtn
clearCorner.CornerRadius = UDim.new(0, 8)

clearBtn.MouseButton1Click:Connect(function()
    textbox.Text = ""
    tabs[currentTab].text = ""

    notify(
        "🗑 Script cleared",
        Color3.fromRGB(100, 80, 180)
    )
end)

--==================================================
-- FILESYSTEM
--==================================================

local WORKSPACE_FOLDER = "DiveExecutor"

local function setupFolder()
    if not isfolder or not makefolder then
        return false
    end

    local success = pcall(function()
        if not isfolder(WORKSPACE_FOLDER) then
            makefolder(WORKSPACE_FOLDER)
        end
    end)

    if not success then
        return false
    end

    return isfolder(WORKSPACE_FOLDER)
end

--==================================================
-- SAVE
--==================================================

local saveBtn = Instance.new("TextButton")
saveBtn.Parent = frame
saveBtn.Text = "Save"
saveBtn.Size = UDim2.new(0, 70, 0, 22)
saveBtn.Position = UDim2.new(0.39, 0, 0.935, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(50, 140, 200)
saveBtn.TextColor3 = Color3.new(1, 1, 1)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextScaled = true
saveBtn.BorderSizePixel = 0
saveBtn.ZIndex = 20

local saveCorner = Instance.new("UICorner")
saveCorner.Parent = saveBtn
saveCorner.CornerRadius = UDim.new(0, 6)

--==================================================
-- SAVE NAME POPUP
--==================================================

local savePopup = Instance.new("Frame")
savePopup.Parent = frame
savePopup.Name = "SavePopup"
savePopup.Size = UDim2.new(0, 210, 0, 105)
savePopup.Position = UDim2.new(0.5, -105, 0.5, -52)
savePopup.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
savePopup.BorderSizePixel = 0
savePopup.Visible = false
savePopup.ZIndex = 100

local savePopupCorner = Instance.new("UICorner")
savePopupCorner.Parent = savePopup
savePopupCorner.CornerRadius = UDim.new(0, 8)

local nameBox = Instance.new("TextBox")
nameBox.Parent = savePopup
nameBox.Name = "Name"
nameBox.PlaceholderText = "Name"
nameBox.Text = ""
nameBox.Size = UDim2.new(1, -20, 0, 35)
nameBox.Position = UDim2.new(0, 10, 0, 10)
nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
nameBox.TextColor3 = Color3.new(1, 1, 1)
nameBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 13
nameBox.ClearTextOnFocus = false
nameBox.BorderSizePixel = 0
nameBox.ZIndex = 101

local nameCorner = Instance.new("UICorner")
nameCorner.Parent = nameBox
nameCorner.CornerRadius = UDim.new(0, 6)

local popupSave = Instance.new("TextButton")
popupSave.Parent = savePopup
popupSave.Name = "Save"
popupSave.Text = "Save"
popupSave.Size = UDim2.new(0, 90, 0, 32)
popupSave.Position = UDim2.new(0.5, -45, 1, -42)
popupSave.BackgroundColor3 = Color3.fromRGB(50, 180, 110)
popupSave.TextColor3 = Color3.new(1, 1, 1)
popupSave.Font = Enum.Font.GothamBold
popupSave.TextSize = 12
popupSave.BorderSizePixel = 0
popupSave.ZIndex = 101

local popupSaveCorner = Instance.new("UICorner")
popupSaveCorner.Parent = popupSave
popupSaveCorner.CornerRadius = UDim.new(0, 6)

local function saveScript(fileName)
    if not writefile then
        notify(
            "❌ Filesystem unavailable",
            Color3.fromRGB(255, 60, 60)
        )
        return
    end

    if not setupFolder() then
        notify(
            "❌ Cannot create DiveExecutor folder",
            Color3.fromRGB(255, 60, 60)
        )
        return
    end

    local scriptCode = textbox.Text

    if scriptCode == "" then
        notify(
            "❌ No script to save",
            Color3.fromRGB(255, 80, 80)
        )
        return
    end

    fileName = tostring(fileName or "")
    fileName = fileName:gsub("^%s+", ""):gsub("%s+$", "")

    if fileName == "" then
        notify(
            "❌ Enter a file name",
            Color3.fromRGB(255, 80, 80)
        )
        return
    end

    -- Loại bỏ ký tự không hợp lệ trong tên file
    fileName = fileName:gsub('[\\/:*?"<>|]', "_")

    if string.lower(string.sub(fileName, -4)) ~= ".lua" then
        fileName = fileName .. ".lua"
    end

    local filePath = WORKSPACE_FOLDER .. "/" .. fileName

    local success, err = pcall(function()
        writefile(filePath, scriptCode)
    end)

    if success then
        savePopup.Visible = false
        nameBox.Text = ""

        notify(
            "💾 Saved: " .. fileName,
            Color3.fromRGB(50, 180, 120)
        )
    else
        notify(
            "❌ Save error: " .. tostring(err),
            Color3.fromRGB(255, 60, 60)
        )
    end
end

saveBtn.MouseButton1Click:Connect(function()
    if textbox.Text == "" then
        notify(
            "❌ No script to save",
            Color3.fromRGB(255, 80, 80)
        )
        return
    end

    savePopup.Visible = true
    nameBox.Text = tabs[currentTab].name
    nameBox:CaptureFocus()
end)

popupSave.MouseButton1Click:Connect(function()
    saveScript(nameBox.Text)
end)

nameBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and savePopup.Visible then
        saveScript(nameBox.Text)
    end
end)

--==================================================
-- FILE MANAGER
--==================================================

local fileManagerOpen = false

local fileList = Instance.new("ScrollingFrame")
fileList.Parent = frame
fileList.Name = "FileList"
fileList.Position = UDim2.new(0.05, 0, 0.31, 0)
fileList.Size = UDim2.new(0.9, 0, 0.40, 0)
fileList.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
fileList.BorderSizePixel = 0
fileList.ScrollBarThickness = 5
fileList.Visible = false
fileList.ZIndex = 50

local fileCorner = Instance.new("UICorner")
fileCorner.Parent = fileList
fileCorner.CornerRadius = UDim.new(0, 8)

local fileLayout = Instance.new("UIListLayout")
fileLayout.Parent = fileList
fileLayout.Padding = UDim.new(0, 5)
fileLayout.SortOrder = Enum.SortOrder.LayoutOrder

local backBtn = Instance.new("TextButton")
backBtn.Parent = frame
backBtn.Text = "← Script"
backBtn.Size = UDim2.new(0, 75, 0, 22)
backBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
backBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
backBtn.TextColor3 = Color3.new(1, 1, 1)
backBtn.Font = Enum.Font.GothamBold
backBtn.TextSize = 11
backBtn.BorderSizePixel = 0
backBtn.Visible = false
backBtn.ZIndex = 60

local backCorner = Instance.new("UICorner")
backCorner.Parent = backBtn
backCorner.CornerRadius = UDim.new(0, 6)

local function clearFileList()
    for _, child in ipairs(fileList:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function loadFile(path, name)
    if not readfile then
        notify(
            "❌ readfile unavailable",
            Color3.fromRGB(255, 60, 60)
        )
        return
    end

    local success, content = pcall(function()
        return readfile(path)
    end)

    if not success then
        notify(
            "❌ Cannot read file",
            Color3.fromRGB(255, 60, 60)
        )
        return
    end

    fileManagerOpen = false
    fileList.Visible = false
    backBtn.Visible = false
    textbox.Visible = true
    textbox.Text = content
    tabs[currentTab].text = content

    notify(
        "📂 Loaded: " .. name,
        Color3.fromRGB(50, 150, 220)
    )
end

local function refreshFiles()
    clearFileList()

    if not listfiles then
        local empty = Instance.new("TextLabel")
        empty.Parent = fileList
        empty.Size = UDim2.new(1, -10, 0, 35)
        empty.BackgroundTransparency = 1
        empty.Text = "listfiles không được hỗ trợ"
        empty.TextColor3 = Color3.fromRGB(255, 150, 150)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        empty.ZIndex = 60
        return
    end

    if not setupFolder() then
        local empty = Instance.new("TextLabel")
        empty.Parent = fileList
        empty.Size = UDim2.new(1, -10, 0, 35)
        empty.BackgroundTransparency = 1
        empty.Text = "Không tạo được thư mục DiveExecutor"
        empty.TextColor3 = Color3.fromRGB(255, 150, 150)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        empty.ZIndex = 60
        return
    end

    local success, files = pcall(function()
        return listfiles(WORKSPACE_FOLDER)
    end)

    if not success or type(files) ~= "table" then
        local empty = Instance.new("TextLabel")
        empty.Parent = fileList
        empty.Size = UDim2.new(1, -10, 0, 35)
        empty.BackgroundTransparency = 1
        empty.Text = "📁 Chưa có file nào"
        empty.TextColor3 = Color3.fromRGB(180, 180, 200)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        empty.ZIndex = 60
        return
    end

    local count = 0

    for _, path in ipairs(files) do
        if string.lower(string.sub(path, -4)) == ".lua" then
            count += 1

            local name =
                string.match(path, "([^/\\]+)$")
                or path

            local button = Instance.new("TextButton")
            button.Parent = fileList
            button.Size = UDim2.new(1, -10, 0, 32)
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Text = "📄 " .. name
            button.Font = Enum.Font.Gotham
            button.TextSize = 12
            button.BorderSizePixel = 0
            button.ZIndex = 60

            local corner = Instance.new("UICorner")
            corner.Parent = button
            corner.CornerRadius = UDim.new(0, 6)

            button.MouseButton1Click:Connect(function()
                loadFile(path, name)
            end)
        end
    end

    if count == 0 then
        local empty = Instance.new("TextLabel")
        empty.Parent = fileList
        empty.Size = UDim2.new(1, -10, 0, 35)
        empty.BackgroundTransparency = 1
        empty.Text = "📁 Chưa có file nào"
        empty.TextColor3 = Color3.fromRGB(180, 180, 200)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 12
        empty.ZIndex = 60
    end

    fileList.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            fileLayout.AbsoluteContentSize.Y + 10
        )
end

--==================================================
-- F BUTTON
--==================================================

local fileBtn = Instance.new("TextButton")
fileBtn.Parent = frame
fileBtn.Text = "F"
fileBtn.Size = UDim2.new(0, 45, 0, 22)
fileBtn.Position = UDim2.new(0.73, 0, 0.935, 0)
fileBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 40)
fileBtn.TextColor3 = Color3.new(1, 1, 1)
fileBtn.Font = Enum.Font.GothamBold
fileBtn.TextSize = 12
fileBtn.BorderSizePixel = 0
fileBtn.ZIndex = 20

local fileBtnCorner = Instance.new("UICorner")
fileBtnCorner.Parent = fileBtn
fileBtnCorner.CornerRadius = UDim.new(0, 6)

fileBtn.MouseButton1Click:Connect(function()
    fileManagerOpen = true
    textbox.Visible = false
    fileList.Visible = true
    backBtn.Visible = true
    refreshFiles()
end)

backBtn.MouseButton1Click:Connect(function()
    fileManagerOpen = false
    fileList.Visible = false
    backBtn.Visible = false
    textbox.Visible = true
end)

--==================================================
-- EXECUTE
--==================================================

local execBtn = Instance.new("TextButton")
execBtn.Parent = frame
execBtn.Text = "Execute"
execBtn.Size = UDim2.new(0, 70, 0, 28)
execBtn.Position = UDim2.new(0.73, 0, 0.82, 0)
execBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
execBtn.TextColor3 = Color3.new(1, 1, 1)
execBtn.Font = Enum.Font.GothamBold
execBtn.TextScaled = true
execBtn.BorderSizePixel = 0

local execCorner = Instance.new("UICorner")
execCorner.Parent = execBtn
execCorner.CornerRadius = UDim.new(0, 8)

execBtn.MouseButton1Click:Connect(function()
    local code = textbox.Text

    if code == "" then
        notify(
            "❌ No script to execute",
            Color3.fromRGB(255, 80, 80)
        )
        return
    end

    local success, err = pcall(function()
        loadstring(code)()
    end)

    if success then
        notify(
            "✅ Script executed!",
            Color3.fromRGB(50, 255, 100)
        )
    else
        notify(
            "❌ Error: " .. tostring(err),
            Color3.fromRGB(255, 50, 50)
        )
    end
end)

--==================================================
-- RIGHT SHIFT
--==================================================

local open = true

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        open = not open
        frame.Visible = open
        openBtn.Visible = not open
    end
end)

--==================================================
-- LAUNCH
--==================================================

notify(
    "Dive Executor has launched.",
    Color3.fromRGB(0, 120, 255)
)
