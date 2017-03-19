player = class:new()

function mario:init( x ,y,i ,animation, size ,t )
	self.playernumber =i or 1 
	 if bigmario then
	 	 self.size = 1
	 else
	 	self.size =size or 1
	 end

	 self.speedx =0
	 self.speedy =0
	 self.x  =x 
	 self.width =12/16
	 self.height =12/16
	 if bigmario then 
	 	 self.width =self.width *scalefactor
	 	 self.height =self.height* scalefactor
	 end
  	
  	 self.y = y+1 -self.height
  	 self.static =false
  	 self.active = true
  	 self.category = 3 

end 



function mario:update( dt )
 	 
 	 self.rotation  =  math.mod(self.rotation ,math.pi*2)

 	 if self.rotation < -math.pi then 
 	 	self.rotation =self.rotation + math.pi*2
 	 else if self.rotation > math.pi then 
 	 	self.rotation =self.rotation - math.pi*2
 	 end
	
	 if self.animation == "jump"  then 
	 	self.animationtimer =self.animationtimer +dt 
	 	if self.animationtimer < 

end 

function player:jump(  )
	 if not noupdate and self.controlsenable then 
	 	 if not underwater then 
	 	 	 if self.spring then `
	 	 	 	self.springhigh =true
	 	 	 	return
	 	 	 end 
	 	 	 if self.falling==false then 
	 	 	 	if self.siz == 1 then
	 	 	 		 playsound(jumpsound)
	 	 	 	else
	 	 	 		 playsound(jumpbigsound)
	 	 	 	end 
	 	 	 	local force = -jumpforce - (math.abs(self.speedx)/
	 	 	 		maxrunspeed)* jumpforeadd
	 	 	 	force  =math.max(-jumpforce - jumpforeadd, force)

	 	 	 	self.speedy = force
	 	 	 	self.jumping =true
	 	 	 	self.animationstate = "jumping"
	 	 	 	self.setquad()
	 	    end 
	 	 else 
	 	  	if self.ducking then 
	 	  	  	self:duck(false)
	 	  	end

	 	  	 playsound(sw) 

end