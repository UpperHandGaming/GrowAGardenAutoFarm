-- 🔐 Grow a Garden AutoFarm with Key System

-- ✅ CONFIGURATION
local allowedKeys = {
    ["LIFETIME-KEY-ABC123"] = "lifetime",
    ["60DAY-KEY-XYZ456"] = os.time() + (60 * 24 * 60 * 60),
}

-- Generate a 12‑hour temp key (changes each hour)
local prefix = "TEMPKEY-" .. os.date("%Y%m%d%H")
allowedKeys[prefix] = os.time() + (12 * 60 * 60)

-- 🔍 KEY VALIDATION
local args = {...}
local userKey = args[1]
if not userKey or not allowedKeys[userKey] or (allowedKeys[userKey] ~= "lifetime" and os.time() > allowedKeys[userKey]) then
    warn("🔒 Invalid or expired key.")
    game.Players.LocalPlayer:Kick("🔒 Invalid or expired key. Please get a new key.")
    return
end

-- 🎉 KEY OK — START AUTO FARM LOGIC

local plr = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- Settings (auto farm, auto buy list)
local settings = {
  autoCollect = true,
  autoSell = true,
  autoBuy = true,
  autoEvent = true,
  seeds = {
    "Carrot","Strawberry","Blueberry","Tomato","Cauliflower","Watermelon",
    "Green Apple","Avocado","Banana","Pineapple","Kiwi","Bell Pepper",
    "Prickly Pear","Loquat","Feijoa","Sugar Apple"
  },
  gear = {
    "Watering can","Trowel","Recall wrench","Basic sprinkler",
    "Advanced sprinkler","Godly sprinkler","Master sprinkler",
    "Cleaning Spray","Favorite Tool","Harvest tool","Friendship pot"
  }
}

-- 🍓 Auto Collect Fruits
task.spawn(function()
  while settings.autoCollect and task.wait(1) do
    for _, v in ipairs(workspace.Fruits:GetChildren()) do
      if v:IsA("Part") and v:FindFirstChild("TouchInterest") then
        firetouchinterest(plr.Character.HumanoidRootPart, v, 0)
        firetouchinterest(plr.Character.HumanoidRootPart, v, 1)
      end
    end
  end
end)

-- 💰 Auto Sell Fruits
task.spawn(function()
  while settings.autoSell and task.wait(2) do
    local sellPad = workspace:FindFirstChild("SellPad")
    if sellPad then
      plr.Character:PivotTo(sellPad.CFrame + Vector3.new(0, 2, 0))
      task.wait(1)
    end
  end
end)

-- 🛒 Auto Buy Seeds & Gear
task.spawn(function()
  while settings.autoBuy and task.wait(5) do
    local buyRemote = rs:FindFirstChild("BuyItem")
    for _, item in ipairs(settings.seeds) do
      if buyRemote then buyRemote:FireServer(item) end
    end
    for _, item in ipairs(settings.gear) do
      if buyRemote then buyRemote:FireServer(item) end
    end
  end
end)

-- 🎪 Auto Hand-in Event Fruit
task.spawn(function()
  while settings.autoEvent and task.wait(6) do
    local summerRemote = rs:FindFirstChild("HandInSummerFruit")
    if summerRemote then summerRemote:FireServer() end
  end
end)
