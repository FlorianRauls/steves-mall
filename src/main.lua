-- imports
local sides = require("sides")
local component = require("component")
local buttons = require("buttonAPI")
local gpu = component.gpu
local event = require("event")
local computer = require("computer")
local term = require("term")
local colors = require("colors")


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

local function prod2string(prod) 
    return prod[1].."_"..tostring(prod[2])
end

-- Find item slot in inventory
local function findItem(comp, side, item)
    for i=1, comp.getInventorySize(side) do
        local stack = comp.getStackInSlot(side, i)
        if item == nil and stack == nil then
            return i
        end
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
            local emptySlot = findItem(comp, sideTo, nil)
            if emptySlot ~= nil then
                -- move items
                comp.transferItem(sideFrom, sideTo, count, itemSlot, emptySlot)
            else
                print("No empty slot in inventory No.", sideTo)
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
    priceCatalogue[prod2string(product)] = price
end

-- Function which checks if a certain inventory fulfills the price requirements for a purchase
local function checkForPriceReq(comp, side, prod, quant)
    -- 
    local priceOfRequest = priceCatalogue[prod2string(prod)]

    if countQuantities(comp, side, priceOfRequest) >= quant then
        return true
    else
     -- does not meet requirement
        return false
    end
end

-- Function which fulfills a single trade
local function trade(comp, seller, buyer, prod)
    -- Give wares
    local waresNeeded = prod[2]
    moveItems(comp, seller, buyer, prod[1], prod[2])

    -- Give coins
    local price = priceCatalogue[prod2string(prod)]
    local coinsNeeded = price[2]
    moveItems(comp, buyer, seller, price[1], price[2])
    
end

-- Function which fulfills a transaction from one inventory to the other
local function purchase(comp, seller, buyer, prod, quant)
    for i=1, quant do
        trade(comp, seller, buyer, prod)
    end
end


-- TODO
-- Function which creates a button based on a Product (should include Product x Quantity and Price x Quantity)
-- Button must only be active while there is product in stock
-- For further information look at buttonAPI.lua
-- Or https://oc.cil.li/topic/255-button-api-now-for-oc-updated-9-6-2014/

-- Function which goes through all offers and creates a button based on them
-- Should run after a transaction is done

-- Functionality for seller to Create, Delete and Edit Offers

-- TESTING AREA
-- showIventory(transposer, testChest)
-- print(findItem(transposer, northChest, "Gold Ingot"))
-- print(countItem(transposer, northChest, "Gold Ingot"))
-- moveItems(transposer, northChest, eastChest, "Gold Ingot", 1)
-- print(countQuantities(transposer, northChest, {"Gold Ingot", 1}))
-- print(countQuantities(transposer, northChest, {"Gold Ingot", 2}))

addToCatalogue({"Gold Ingot", 1}, {"Iron Ingot", 1})
purchase(transposer, northChest, eastChest, {"Gold Ingot", 1}, 1)

function getClick()
    local _, _, x, y = event.pull(1,touch)
    if x == nil or y == nil then
      local h, w = gpu.getResolution()
      gpu.set(h, w, ".")
      gpu.set(h, w, " ")
    else 
      buttons.checkxy(x,y)
    end
  end

function buttons.fillTable()
    buttons.setTable("Flash", test1, 10,20,3,5)  
    buttons.screen()
end
  
function test1()
    buttons.flash("Flash",0.01)
end

term.setCursorBlink(false)
gpu.setResolution(80, 25)
buttons.clear()
buttons.fillTable()
buttons.heading("Button buttons Demo! Created in CC by DW20, ported to OC by MoparDan!")
buttons.label(1,24,"A sample Label.")
 
while true do
  getClick()
end



