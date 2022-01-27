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
            print("Slot: ", i, "Item: ", stack["label"], "Count: ", stack["size"])
        end
    end
end

-- Find item slot in inventory
local function findItem(comp, side, item)
    for i=1, comp.getInventorySize(side) do
        local stack = comp.getStackInSlot(side, i)
        if stack ~= nil then
            if stack["label"] == item then
                return i
            end
        end
    end
    return nil
end

-- Count occurence of item in inventory

-- Table[#item : #price]

showIventory(transposer, testChest)
print(findItem(transposer, testChest, "Gold Ingot"))