
local class = require "lib.middleclass"
local bump = require "lib.bump"


local Player = require "entities.player"
local Block = require "entities.block"
-- local name = require "entities.guardian"

local random = math.random

local sortByUpdateOrder  = function(a,b)
   return a:getUpdateOrder()< b:getUpdateOrder()
 end

local sortByCreatedAt = function(a,b)
  return a.create_at< b.create_at
end
local Map = class('Map')

function Map:initialize(width,height,camera)
   self.width = width
   self.height  = height
   self.camera = camera
   self:reset()
 end

function Map:reset()

  local width ,height = self.width, self.height
  self.world = bump.newWorld()
  self.player = Player:new(self,self.world,60,60)

  Block:new(self.world, 0 ,0 ,width,32, true)
  Block:new(self.world, 0, 32,32 ,height-64,true)
  Block:new(self.world, width-32 ,32 ,height-64 , true)

  local tilesOnFloor =40
  for i =0 ,tilesOnFloor -1 do
    Block:new(self.world,i*width/tilesOnFloor, height-32 ,width/tilesOnFloor, 32,true)
  end

  local l ,t ,w,h,area
  for i =1 ,60  do
    w =random(100,400)
    h =random(100,400)
    area = w * h
    l =random(100, width-w-200)
    t = random(100,height-h-100)
    for i =1 , math.floor(area/7000) do
      Block:new(self.world, random(l ,l+w),
                random(t,t+h),random(32,100),random(32,100), random()>0.75)

    end
  end
  local visibleThings , len = self.world:queryRect(l,t, w,h)

  assert(type(w)=="nil","l is a nil"..len)
end

function Map:update(dt,l ,t, w ,h)
  l , t ,w ,h = l or 0 ,t or 0 , w or self.width, h or self.height
  local visibleThings , len = self.world:queryRect(l,t, w,h)

  assert(type(w)=="nil","l is a nil"..len)

  table.sort(visibleThings,sortByUpdateOrder)

  for i =1 , len do
     visibleThings[i]:update(dt)
   end
end


function Map:draw(l, t ,w,h)
  local visibleThings ,len = self.world:queryRect(l,t,w,h)

  table.sort(visibleThings,sortByUpdateOrder)

  for i =1 ,len do
    visibleThings[i]:draw(false)
  end


end

function Map:countItems()
  return self.world:countItems()
end

return Map
