
require "lib.middleclass"

local gamer = require 'lib.gamera'
local shakycam = require 'lib.shakycam'
local Map = require 'map'


local camera , map

local updateRadius = 100

function love.load(arg)
    local width , height = 4000,2000
    local gamer_camer = gamer.new(0,0,width,height)
    camera = shakycam.new(gamer_camer)
    map = Map:new (width , height,camera)
end


function love.update(dt)
  local l ,t ,w ,h = camera:getVisible()
  l ,t ,w ,h =l+100 ,t+200 ,w + updateRadius*2 ,h + updateRadius*2

  assert(type(w)~="nil","l is a nil"..l)
  map:update(dt,l , t ,w, h)
  if map.player then
    camera:setPosition(22,33)
  end
  camera:update(dt)
end

 function love.draw()
  camera:draw(function(l,t,w,h)
   map:draw(l,t, w, h)
 end )

 end

 function love.keypressed(k)
   -- body...

 end
