-- imports
local sides = require("sides")
local component = require("component")

-- test variables
local transposer = component.transposer
local northChest = sides.north
local westChest = sides.west
local eastChest = sides.east

-- needed variables
-- Catalogue of structure
-- {
-- ("Gold", 1) : ("Iron", 1)   
-- }
priceCatalogue = {}

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

-- Function which moves items from one inventory to another
local function moveItems(comp, sideFrom, sideTo, item, count)
    local itemSlot = findItem(comp, sideFrom, item)
    if itemSlot ~= nil then
        local stack = comp.getStackInSlot(sideFrom, itemSlot)
        if stack["size"] >= count then
            -- find empty slot in sideTo
            local emptySlot = findItem(comp, sideTo, "empty")
            if emptySlot ~= nil then
                -- move items
                comp.transferItem(sideFrom, sideTo, count, itemSlot, emptySlot)
            else
                print("No empty slot in ", sideTo)
            end
        else
            print("Not enough items in slot: ", itemSlot)
        end
    end
end

-- Function which takes a tuple with (item, quantity) and looks up how often
-- the quantity of the item appears in the inventory
local function countQuantities(comp, side, tupl)
    local count = countItem(comp, side, tupl[1])
    return math.floor(count / tupl[2])
end

-- Function which adds a new product to the catalogue
local function addToCatalogue(product, price)
    priceCatalogue[product] = price
end

-- Function which checks if a certain inventory fulfills the price requirements for a purchase
local function checkForPriceReq(comp, side, prod, quant)
    -- 
    local priceOfRequest = priceCatalogue[prod]
    if countQuantities(comp, side, price) >= quant then
        return true
    else
     -- does not meet requirement
        return false
    end
end


-- showIventory(transposer, testChest)
-- print(findItem(transposer, northChest, "Gold Ingot"))
-- print(countItem(transposer, northChest, "Gold Ingot"))
-- moveItems(transposer, northChest, eastChest, "Gold Ingot", 1)
-- print(countQuantities(transposer, northChest, {"Gold Ingot", 1}))
-- print(countQuantities(transposer, northChest, {"Gold Ingot", 2}))


addToCatalogue({"Gold Ingot", 1}, {"Iron Ingot", 1})

print(checkForPriceReq(transposer, northChest, {"Gold Ingot", 1}, 3))
print(checkForPriceReq(transposer, northChest, {"Gold Ingot", 1}, 5))