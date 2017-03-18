
index =10
dt =2
function love.load()
	phyWord =love.physics.newWorld(0,10,false)
	playerBody =love.physics.newBody(phyWord,100,30,static)
    playerX= playerBody:getX()	
	playerY =playerBody:getY()
	whale = love.graphics.newImage("peach.png")
    love.window.setIcon("peach.png")
end


function World:update( dt )
	
end
function love.update()
	if love.keyboard.isDown("right") then
	 	 index= index+dt	
	end
end



function love.draw()
	love.graphics.draw(whale, playerX, playerY)
	love.graphics.setBackgroundColor(255,33,2)
end