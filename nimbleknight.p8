pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
knight={
 lx=60,
 ly=60,
	x=60,
	y=60,
	dx=0,
	dy=0,
	f=false
}

shading={
	0b1111111111111111.1,
	0b0111110101111101.1,		
	0b0101101001011010.1,
	0b1000001010000010.1,	
	0b0000000000000000.1
}

function _draw()
	cls()
	for i=-6,6 do
		for j=-6,6 do
		 s=32+(j%2)+16*(i%2)
			spr(s,64+j*8-4,64+i*8-4)
		end
	end
	
	for i=-13,13 do
		for j=-13,13 do
			x=64+j*4
			y=64+i*4
		 p=flr(dist(x,y,64,64)/48*4)
		 if p>4 then
		  p=4
		 end
		 if p<0 then
		  p=0		  
		 end
			fillp(shading[p+1])
			rectfill(x-2,y-2,x+2,y+2,0)
		end
	end
	fillp()
		
	for i=1,12 do
		p=i/12
		x=(1-p)*knight.lx+p*knight.x
		y=(1-p)*knight.ly+p*knight.y
		spr(0,x,y)
	end
	spr(0,knight.x,knight.y)
end

function dist(x1,y1,x2,y2)
	dx=x1-x2
	dy=y1-y2
	return sqrt(dx*dx+dy*dy)
end

function _update()
 knight.lx=knight.x
 knight.ly=knight.y
 
	knight.dx=0
	knight.dy=0
	if btn(⬆️) then
		knight.dy+=-12
	end
	if btn(⬇️) then
	 knight.dy+=12
	end
	if btn(⬅️) then
		knight.dx+=-12
	end
	if btn(➡️) then
		knight.dx+=12
	end
	knight.x=60+knight.dx
	knight.y=60+knight.dy
end

__gfx__
70ff6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
700f6600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7006dddd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7066dcdd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6666dccd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d066ddcd000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0060dd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00660660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100111101111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111101111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111111011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11011111111101110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10111111101101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01101111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11011111111111010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11101111011110110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111110111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111111111111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11011111111111010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111110110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01110001111011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
