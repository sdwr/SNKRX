
local fns = {}

fns['init_enemy'] = function(self)
  --set extra variables from data
  self.data = self.data or {}
  self.size = self.data.size or 'big'

  --create shape
  self.color = red[0]:clone()
  Set_Enemy_Shape(self, self.size)

  self.class = 'special_enemy'

  --set sensors
  self.attack_sensor = Circle(self.x, self.y, 80)

  --set attacks
  self.attack_options = {}

  local charge = {
    name = 'charge',
    viable = function() return true end,
    castcooldown = 3,
    cast_length = 0.1,
    oncast = function() end,
    spellclass = Launch_Spell,
    spelldata = {
      group = main.current.main,
      team = "enemy",
      charge_duration = 2,
      spell_duration = 2.5,
      cancel_on_death = true,
      x = self.x,
      y = self.y,
      color = red[0],
      dmg = 50,
      parent = self
    }
  }
  table.insert(self.attack_options, charge)
end

fns['attack'] = function(self, area, mods, color)
  mods = mods or {}
  local t = {team = "enemy", group = main.current.effects, x = mods.x or self.x, y = mods.y or self.y, r = self.r, w = self.area_size_m*(area or 64), color = color or self.color, dmg = self.dmg,
    character = self.character, level = self.level, parent = self}

  self.state = unit_states['frozen']

  self.t:after(0.3, function() 
    self.state = unit_states['stopped']
    Area(table.merge(t, mods))
    _G[random:table{'swordsman1', 'swordsman2'}]:play{pitch = random:float(0.9, 1.1), volume = 0.75}
  end, 'stopped')
  self.t:after(0.4 + .4, function() self.state = unit_states['normal'] end, 'normal')
end

fns['draw_enemy'] = function(self)
  graphics.rectangle(self.x, self.y, self.shape.w, self.shape.h, 3, 3, self.hfx.hit.f and fg[0] or (self.silenced and bg[10]) or self.color)
end

enemy_to_class['charger'] = fns