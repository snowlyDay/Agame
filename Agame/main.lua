


function love.load() 
	   Agameversion=1
	   love.graphics.setCaption("Agame")
	   iconimg=love.graphics.newImage("icon.gif")
	   love.graphics.setIcon(iconimg)
	   love.graphics.setBackgroundColor(0,0,0)
	   backgroundcolor={}
	   backgroundcolor[1] ={92,20,30}

	end

	function love.update(  )
	   love.graphics.setBackgroundColor(backgroundcolor[1]);
	   
	end