local ids = {} -- To array
local shownInZone = false
local Debug = true 

-- Function to generate a unique ID
local function GenId()
    return tostring(math.random(1000000))
end

-- Function to send NUI messages
local function SendReactMessage(action, data)
    SendNUIMessage({ action = action, data = data })
end

-- Function to show text UI
local function Show(label, keybind)
    local i = GenId()

    if not ids[i] then
        -- Show text UI if the ID is not already shown
        local data = {
            id = i,
            label = label,
            keybind = keybind
        }
        table.insert(ids, data) 
        SendReactMessage('showTextUI', data)
    end
end

RegisterNetEvent('redux_textui:ShowUI', function(label, keybind)
    local i = GenId()

    if not ids[i] then
      
        local data = {
            id = i,
            label = label,
            keybind = keybind
        }
        table.insert(ids, data) 
        SendReactMessage('showTextUI', data)
    end
end)

RegisterNetEvent('redux_textui:HideUI', function()
    for _, data in ipairs(ids) do
       
        SendReactMessage('hideTextUI', { id = data.id })
    end
    ids = {} 
end)

-- Function to hide all shown text UI
function Hide()
    for _, data in ipairs(ids) do
       
        SendReactMessage('hideTextUI', { id = data.id })
    end
    ids = {} 
end

function GetIds()
    return ids
end

if Debug then 
    Citizen.CreateThread(function()
        local coords1 = vector3(231.5371, -801.0135, 29.53)
        local coords2 = vector3(211.28393, -781.2095, 30.938617)
        
        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distanceToZone1 = #(playerCoords - coords1)
            local distanceToZone2 = #(playerCoords - coords2)

            if distanceToZone1 <= 2.0 or distanceToZone2 <= 2.0 then
                local coords = distanceToZone1 <= 2.0 and coords1 or coords2

                DrawMarker(6, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, 2.0, 2.0, 2.0, 63, 148, 236, 175, false, true, 2, false, nil, nil, false)

                if not shownInZone then
                    TriggerEvent('redux_textui:ShowUI', "Punch Redux into face", "E") 
                    TriggerEvent('redux_textui:ShowUI', "Give him support", "G")
                    shownInZone = true 
                    print("IDS: " .. json.encode(GetIds()))
                end

                if IsControlJustPressed(0, 38) then
                    print("You punched ReduX :(")
                end
                if IsControlJustPressed(0, 47) then
                    print("You sent him some love <3")
                end
            else
                
                if shownInZone then
                    Hide()
                    shownInZone = false
                end
            end
            Wait(0)
        end
    end)
end
