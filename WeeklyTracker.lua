local function OnEnteringWorld(self, event, isLogin)
  if isLogin then
    WeeklyTrackerDB = WeeklyTrackerDB or {}

    local playerName = UnitName("player")

    -- Get keys
    local chestsOpened=0

    for i,q in ipairs({84736,84737,84738,84739})
      do
        chestsOpened=chestsOpened+(C_QuestLog.IsQuestFlaggedCompleted(q) and 1 or 0)
      end

    -- If there is an existing chestVal and it's less than chestsOpened it must be a new week so wipe DB
    local existingChestVal = WeeklyTrackerDB[""..playerName.."_chestsOpened"] ~= nil

    if existingChestVal then
      if WeeklyTrackerDB[""..playerName.."_chestsOpened"] < chestsOpened then
        print("Welcome to a new week! DB Wiped")
        WeeklyTrackerDB = {}
      end
    end

    --  Set keys
    WeeklyTrackerDB[""..playerName.."_chestsOpened"] = chestsOpened

    -- Get and set bounty status
    local delversBountyComplete = C_QuestLog.IsQuestFlaggedCompleted(86371)

    WeeklyTrackerDB[""..playerName.."_bounty"] = delversBountyComplete

    chestsOpened = WeeklyTrackerDB[""..playerName.."_chestsOpened"]
    local bountyStatus = WeeklyTrackerDB[""..playerName.."_bounty"]

    local delversBountyMessage = " has NOT completed delvers bounty"

    if bountyStatus == true then
      delversBountyMessage = "HAS completed delvers bounty"
    end

    -- Log to user
    print(playerName .. delversBountyMessage)

    print(playerName .. " has opened ", chestsOpened,'chests')
  end
end


local f = CreateFrame("Frame")

-- Run on entering world, quest data isn't always there on addon load
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", OnEnteringWorld)

