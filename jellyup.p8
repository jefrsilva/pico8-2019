pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
obj = {dead=false,fx=false}

function obj:new(o)
	if o == nil then
	 o = {}
	end
	
	setmetatable(o, self)
	self.__index = self
	
	return o
end

jelly = obj:new({
	x = 64,
	y = 64,
	r = 4,
	vx = 0,
	vy = 0,
	inv = 0,
	oxygen = 20,
	prop = 3,
	spr = 2, 
	dir = 0,
	score = 0
})

function jelly:update()
 self.inv=clamp(self.inv-1,0,self.inv)
	self.dir = 0
	if btn(➡️) then
	 self.dir = 1
	end
	if btn(⬅️) then
		self.dir = -1
	end
	self.spr=2
	if btn(🅾️) then
		self.spr=18
	 if self.prop >= 0.5 then
	 	sfx(0,3)
	  add(actors,bubble:new({x=self.x,y=self.y+4,vx=rand(-2,2)-self.dir*0.5,vy=rand(1,2),lt=rand(30,120)}))
 	 self.prop -= 0.5
 	 self.vy -= 0.375
 		self.vx += self.dir * 0.25
		end
	else
		if (self.prop <= 2.95 and self.oxygen >= 0.05) then
			self.oxygen-=0.05
	 	self.prop=clamp(self.prop+0.05,0,3)	
		end
	end
	self.vx=clamp(self.vx+self.dir*0.04,-1,1)
	self.vy=clamp(self.vy+0.02,-1,1)
	self.x=clamp(self.x+self.vx,4,123)
	if depth>150 then
		self.y=clamp(self.y+self.vy,4,256)
	end
end

function jelly:draw()
 s=self.spr+self.dir
 if self.inv%2==1 then
		pal(12,0)		
	end
	spr(s,self.x-4,self.y-4)
	pal(12,12)
end

function jelly:collides(other)
 if other.fx==true then
  return false
 end
	dx=self.x/10-other.x/10
	dy=self.y/10-other.y/10
	dist=dx^2+dy^2
	if dist<=(self.r/10+other.r/10)^2 then
		return true
	end
	return false
end

bubble = obj:new({
 x=0,
 y=0,
	vx=0,
	vy=0,
 lt=0,
 fx=true
})

function bubble:update()
 self.vx=clamp(self.vx*0.8,-2,2)
	self.vy=clamp(self.vy-0.1,-1,2)
	self.x+=self.vx
	self.y+=self.vy
	self.lt-=1
	if self.lt <= 0 then
	 self.dead=true
	end
end

function bubble:draw()
 if frame%2==0 then
  r=self.lt/30
  circ(self.x,self.y,r,12)
 end
end

star = obj:new({
 x=0,
 y=-8,
 r=3,
	vx=0,
	vy=0.5,
})

function star:draw()
 spr(4+(frame/2)%2,self.x-4,self.y-4)
end

function star:update()
	self.y+=self.vy
end

function star:collided(jel)
 if jel.inv==0 then
  jel.inv=60
		jel.prop=0
		jel.vy=1
		sfx(2,3)
	end
end

fish = obj:new({
 x=0,
 ix=0,
 y=0,
 r=7,
	vx=0,
	vy=0.25,
})

function fish:draw()
	f=self.vx<0
	s=flr(frame/2%2)*2
 spr(36+s,self.x-8,self.y-8,2,2,f)
end

function fish:update()
	if self.x > self.ix+24 then
		self.vx=-1
	end
	if self.x < self.ix-24 then
		self.vx=1
	end
	self.x+=self.vx
	self.y+=self.vy
end

function fish:collided(jel)
 if jel.inv==0 then
  jel.inv=60
		jel.prop=0
		jel.vy=1
		sfx(2,3)
	end
end

squid = obj:new({
 x=0,
 y=0,
 r=6,
	vx=0,
	vy=0.25,
})

function squid:draw()
	f=self.vx<0
	s=flr(frame/2%2)*2
 spr(32+s,self.x-8,self.y-8,2,2,f)
end

function squid:update()
	if self.x >= 124 then
		self.vx=-1
	end
	if self.x <= 4 then
		self.vx=1
	end
	self.x+=self.vx
	self.y+=self.vy
end

function squid:collided(jel)
 if jel.inv==0 then
  jel.inv=60
		jel.prop=0
		jel.vy=1
		sfx(2,3)
	end
end

air = obj:new({
 x=0,
 ix=0,
 y=-8,
	vx=0,
	r=4,
	vy=0.25,
	p=0
})

function air:draw()
	spr(16,self.x-4,self.y-4)
end

function air:update()
	self.x=self.ix+sin(self.p/128)*16
	self.y+=self.vy
	self.p=(self.p+1)%128
end

function air:collided(jel)
	self.dead=true
	sfx(1,3)
	for i=1,8 do
	 add(actors,bubble:new({x=self.x,y=self.y+4,vx=rand(-2,2),vy=rand(1,2),lt=rand(30,120)}))	
	end
	jel.score+=-flr(-jel.oxygen)*4
	jel.oxygen=20
end

function clamp(val, min, max)
 if val < min then
 	return min
 elseif val > max then
  return max
 end
 return val
end

function rand(min,max)
	return rnd(max-min)+min
end

function draw_depth()
	nm=-flr(-depth/32)*32
	nt=nm-depth
	nt=nt+64
	nd=nm+64
	for i=64+nt,-16,-32 do
	 w=2
	 if nd/32%5==0 then
  	print(nd/32,1,i-8,13)
  	w=8
	 end
  line(1,i,w,i,13)	
  line(126-w,i,126,i,13)	
 	nd-=32
	end
end

function draw_ui()
	rectfill(0,118,128,128,0)
	print("oxygen",1,119,7)
	print("score",80,119,7)
	print(player.score,104,119,7)

	ox=clamp(player.oxygen-0.05,0,20)
	ox=(ox/19.95)*5
	for i=0,4 do
	 if i < ox then
	  pal(12,12)
	 else
 	 pal(12,5)
	 end
		spr(20,28+i*6,119)
	end
	pal(12,12)
	
	p=clamp(player.prop-0.5,0,player.prop)
	w=(p/2.5)*64
	rectfill(64-w,126,64+w,128,12)
end

function _draw()
	state.draw()
end

function _update()
	state.update()
end

function game_init()
 frame=0
 depth=32000
 actors = {}
 player=jelly:new()
 add(actors, player)
 spawners = {}
 ms=cocreate(main_spawner)
 add(spawners,ms)
 music(3,0,7)
end

function wait(interval)
	local c=interval
	while c>0 do
		c-=1
		yield()
	end
end

function main_spawner()
	add(spawners,cocreate(air_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s1))
	wait(1100)
	add(spawners,cocreate(fish_s1))
	wait(1100)
	add(spawners,cocreate(squid_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s4))
	wait(1100)
	add(spawners,cocreate(starfish_s1))
	add(spawners,cocreate(fish_s1))
	wait(1100)
	add(spawners,cocreate(fish_s1))
	add(spawners,cocreate(squid_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s1))
	add(spawners,cocreate(squid_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s1))
	add(spawners,cocreate(fish_s1))
	add(spawners,cocreate(squid_s1))
	wait(1200)
	
	add(spawners,cocreate(squid_s4))
	wait(1100)
	add(spawners,cocreate(fish_s2))
	add(spawners,cocreate(squid_s2))
	wait(1100)
	add(spawners,cocreate(starfish_s3))
	wait(1100)
	add(spawners,cocreate(starfish_s2))
	add(spawners,cocreate(squid_s2))
	wait(1100)
	add(spawners,cocreate(starfish_s2))
	add(spawners,cocreate(fish_s2))
	wait(1100)
	add(spawners,cocreate(fish_s3))
	wait(1100)
	add(spawners,cocreate(fish_s3))
	add(spawners,cocreate(squid_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s2))
	add(spawners,cocreate(fish_s2))
	add(spawners,cocreate(squid_s2))
	wait(1300)
	
	add(spawners,cocreate(fish_s4))
	wait(1100)
	add(spawners,cocreate(starfish_s3))
	add(spawners,cocreate(squid_s1))
	wait(1100)
	add(spawners,cocreate(squid_s3))
	add(spawners,cocreate(fish_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s4))	
	wait(1100)
	add(spawners,cocreate(fish_s3))
	add(spawners,cocreate(starfish_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s2))
	add(spawners,cocreate(fish_s1))
	add(spawners,cocreate(squid_s1))
	wait(1100)
	add(spawners,cocreate(squid_s4))
	wait(1100)
	add(spawners,cocreate(squid_s3))
	add(spawners,cocreate(starfish_s1))
	wait(1100)
	add(spawners,cocreate(starfish_s1))
	add(spawners,cocreate(fish_s1))
	add(spawners,cocreate(squid_s2)) 
 wait(1200)
 
	add(spawners,cocreate(starfish_s4))
	add(spawners,cocreate(squid_s1)) 
	wait(1100)
	add(spawners,cocreate(starfish_s3))
	add(spawners,cocreate(fish_s3))
	add(spawners,cocreate(squid_s3)) 
end

function game_update()
 for actor in all(actors) do
  if player!=actor then
   if player:collides(actor) then
    actor:collided(player)
   end
  end
  actor:update()
  if actor.dead or actor.y<-12 or actor.y>140 then
   del(actors,actor)
  end
 end
 
 for spawner in all(spawners) do
  coresume(spawner)
  if costatus(spawner)==false then
  	del(spawners,spawner)
  end
 end
 
 frame+=1
 depth-=1
 
 if player.y>=132 then
 	change_state(gameover_state)
 end
 
 if depth<150 then
  player.y-=2
  if player.y<-8 then
  	change_state(win_state)
  end
 end
end

function starfish_s1()
	for i=1,10 do
	 wait(90)
  spawn_starfish()
	end
end

function starfish_s2()
	for i=1,13 do
	 wait(75)
  spawn_starfish()
	end
end

function starfish_s3()
	for i=1,16 do
	 wait(60)
  spawn_starfish()
	end
end

function starfish_s4()
	for i=1,33 do
	 wait(30)
  spawn_starfish()
	end
end

function spawn_starfish()
	add(actors,star:new({x=rand(10,117)}))
end

function fish_s1()
	for i=1,5 do
		wait(200)
  spawn_fish()
	end
end

function fish_s2()
	for i=1,5 do
		wait(180)
  spawn_fish()
	end
end

function fish_s3()
	for i=1,6 do
		wait(160)
  spawn_fish()
	end
end

function fish_s4()
	for i=1,11 do
		wait(90)
  spawn_fish()
	end
end

function spawn_fish()
	px=rand(10,117)
	v=rnd(100)
	if v>50 then 
		v=1
	else
	 v=-1
	end
	varx=rnd(24)-12
	add(actors,fish:new({ix=px,x=px+varx,y=-10,vx=v}))
end

function squid_s1()
	for i=1,5 do
		wait(200)
  spawn_squid()
	end
end

function squid_s2()
	for i=1,5 do
		wait(170)
  spawn_squid()
	end
end

function squid_s3()
	for i=1,7 do
		wait(140)
  spawn_squid()
	end
end

function squid_s4()
	for i=1,14 do
		wait(70)
  spawn_squid()
	end
end

function spawn_squid()
	v=rnd(100)
	if v>50 then 
		v=1
	else
	 v=-1
	end
 add(actors,squid:new({x=rand(8,120),y=136,vx=v,vy=-0.5})) 
end

function air_s1()
	while true do
		wait(180)
  spawn_air()
	end
end

function spawn_air()
	add(actors,air:new({ix=rand(10,117),p=rnd(128)}))
end

function game_draw()
 cls()
 draw_depth() 
 for actor in all(actors) do
  actor:draw()
 end
 draw_ui()
end

function wait_title()
	frame=0
	show_prompt=true
 while true do
 	frame+=1
 	if btn(🅾️) or btn(❎) then
 	 cr={}
 	 add(cr,cocreate(start_title))
 	 return
 	end
 	yield()
 end
end

function start_title()
	show_prompt=false
 sfx(0,3)
	f=0
	while (f<32) do
	 p=f/32
	 tx=(1-p)*60+p*148
	 ty=(1-p)*40+p*156
	 jx=(1-p)*36+p*-72
	 jy=(1-p)*44+p*-80
	 f+=1
	 yield()
	end
	cr={}
	change_state(game_state)
end

function move_title()
	f=0
	while (f<32) do
	 p=f/32
	 tx=(1-p)*-72+p*60
	 ty=(1-p)*-80+p*40
	 jx=(1-p)*132+p*36
	 jy=(1-p)*128+p*44
	 f+=1
	 yield()
	end
	sfx(1,3)
	cr={}
	add(cr,cocreate(wait_title))
end

function title_init()
	show_prompt=false
	tx=-72
	ty=-64
	jx=128
	jy=128
	cr={}
	add(cr,cocreate(move_title))
end

function title_draw()
	cls()
	spr(9,tx,ty,5,4)
	spr(7,jx,jy,2,2)
	if show_prompt then
	 if (band(frame%8,4)==4) then
		 print("press 🅾️,❎ to start",28,76,7)
		end
	end
end

function title_update()
 for c in all(cr) do
 	coresume(c)
 	if (costatus(c)==false) then
 		del(cr, c)
 	end
 end
end

function win_init()
 sfx(3,3)
	f=0
	z=0
	jx=132
	jy=128
end

function win_draw()
 cls()
	spr(46,jx,jy,2,2)
	if band(z%8,4)==4 then
 	print("congratulations",32,42,7)
		print("  you made it! ",32,48,7)
	end
end

function win_update()
 z+=1
 if (f<32) do
	 p=f/32
	 jx=(1-p)*132+p*54
	 jy=(1-p)*128+p*64
	end
	if f<120 then
	 f+=1
	end
 if f==120 then
 	if btn(🅾️) or btn(x) then
 		change_state(title_state)
 	end
 end	
end

function gameover_init()
 sfx(4,3)
	f=0
	jx=-40
	jy=-16
end

function gameover_draw()
	cls()
	spr(14,jx,jy,2,2)
	if band(f%8,4)==4 then
 	print("better luck",64,42,7)
		print(" next time ",64,48,7)
	end
end

function gameover_update()
 p=f/120
 jx=(1-p)*-40+p*72
 jy=(1-p)*-16+p*128
 f+=1
	if f>=140 then
		change_state(title_state)
	end
end

function _init()
 title_state={
  init = title_init,
 	draw = title_draw,
 	update = title_update
 }
 
 game_state={
 	init = game_init,
  draw = game_draw,
  update = game_update
 }
 
 win_state={
 	init = win_init,
 	draw = win_draw,
 	update = win_update
 }
 
 gameover_state={
 	init = gameover_init,
 	draw = gameover_draw,
 	update = gameover_update
 }
 
	change_state(title_state)
end

function change_state(new_state)
	state=new_state
	state:init()
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011110000
000000000000cc0000cccc0000cc000000008000008000000000000000000cccccc00000000ccccc000000000000000000000000000000000000000111111000
0000000000cc00c00c0000c00c00cc000000800000080080000000000000ccccccccc00000ccccccc00000000000000000000000000000000000000110011100
000000000c000a0cc0a00a0cc0a000c0088880000008880000000000000ccc00000ccc0000ccccccc00000000000000000000000000000000000001110001100
00000000c0a0000cc000000cc0000a0c00088880008880000000000000ccc000aa00ccc0000ccccc00000000000cc00000000000000000000000011100000110
00000000c000ccccc0cccc0ccccc000c0008000008008000000000000ccc0000aa000ccc0000ccc00000000000ccc00cc0000000000000000111111000000110
00000000c0cc0000cc0000cc0000cc0c0008000000000800000000000cc00000000000cc0000ccc00000000000ccc0ccc000000000000000111111000a0a0110
000000000c00000000000000000000c00000000000000000000000000cc00aa0000000cc0000ccc000ccccc000ccc0ccc0000000000000001100000000a00110
00cccc000000000000cccc000000000000ccc00000000000000000000cc00aa0000000cc0000ccc00ccccccc00ccc0ccc000000000000000110000000a0a0110
0c0000c000ccc0000c0000c0000ccc000c00cc0000000000000000000cc0000000cccccccc00ccc0cccc0cccc0ccc0ccc000000000000000110000a0a0000110
c000c00c0c00ac000ca00ac000ca00c00c000c0000000000000000000cc000000cccccc0cc00ccc0ccc000ccc0ccc0ccc0000000000000001110000a00001110
c0000c0c0a0000c00c0000c00c0000a00c000c0000000000000000000cc00000ccc00000ccc0ccc0ccccccccc0ccc0ccc00cc000cc000000011100a0a0011100
c0000c0c0c0000c00c0000c00c0000c000ccc000000000000000000000cc000ccc000000ccccccc0cccccccc00ccc0ccc0ccc000ccc000000011100000111000
c000000c00c0cccc0c0cc0c0cccc0c0000000000000000000000000000ccc00cc00000000cccccc0cc00000000ccc0ccc0ccc000ccc000000001111111110000
0c0000c000cc000c0cc00cc0c000cc00000000000000000000000000000cccccc000000000cccc00ccc000cc00ccc0ccc0ccc000ccc000000000011111100000
00cccc00000c00000c0000c00000c0000000000000000000000000000000cccc00000000000000000ccccccc00ccc0ccc0ccc000ccc000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000ccccc000ccc0ccc0ccc000ccc000000000000000000000
0000000000000aa00000000000000aa00000bbbbb00000000000bbbbb000000000000000000000000000000000cc00ccc0cccc0cccc0000000000cccccc00000
00000000000aaaa000000000000aaaa000000bbbbbb0000000000bbbbbb00000000000000000000cc0000000000000cc000cccccccc000000000ccccccccc000
000000000aaaaa00000000000aaaaa000000000bbbbbb0000000000bbbbbb00000000000000000ccc00000cc000000000000cccc0cc00000000ccc00000ccc00
000000aaaaaaaa00000000aaaaaaaa000000000bbbbbbb0000b0000bbbbbbb0000000000000000ccc0000ccc00cccccc000000000cc0000000ccc000aaa0ccc0
00000aa0aaaaa00000000aa0aaaaa000bb0000bbbb0bbbb000bb00bbbb0bbbb000000000000000ccc0000ccc0cccccccc00000000cc000000ccc0000a0000ccc
00000aa00aaaa00000000aa00aaaa0000bb00bbbb000bbb000bb0bbbb000bbb000000000000000ccc0000ccc0cccc00ccc0cc0000cc000000cc00000a00000cc
000000aaa0aa0000000000aaa0aa000000bbbbbbbb0bbbbb00bbbbbbbb0bbbbb00000000000000ccc0000ccc0ccc000ccc0ccc00ccc000000cc00aaa000000cc
0000aa0aa00a000000000a0aa00a000000bbbbbbbbbbb000000bbbbbbbbbb00000000000000000ccc0000ccc0ccc000ccc00cccccc0000000cc00a00000000cc
000a0000aaaa000000000a00aaaa000000bbbbbbbbbb0000000bbbbbbbbb00b000000000000000ccc0000ccc0ccc0cccc0000cccc00000000cc00a0000cccccc
000a00aa0aa00000000aa00a0aa0000000bbbbbbbbb0000000bbbbbbbbb00bb000000000000000cccc00cccc0ccccccc00000000000000000cc000000cccccc0
0aa00a000000000000a0000a000000000bb00bbbbbbb00b000bb0bbbbbbbbb00000000000000000cccccccc00cccccc000000000000000000cc00000ccc00000
00000a000000000000a00aa000000000bb0000bbbbbbbb0000b000bbbbbbb00000000000000000000ccccc000ccc0000000000000000000000cc000ccc000000
000aa000000000000000a000000000000000000bbbbbb00000b0000bbbbb00000000000000000000000000000ccc0000000000000000000000ccc00cc0000000
00000000000000000000a0000000000000000000bb00000000000bbbbb0000000000000000000000000000000ccc00000000000000000000000cccccc0000000
00000000000000000000000000000000000000bbb0000000000000000000000000000000000000000000000000cc000000000000000000000000cccc00000000
__sfx__
000200001c56024560215601a56020550275501d540175401a530235301f530175301a53025520205201a5101a51015500185001b5001e5001f5002050020500205001b5001650016500165001a5002150022500
0002000001060090601306024060310500b050130501c050240502e050360503f040320402f0402b0302702023020200201b010320100a0000e00012000180001a00021000260002a0002d00035000380003d000
00010000080300c040170601e070270702f070290701f060160500f0300a0200801003010080200e04006070040500a030100200c0300704003020080100d0100e0300703004020040000e000100000800005000
001400001707013070100700c0701707013070100500c0501705013050100500c0501703013030100300c0301703013030100100c0101701013010100100c0101700013000100000c0001700013000100000c000
000c0000310702c0702707023070200701d0701a07019060170601505012050100500e0500d0500b0400a04009040070400503004030030300303002020010200102001020010200101001010010100100001000
__music__
00 03424344

