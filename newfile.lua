--// Special Just Skip
local PlaceID = game.PlaceId
local AllIDs = {} -- created by nil#3173 server hop isnt my
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))-- created by nil#3173 server hop isnt my
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then-- created by nil#3173 server hop isnt my
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then-- created by nil#3173 server hop isnt my
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end-- created by nil#3173 server hop isnt my
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

for attName, attValue in pairs(game.Lighting:GetAttributes()) do -- created by nil#3173 server hop isnt my
    Phase = attValue
    --[[
    if attValue == 4 then
        Text = "< | Detected: Full Moon! >"
        Notification = require(game.ReplicatedStorage.Notification)
        Notification.new(Text):Display()
    end
    --]]
    if attValue == 5 then
        Text = "< | Detected: Full Moon! >"
        Notification = require(game.ReplicatedStorage.Notification)
        Notification.new(Text):Display()
    else
        if SkipIfSevenPhase == true then
            if attValue == 7 then
                Text = "Seven Phase has Skipped"
                Notification = require(game.ReplicatedStorage.Notification)
                Notification.new(Text):Display()
                wait(3)
                Text = "Teleporting while seven phase"
                Notification = require(game.ReplicatedStorage.Notification)
                Notification.new(Text):Display()
                Teleport()
            end
        else
            if attValue == 7 then
                Text = "Seven Phase has here!"
                Notification = require(game.ReplicatedStorage.Notification)
                Notification.new(Text):Display()
            end
        end
        if SHop == true then
            Text = " Moon Phase: " .. attValue
            Notification = require(game.ReplicatedStorage.Notification)-- created by nil#3173 server hop isnt my
            Notification.new(Text):Display()
            wait(1)
            Text = " Teleporting.."
            Notification = require(game.ReplicatedStorage.Notification)
            Notification.new(Text):Display()
            wait(3)
            Teleport()
        else
            Text = " Moon Phase: " .. attValue
            Notification = require(game.ReplicatedStorage.Notification)
            Notification.new(Text):Display()
        end
    end
end
