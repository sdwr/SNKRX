

local fns = {}

fns['init_enemy'] = function(self)

  --set extra variables from data
  self.data = self.data or {}
  self.size = self.data.size or 'boss'

  --create shape
  self.color = red[0]:clone()
  Set_Enemy_Shape(self, self.size)

  --add hitbox points
  self.hitbox_points_can_rotate = true
  Helper.Unit:add_point(self, 32, 0)
  Helper.Unit:add_point(self, -15, 27)
  Helper.Unit:add_point(self, -15, -27)
  Helper.Unit:add_point(self, 23, 5)
  Helper.Unit:add_point(self, 23, -5)
  Helper.Unit:add_point(self, 16, 9)
  Helper.Unit:add_point(self, 16, -9)
  Helper.Unit:add_point(self, 10, 12)
  Helper.Unit:add_point(self, 10, -12)
  Helper.Unit:add_point(self, -9, 23)
  Helper.Unit:add_point(self, -9, -23)
  Helper.Unit:add_point(self, -3, 19)
  Helper.Unit:add_point(self, -3, -19)
  Helper.Unit:add_point(self, 3, 16)
  Helper.Unit:add_point(self, 3, -16)
  Helper.Unit:add_point(self, -16, 21)
  Helper.Unit:add_point(self, -16, -21)
  Helper.Unit:add_point(self, -16, 14)
  Helper.Unit:add_point(self, -16, -14)
  Helper.Unit:add_point(self, -16, 6)
  Helper.Unit:add_point(self, -16, -6)
  Helper.Unit:add_point(self, -16, 0)
  Helper.Unit:add_point(self, -9, 16)
  Helper.Unit:add_point(self, -9, -16)
  Helper.Unit:add_point(self, -9, 7)
  Helper.Unit:add_point(self, -9, -7)
  Helper.Unit:add_point(self, -9, 0)
  Helper.Unit:add_point(self, -2, 11)
  Helper.Unit:add_point(self, -2, -11)
  Helper.Unit:add_point(self, -2, 3)
  Helper.Unit:add_point(self, -2, -3)
  Helper.Unit:add_point(self, 5, 8)
  Helper.Unit:add_point(self, 5, -8)
  Helper.Unit:add_point(self, 5, -0)
  Helper.Unit:add_point(self, 10, 4)
  Helper.Unit:add_point(self, 10, -4)
  Helper.Unit:add_point(self, 18, -3)
  Helper.Unit:add_point(self, 18, 3)
  Helper.Unit:add_point(self, 25, 0)
  
  --set physics 
    self:set_restitution(0.1)
    self:set_as_steerable(self.v, 1000, 2*math.pi, 2)
    self.class = 'boss'

  --set attacks
  self.fireDmg = 5
  self.fireDuration = 3
  self.fireRange = 100

  self.fireSweepRange = 200
  
  self.attack_options = {}

  local fire = {
    name = 'fire',
    viable = function() return Helper.Spell:there_is_target_in_range(self, 150) end,
    castcooldown = 1,
    oncast = function(self) self.target = Helper.Spell:get_nearest_target(self) end,
    cast_length = 0.5,
    spellclass = Breathe_Fire,
    spelldata = {
      group = main.current.main,
      color = red[0],
      team = "enemy",
      flamewidth = 30,
      flameheight = 150,
      tick_interval = 0.125,
      dps = 30,
      spell_duration = 5,
      follow_target = true,
      freeze_rotation = true,
      follow_speed = 20,
    }, 
  }

  local fire_sweep = {
    name = 'fire_sweep',
    viable = function() return true end,
    castcooldown = 1,
    oncast = function(self) self.target = Helper.Spell:get_nearest_target(self) end,
    cast_length = 0.5,
    spellclass = Breathe_Fire,
    spelldata = {
      group = main.current.main,
      color = red[0],
      team = "enemy",
      flamewidth = 30,
      flameheight = 150,
      tick_interval = 0.125,
      rotate_tick_interval = 1,
      dps = 30,
      spell_duration = 5,
      follow_target = false,
      freeze_rotation = true,
      follow_speed = 45,
    },
  }

  local fire_wall = {
    name = 'fire_wall',
    viable = function() return true end,
    castcooldown = 1,
    oncast = function(self) end,
    cast_length = 1,
    spellclass = FireWall,
    instantspell = true,
    spelldata = {
      group = main.current.main,
      color = red[0],
      team = "enemy",
      wall_type = "half",
    },
  }

  table.insert(self.attack_options, fire)
  table.insert(self.attack_options, fire_sweep)
  table.insert(self.attack_options, fire_wall)

  self.state_always_run_functions['always_run'] = function()
      self.hitbox_points_rotation = math.deg(self:get_angle())
  end

  self.state_change_functions['target_death'] = function()
  end

    self.state_change_functions['death'] = function()
      Helper.Spell.Flame:end_flame_after(self, 0)
  end
end

fns['draw_enemy'] = function(self)
    graphics.push(self.x, self.y, 0, self.hfx.hit.x, self.hfx.hit.x)
    local points = self:make_regular_polygon(3, (self.shape.w / 2) / 60 * 70, self:get_angle())
    graphics.polygon(points, self.color)
    graphics.pop()
end

enemy_to_class['dragon'] = fns