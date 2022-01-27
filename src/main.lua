
local sides = require("sides")
local component = require("component")

local transposer = component.transposer

local testChest = sides.north

for i=1, transposer.getInventorySize(testChest) do
    -- if transposer.getStackInSlot(testChest, i)["name"] ~= "minecraft.air" do
    local stack = transposer.getStackInSlot(testChest, i)
    print("Slot: ", i, "Item: ", stack["name"], "Count: ", stack["count"])
end