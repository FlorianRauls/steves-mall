-- imports
local sides = require("sides")
local component = require("component")

-- test variables
local transposer = component.transposer
local testChest = sides.north

-- Function which prints inventory attached to side of comp to the screen
local function showIventory(comp, side)
    for i=1, comp.getInventorySize(side) do
        local stack = comp.getStackInSlot(side, i)
        if stack ~= nil then
            print("Slot: ", i, "Item: ", stack["name"], "Count: ", stack["count"])
        end
    end
end

showIventory(transposer, testChest)