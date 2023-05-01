--[[
Easy Loadstring

getgenv().RCONSOLEMODE = true
getgenv().RCONSOLEPRINTMODE = "IntConsole"
getgenv().AutoUpdate_OESP = true
loadstring(game:HttpGet("https://raw.githubusercontent.com/BruhSoundEffect2081/-/main/OLIB_Backup.lua"))()
]]
repeat game:GetService("RunService").Heartbeat:Wait() until game:IsLoaded()
local StartTick = tick()
local Players = game.Players or game:GetService("Players")
local Workspace = game.Workspace or game:GetService("Workspace")
local RunService = game.RunService or game:GetService("RunService")

getgenv().RCP = function(Message,Color,Clear)
    coroutine.wrap(function()
        if not RCONSOLEMODE then return end
        local Send = ""
        local Colors = {
            ["message"] = "LIGHT_BLUE";
            ["error"] = "RED";
            ["nicemessage"] = "LIGHT_GREEN";
            ["dark"] = "DARK_GRAY";
            ["remove"] = "LIGHT_RED";
        }
        if typeof(Message) == "table" then
            for _,v in pairs(Message) do 
                Send = Send..tostring(v).." "
            end
        else
            Send = tostring(Message)
        end
        if RCONSOLEPRINTMODE == "IntConsole" then
            printconsole(Send,245,188,66)
        else
            if Clear then rconsoleclear() return end
            if Color then if Colors[Color] then rconsoleprint("@@"..Colors[Color].."@@") end end
            rconsoleprint(Send.."\n")
        end
    end)()
end
RCP("","",true)

local ErrorStatus,ErrorMessage = pcall(function()
-- PCALL START

if ESPStorage then
    for id,table in pairs(ESPStorage) do
        RCP({"Removed",id},"dark")
        table["Delete"]()
    end
end

RCP({"O-ESP Version V1.5"},"nicemessage")
RCP({"O-ESP Lib Loading"},"message")
RCP({"O-ESP Creating ESP Functions",},"message")
getgenv().ESPGroups = {}
getgenv().ESPStorage = {}
getgenv().ESP = {
    
    Setting = function(Name,Val)
        if not Name and not Val then return end
        getgenv().ESPSettings[Name] = val
        return
    end;
    
    ToggleGroup = function(Group,Forced)
        if ESP.CheckGroup(Group) == true or ESP.CheckGroup(Group) == false then
            if not Forced then
                ESPGroups[Group] = not ESPGroups[Group]
            else
                ESPGroups[Group] = Forced
            end
            RCP({"O-ESP Toggled Group",Group,tostring(Forced)},"nicemessage")
        else
            RCP({"O-ESP Group Doesn't Exist, Creating",Group,tostring(Forced)},"nicemessage")
            ESP.CreateGroup(Group,Forced or false)
        end
        return
    end;
    
    CheckGroup = function(Check)
        if ESPGroups[Check] == true or ESPGroups[Check] == false then
            return ESPGroups[Check]
        end
        return "not a thing bucko."
    end;
    
    CreateGroup = function(New,Default)
        if not New or Default == nil then return end
        ESPGroups[New] = Default
        RCP({"O-ESP Created Group",New,tostring(Default)},"nicemessage")
        return
    end;
    
    Update = function()
        local ErrorStatus2, ErrorMessage2 = pcall(function()
        for id,table in pairs(ESPStorage) do
            local TempSettings = table["Settings"]
            local Parts = table["Parts"]
            local Enabled = table["Enabled"]
            local TempEnabled = true
            local Instance = table["Instance"]
            if not Instance then
                ESP.Remove(Instance)
                return
            end
            
            if TempSettings["Group"] then
                if ESP.CheckGroup(TempSettings["Group"]) == false then
                    TempEnabled = false
                else
                    TempEnabled = Enabled
                end
            end
            
            if not TempEnabled then
                ESP.Hide(Instance)
            else
                ESP.Show(Instance)
            end
            
            local Continue = true
            for set,val in pairs(TempSettings) do
                if set == "DescendantOfCheck" then
                    if not Instance:IsDescendantOf(val) then
                        Continue = false
                    end
                elseif set == "TransparencyCheck" then
                    local nerr, msg = pcall(function()
                        local A = Instance.Transparency
                    end)
                    if nerr then
                        if Instance.Transparency ~= val then
                            Continue = false
                        end
                    else
                        Continue = false
                    end
                elseif set == "FindFirstChildCheck" then
                    local FFC = false
                    for _,instcheck2 in pairs(val["Parent"]:GetChildren()) do
                        if instcheck2.Name == val["Child"] then
                            FFC = true
                        end
                    end
                    Continue = FFC
                elseif set == "OppositeFindFirstChildCheck" then
                    local FFC = true
                    for _,instcheck2 in pairs(val["Parent"]:GetChildren()) do
                        if instcheck2.Name == val["Child"] then
                            FFC = false
                        end
                    end
                    Continue = FFC
                elseif set == "ParentCheck" then
                    if Instance.Parent ~= val then
                        Continue = false
                    end
                end
            end
            if not Continue then 
                RCP("O-ESP Failed Continue Check","remove")
                ESP.Remove(Instance)
                return
            end
            local Dist = "-"
            if Players.LocalPlayer.Character then
                if Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    Dist = (Players.LocalPlayer.Character.HumanoidRootPart.Position - Instance.Position).magnitude
                    Dist = string.split(tostring(Dist),".")[1]
                    if TempSettings["MaxDistance"] then
                        if tonumber(Dist) > tonumber(TempSettings["MaxDistance"]) then
                            ESP.Hide(Instance)
                            return
                        end
                    end
                else
                    ESP.Hide(Instance)
                    return
                end
            end
            local Camera = Workspace.CurrentCamera
            local Vector, OnScreen = Camera:WorldToViewportPoint(Instance.Position)
            local A,B = pcall(function()
                for _,v in pairs(Parts) do
                    if not Vector or not v then RCP({"O-ESP Uh oh"},"nicemessage") return end
                    if not v[2] then RCP({"O-ESP Couldn't Find Position",tostring(Vector)},"nicemessage") return end
                    if v[1][1] == "Line" then
                        v[2].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 1.3)
                        v[2].To = Vector2.new(Vector.X, Vector.Y)
                    elseif v[1][1] == "Circle" then
                        v[2].Position = Vector2.new(Vector.X, Vector.Y)
                    elseif v[1][1] == "Text" then
                        local AddOffset = false
                        if v[1][2] == "DistanceTag" then
                            v[2].Position = Vector2.new(Vector.X, Vector.Y + 20)
                            v[2].Text = tostring(Dist).."m"
                        elseif v[1][2] == "HealthTag" then
                            local Humanoid = Instance.Parent:FindFirstChildWhichIsA("Humanoid")
                            if Humanoid then
                                v[2].Position = Vector2.new(Vector.X, Vector.Y + 35)
                                v[2].Text = Humanoid.Health.."/"..Humanoid.MaxHealth
                            else
                                v[2].Visible = false
                            end
                        else
                            v[2].Position = Vector2.new(Vector.X, Vector.Y + 5)
                        end
                    end
                    if TempSettings["CustomColor"] then
                        v[2].Color = TempSettings["CustomColor"];
                    else
                        v[2].Color = Color3.fromRGB(255,255,255);
                    end
                    if OnScreen then
                        v[2].Visible = TempEnabled
                    else
                        v[2].Visible = false
                    end
                    --RCP({TempEnabled,Enabled,ESP.State(Instance),v[2].Visible,Instance.Name,Instance.Parent.Name},"message")
                end
            end)
            if not A then
                RCP({"O-ESP Update Error 1/10 [",tostring(B),"]"},"error")
                ESP.Remove(Instance)
            end
        end
        end)
        if not ErrorStatus2 then
            RCP({"O-ESP Update Error 9/10 [",ErrorMessage2,"]"},"error")
        end
    end;
    
    Check = function(Instance)
        if not Instance then return end
        local Found = false
        for id,table in pairs(ESPStorage) do
            if table["Instance"] == Instance then
                Found = true
            end
        end
        return Found
    end;
    
    Remove = function(Instance)
        if not Instance then return end
        for id,table in pairs(ESPStorage) do
            if table["Instance"] == Instance then
                ESP.Hide(Instance)
                table["Delete"]()
                ESPStorage[id] = nil
                RCP({"Removed ID",id,tostring(Instance.Name) or "Instace Not Found",tostring(Instance.Parent.Name) or "Parent Not Found"},"remove")
                break
            end
        end
        return
    end;
    
    ModifyAll = function(Modifying)
        if not Modifying then return end
        for id,table in pairs(ESPStorage) do
            for set1,val1 in pairs(Modifying) do
                table["Settings"][set1] = val1
            end
        end
        return
    end;
    
    Modify = function(Instance,Modifying)
        if not Instance or not Modifying then return end
        for id,table in pairs(ESPStorage) do
            if table["Instance"] == Instance then
                for set1,val1 in pairs(Modifying) do
                    table["Settings"][set1] = val1
                end
                break
            end
        end
        return
    end;
    
    State = function(Instance)
        if not Instance then return end
        for id,table in pairs(ESPStorage) do
            if table["Instance"] == Instance then
                return table["Enabled"]
            end
        end
        return false
    end;
    
    Show = function(Instance)
        if not Instance then return end
        for id,table in pairs(ESPStorage) do
            if table["Instance"] == Instance then
                for _,v in pairs(table["Parts"]) do
                    v.Visible = true
                end
                table["Enabled"] = true
                break
            end
        end
        return
    end;
    
    Hide = function(Instance)
        if not Instance then return end
        for id,table in pairs(ESPStorage) do
            if table["Instance"] == Instance then
                for _,v in pairs(table["Parts"]) do
                    v.Visible = false
                end
                table["Enabled"] = false
                break
            end
        end
        return
    end;
    
    Create = function(Instance,Options)
        local CreateGUIDTemp = ""
        local ErrorStatus3, ErrorMessage3 = pcall(function()
        if not Options or not Instance then return end
        if not Options["Dot"] and not Options["Tracers"] then return end
        if not Options["Nametag"] then return end
        if Options["CheckForESPOnInstance"] and ESP.Check(Instance) then 
            return
        end
        if Options["Group"] then
            if ESP.CheckGroup(Options["Group"]) == "not a thing bucko." then
                ESP.CreateGroup(Options["Group"],false)
            end
        end
        
        local GUID = game:GetService("HttpService"):GenerateGUID(false)
        CreateGUIDTemp = GUID
        --RCP({"O-ESP Creating [",CreateGUIDTemp,Instance.Name,Instance.Parent.Name,"]"},"nicemessage")
        ESPStorage[GUID] = {
            ["Instance"] = Instance;
            ["Settings"] = Options;
            ["Parts"] = {};
            ["Enabled"] = false;
            ["Delete"] = function() 
                for _,v in pairs(ESPStorage[GUID]["Parts"]) do
                    if not v then return end
                    if not v[2] then return end
                    v[2]:Remove()
                end
            end;
        }
        
        local Create = {
            ["Dot"] = "Circle";
            ["Tracers"] = "Line";
            ["Nametag"] = "Text";
            ["HealthTag"] = "Text";
            ["DistanceTag"] = "Text";
        }
        
        for _,v in pairs(Options) do 
            if Create[_] then
                if not ESPStorage[GUID] then ESP.Remove(Instance) return end
                local ObjectGUID = game:GetService("HttpService"):GenerateGUID(false)
                local Object = Create[_]
                local Parts = ESPStorage[GUID]["Parts"]
                
                Parts[ObjectGUID] = {{Object,_}}
                
                Parts[ObjectGUID][2] = Drawing.new(Object)
                Parts[ObjectGUID][2].Visible = false;
                Parts[ObjectGUID][2].Transparency = 1;
                if Options["CustomColor"] then
                    Parts[ObjectGUID][2].Color = Options["CustomColor"];
                else
                    Parts[ObjectGUID][2].Color = Color3.fromRGB(255,255,255);
                end
                if not Camera then Camera = Workspace.CurrentCamera end
                if not Camera then return end
                if Object == "Line" then
                    Parts[ObjectGUID][2].From = Vector2.new(0,0);
                    Parts[ObjectGUID][2].To = Vector2.new(0,0);
                    Parts[ObjectGUID][2].Thickness = 1;
                elseif Object == "Circle" then
                    Parts[ObjectGUID][2].Thickness = 1;
                    Parts[ObjectGUID][2].NumSides = 4;
                    Parts[ObjectGUID][2].Radius = 4;
                    Parts[ObjectGUID][2].Filled = true;
                    Parts[ObjectGUID][2].Position = Vector2.new(0,0);
                elseif Object == "Text" then
                    Parts[ObjectGUID][2].Text = Options["Nametag"]["Text"];
                    Parts[ObjectGUID][2].Size = 20;
                    Parts[ObjectGUID][2].Center = true;
                    Parts[ObjectGUID][2].Outline = false;
                    Parts[ObjectGUID][2].OutlineColor = Color3.fromRGB(0,0,0)
                    Parts[ObjectGUID][2].Position = Vector2.new(0,0);
                end
                wait()
            end
        end
        ESPStorage[GUID]["Enabled"] = true
        ESP.Update(Instance)
        end)
        if not ErrorStatus3 then
            RCP({"O-ESP Create Error [",ErrorMessage3,"]"},"error")
        else
            --RCP({"O-ESP Created Successfully",tostring(CreateGUIDTemp)},"nicemessage")
        end
        return true
    end
}

RCP({"O-ESP Checking Auto Update",},"message")
if CONN_OESP_RENDERSTEP then
    CONN_OESP_RENDERSTEP:Disconnect()
end

if AutoUpdate_OESP then
    getgenv().CONN_OESP_RENDERSTEP = RunService.RenderStepped:Connect(function()
        ESP.Update()
    end)
    RCP("O-ESP Lib Auto Update Is Enabled.","nicemessage")
else
    RCP("O-ESP Lib Auto Update Isn't Enabled.","error")
end

-- PCALL END
end)

if not ErrorStatus then
    RCP({"O-ESP Lib Startup Error [",tostring(ErrorMessage),"]"},"error")
else
    RCP({"O-ESP Lib Loaded In",tick()-StartTick},"message")
end
return
-- ESP.Create(Wall,{
--     Nametag = {
--         Enabled = true;
--         Text = "Name"
--     };

--     MaxDistance = 999999;
--     CustomColor = Color3.fromRGB(255,0,0);
--     Group = "Group 1";

--     ParentCheck = Wall.Parent;
--     FindFirstChildCheck = {
--         Parent = Wall;
--         Child = "ChildName";
--     };
--     OppositeFindFirstChildCheck = {
--         Parent = Wall;
--         Child = "ChildName";
--     };
--     DescendantCheck = Workspace;
--     TransparencyCheck = 0;
--     CheckForESPOnInstance = true;

--     HealthTag = true;
--     DistanceTag = true;
--     Tracers = true;
--     Dot = true;
-- })
