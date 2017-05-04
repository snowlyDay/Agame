

local class = require 'lib.middleclass'
local util  = require  'util'
-- local media = require 'media'

local Entity = require 'entities.entity'
local Debris = require 'entities.debris'
-- local Puff   = require 'entities.puff'

local Player = class('Player',Entity)
Player.static.updateOrder =1

local deadDuration = 3
local runAccel = 500
local brakeAccel = 2000
local jumpVelocity =400
local width =32
local height =64
local beltWidth =2
local beltHeight = 8

local abs = math.abs
function Player:initalize(map,world,x, y)
	Entity.initalize(self,world ,x, y,width,height)
	self.health = 1
	self.deadCounter = 0
	self.map = map
end

function Player:filter(other)
	local kind = other.class.name
	if kind =='Guardian' or kind =='Block' then
		return 'slide'
	end
end

function Player:changeVelocityByKeys(dt)
	self.isJumpingOrFlying = false

	if self.isDead then
		return end
	local vx ,vy = self.vx,self.vy
	if love.keyboard.isDown("left") then
		vx = vx -dt* (vx> 0 and brakeAccel or runAccel)
	elseif love.keyboard.isDown("right") then
		vx = vx + dt*(vx < 0 and brakeAccel or runAccel)
	else
		local brake = dt * (vx < 0 and brakeAccel or -brakeAccel)
    if math.abs(brake) > math.abs(vx) then
			vx = 0
		else
			vx = vx + brake
		end
	end

if love.keyboard.isDown("up") and (self:canFly() or self.onGround) then
	vy = -jumpVelocity
	self.isJumpingOrFlying = true
end

	self.vx ,self.vy = vx,vy
end


function Player:playEffects()
	if self.isJumpingOrFlying then
		if self.onGround then
			media.sfx.player_jump:player()
		else
			Puff:new(self.world, self.l,
								self.t + self.h /2 ,
								20*(1- math.random()),
							  50,
							2,3)
			Puff:new(self.world ,self.l+ self.w,
							 self.t + self.h/2,
						 	 20* (1- math.random()),
						   50,
						  2, 3)
		 if media.sfx.player_propulsion:countPlayingInstance() == 0 then
			 media.sfx.player_propulsion:play()
		   end
	   end
	 else
		  media.sfx.player_propulsion:stop()
		end

	 if self.achievedFullHealth then
		  media.sfx.player_full_health:play()
	 end
 end

 function Player:checkIfOnGround()
end
return Player
