--achivements have 2 sources of truth
-- steam and local

--to be able to play offline, local needs to be saved in the save file
--to be able to get steam achievements, steam needs to be loaded

-- should load from local, then compare vs steam
-- and update steam if there are any differences (and local)

--also need to store game stats in local
--to trigger achievements (# of levels complete, etc)

-- game data is saved in save_game.lua


function Load_Steam_State()
  if steam then
    steam.userStats.requestCurrentStats()
  end
end

--this is the callback function for when the stats are loaded
function steam.userStats.onUserStatsReceived()
  for k, v in pairs(ACHIEVEMENTS_TABLE) do
    local success, achieved = steam.userStats.getAchievement(k)
    ACHIEVEMENTS_TABLE[k].unlocked = achieved
  end
end

function Unlock_Achievement(name)
  if steam then
    steam.userStats.setAchievement(name)
    steam.userStats.storeStats()
  end
  ACHIEVEMENTS_TABLE[name].unlocked = true

  level_up1:play{volume=0.5}
  AchievementToast{achievement = ACHIEVEMENTS_TABLE[name], duration = 5}
end

function Reset_All_Achievements()
  if steam then
    steam.userStats.resetAllStats(true)
    steam.userStats.storeStats()
  end

  for k, v in pairs(ACHIEVEMENTS_TABLE) do
    ACHIEVEMENTS_TABLE[k].unlocked = false
  end
end