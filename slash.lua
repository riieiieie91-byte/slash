for _, V in ipairs(game.Players:GetPlayers()) do
    if V ~= game.Players.LocalPlayer and V.Character then
        local targetRoot = V.Character:FindFirstChild("HumanoidRootPart")

        if targetRoot then
            workspace.nguoivnnhavv.GreenSlap.Event:FireServer(
                "slash",
                V.Character,
                Vector3.new(0, -9e9, 0)
            )
        end
    end
end
