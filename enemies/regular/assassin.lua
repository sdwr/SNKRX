

local fns = {}
fns['init_enemy'] = function(self)

  --create shape
  self.color = black[0]:clone()
  self:set_as_rectangle(14, 6, 'dynamic', 'enemy')

  --set physics 
  self:set_restitution(0.5)
  self:set_as_steerable(self.v, 2000, 4*math.pi, 4)
  self.class = 'regular_enemy'

  self.baseCooldown = attack_speeds['ultra-slow']
  self.baseCast = attack_speeds['long-cast']

  --set attacks
  self.spawn_pos = {x = self.x, y = self.y}
  self.t:cooldown(self.baseCooldown, function() local targets = self:get_objects_in_shape(self.aggro_sensor, main.current.friendlies); return targets and #targets > 0 end, function()
    local furthest_enemy = self:get_furthest_object_to_point(self.aggro_sensor, main.current.friendlies, {x = self.x, y = self.y})
    if furthest_enemy then
      Vanish{group = main.current.main, team = "enemy", x = self.x, y = self.y, target = furthest_enemy, level = self.level, castTime = self.baseCast, parent = self}
    end
  end, nil, nil, 'vanish')
end

fns['draw_enemy'] = function(self)   
  graphics.rectangle(self.x, self.y, self.shape.w, self.shape.h, 3, 3, self.hfx.hit.f and fg[0] or (self.silenced and bg[10]) or self.color)
end

enemy_to_class['assassin'] = fns
