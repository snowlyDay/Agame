
local class = require 'lib.middleclass'
local util  = require 'util'
local Entity = require "entities.entity"


local Debris = class('Debris',Entity)

local minSize = 5
local maxSize = 10
local minVel  = -100
local maxVel = -1 * minVel
local bounciness = 0.1

function Debris:initalize (world , x, y,r,g,b)
   Entity.initalize(self,world, x ,y ,
        love.math.random(minSize, maxSize),
        math.random(minSize, maxSize))
end

function  Debris:filter(other)
   local kind = other.class.name
   if kind =='Block' or kind == 'Guardian' then
     return "bounce"
   end
end

function Debris:moveColliding(dt)
  local world =self.world

  local future_l = self.l +self.vx *dt
  local future_t = self.l + self.vy *dt

  local next_l , next_t ,cols,len = world:move(self, future_l,future_t,self.filter)

  for i=1 ,len do
    local col = cols[i]
    self:changeVelocityByCollisionNormal(col.normal.x ,col.normal.y,bounciness)
  end
  self.l ,self.t = next_l,next_t
end

function Debris:update(dt)
    self.lived = self.lived+dt
    if self.lived >= self.lifeTime then
      self.destroy()
    else
      self:changeVelocityByGravity(dt)
      self:moveColliding(dt)
    end
end

function Debris:draw()
  util:drawFilledRectangle(self.l,self.t ,self.w ,self.h ,self.r ,self.g,self.b)
end

return Debris
