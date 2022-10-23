local Statistics = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 42 },
    Text = {
        Left = { X = -40, Y = 15, Scale = 0.35 },
    },
    Bar = { X = 190, Y = 27, Width = 250, Height = 10 },
    Divider = {
        [1] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [2] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [3] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [4] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [5] = { X = 200, Y = 27, Width = 2, Height = 10 },
    }
}

---StatisticPanel
---@param Percent number
---@param Text string
---@param Index number
---@return void
---@public
function RageUI.StatisticPanel(Percent, Text, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() and (Index == nil or (CurrentMenu.Index == Index)) then

            ---@type number
            RenderRectangle(CurrentMenu.X, CurrentMenu.Y + Statistics.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + (RageUI.StatisticPanelCount * 42), Statistics.Background.Width + CurrentMenu.WidthOffset, Statistics.Background.Height, 0, 0, 0, 170)
            RenderText(Text or "", CurrentMenu.X + Statistics.Text.Left.X + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Text.Left.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, Statistics.Text.Left.Scale, 245, 245, 245, 255, 0)
            RenderRectangle(CurrentMenu.X + Statistics.Bar.X + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Statistics.Bar.Width, Statistics.Bar.Height, 87, 87, 87, 255)
            RenderRectangle(CurrentMenu.X + Statistics.Bar.X + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Percent * Statistics.Bar.Width, Statistics.Bar.Height, 255, 255, 255, 255)
            for i = 1, #Statistics.Divider, 1 do
                RenderRectangle(CurrentMenu.X + i * 40 + 193 + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Divider[i].Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Statistics.Divider[i].Width, Statistics.Divider[i].Height, 0, 0, 0, 255)
            end
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end



---StatisticPanelAdvanced
---@param Percent number
---@param RGBA1 Table {R,G,B,A}
---@param Percent2 number
---@param RGBA2 Table {R,G,B,A}
---@param RGBA3 Table {R,G,B,A}
---@param Text string
---@param Index number
---@return void
---@public
function RageUI.StatisticPanelAdvanced(Text, Percent, RGBA1, Percent2, RGBA2, RGBA3, Index)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() and (Index == nil or (CurrentMenu.Index == Index)) then


            RGBA1 = RGBA1 or {255,255,255,255}

            ---@type number
            RenderRectangle(CurrentMenu.X, CurrentMenu.Y + Statistics.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + (RageUI.StatisticPanelCount * 42), Statistics.Background.Width + CurrentMenu.WidthOffset, Statistics.Background.Height, 0, 0, 0, 170)
            RenderText(Text or "", CurrentMenu.X + Statistics.Text.Left.X + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Text.Left.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, Statistics.Text.Left.Scale, 245, 245, 245, 255, 0)
            RenderRectangle(CurrentMenu.X + Statistics.Bar.X + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Statistics.Bar.Width, Statistics.Bar.Height, 87, 87, 87, 255)
            RenderRectangle(CurrentMenu.X + Statistics.Bar.X + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Percent * Statistics.Bar.Width, Statistics.Bar.Height, RGBA1[1], RGBA1[2], RGBA1[3], RGBA1[4])
            

            RGBA2 = RGBA2 or {0, 153, 204,255}
            RGBA3 = RGBA3 or {185, 0, 0,255}

            if Percent2 and Percent2 > 0 then
                local X = CurrentMenu.X + Statistics.Bar.X + (CurrentMenu.WidthOffset / 2)+Percent * Statistics.Bar.Width
                RenderRectangle(X, (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Percent2 * Statistics.Bar.Width, Statistics.Bar.Height, RGBA2[1], RGBA2[2], RGBA2[3], RGBA2[4])
            elseif Percent2 and Percent2 < 0 then
                local X = CurrentMenu.X + Statistics.Bar.X + (CurrentMenu.WidthOffset / 2)+Percent * Statistics.Bar.Width
                RenderRectangle(X, (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Percent2 * Statistics.Bar.Width, Statistics.Bar.Height, RGBA3[1], RGBA3[2], RGBA3[3], RGBA3[4])
            end

            for i = 1, #Statistics.Divider, 1 do
                RenderRectangle(CurrentMenu.X + i * 40 + 193 + (CurrentMenu.WidthOffset / 2), (RageUI.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Divider[i].Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Statistics.Divider[i].Width, Statistics.Divider[i].Height, 0, 0, 0, 255)
            end

            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end

