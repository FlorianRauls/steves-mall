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
local function countItem(comp, side, item)
    local count = 0
    for i=1, comp.getInventorySize(side) do
        local stack = comp.getStackInSlot(side, i)
        if stack ~= nil then
            if stack["label"] == item then
                count = count + stack["size"]
            end
        end
    end
    return count
end



-- Table[#item : #price]

-- Function that kills the wither

-- showIventory(transposer, testChest)
print(findItem(transposer, testChest, "Gold Ingot"))
print(countItem(transposer, testChest, "Gold Ingot"))