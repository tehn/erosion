cc = {
	{{},{},{},{}},
	{{},{},{},{}},
	{{},{},{},{}},
	{{},{},{},{}},
	p = {0,0,0,0}
}

function init_cc()
	cc[1][1] = {cc=10, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[1][2] = {cc=11, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[1][3] = {cc=12, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[1][4] = {cc=13, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}

	cc[2][1] = {cc=14, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[2][2] = {cc=15, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[2][3] = {cc=16, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[2][4] = {cc=17, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}

	cc[3][1] = {cc=18, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[3][2] = {cc=19, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[3][3] = {cc=20, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[3][4] = {cc=21, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}

	cc[4][1] = {cc=22, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[4][2] = {cc=23, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[4][3] = {cc=24, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
	cc[4][4] = {cc=25, ch=1, a=true, slew=0, min=0, max=127, val=0, v=0, s=0}
end

init_cc()

mode = 1
param = 1
dirty = true

meta = {
	script = "erosion",
	version = "0.1",
	bank = 1,
	scene = 1,
	slot = { {},{},{},{},{},{},{},{} },
}

function init()
	print("\\\\ erosion \\\\\\\\")
	temp = pset_read(1)
	if not temp or temp.script ~= "erosion" then
		print("writing default pset")
		pset_write(1,meta)
		pset_write(1+(meta.bank-1)*8+meta.scene,cc)
	else
		meta = temp
		print("read pset metadata")
		cc = pset_read(1+(meta.bank-1)*8+meta.scene)
		-- reset slew positions:
		for n=1,4 do
			for k=1,4 do
				slew.to(sl[n][k], cc.p[n], 0)
			end
		end
		delta_update_all()
		-- CAN REMOVE LATER:
		if not cc[1][1].ch then for x=1,4 do for y=1,4 do cc[x][y].ch = 1 end end end
		if not cc[1][1].a then for x=1,4 do for y=1,4 do cc[x][y].a = true end end end
	end
	-- start redraw
	rm = metro.new(redraw, 33, -1)
	set_mode(1)
end



RANGE = 1023
-- NORMAL
--
function enter_normal()
	for i=1,4 do arc_res(i,1) end
end

function delta_slew(n,k,a)
	--print("delta_slew",n,k,a)
	local b = linlin(0,RANGE,cc[n][k].min,cc[n][k].max,a)
	cc[n][k].v = b
	local c = math.floor(b)
	if(c ~= cc[n][k].val) then
		--print("cc to "..c)
		cc[n][k].val = c
		midi_cc(cc[n][k].cc,c,cc[n][k].ch)
	end
	--point2(n,math.floor(b*8.0))
	dirty = true
end

function delta_normal(n,d)
	local a = clamp(cc.p[n] + d*4,0,RANGE)
	if(cc.p[n] ~= a) then
		cc.p[n] = a
		--arc_led_all(n,0)
		for k=1,4 do
			if cc[n][k].a then
				if cc[n][k].slew > 0 then
					local sss = cc[n][k].slew * 32
					--print("start slew "..sss)
					slew.to(sl[n][k], a, sss)
				else
					local b = linlin(0,RANGE,cc[n][k].min,cc[n][k].max,a)
					cc[n][k].v = b
					local c = math.floor(b)
					if(c ~= cc[n][k].val) then
						cc[n][k].val = c
						midi_cc(cc[n][k].cc,c,cc[n][k].ch)
					end
					--point2(n,math.floor(b*8.0))
				end
			end
		end
		dirty = true
		--arc_refresh()
		--ps("%d %d %d %d %d %d",n,p[n],cc[n][1].val,cc[n][2].val,cc[n][3].val,cc[n][4].val)
	end
end

function delta_update_all()
	for n=1,4 do
		for k=1,4 do
			if cc[n][k].a then
				local b = linlin(0,RANGE,cc[n][k].min,cc[n][k].max,cc.p[n])
				cc[n][k].v = b
				local c = math.floor(b)
				if(c ~= cc[n][k].val) then
					cc[n][k].val = c
					midi_cc(cc[n][k].cc,c,cc[n][k].ch)
				end
			end
		end
	end
end

function redraw_normal()
	for n=1,4 do
		arc_led_all(n,0)
		for k=1,4 do
			if cc[n][k].a then
				point2(n,math.floor(cc[n][k].v*8.0))
			end
		end
	end
end

sl = {{},{},{},{}}
for n=1,4 do
	for k=1,4 do
		do sl[n][k] = slew.new(function(a) delta_slew(n,k,a) end,0,cc.p[n],0) end
	end
end


s = {0,0}
-- SCENE
--
function enter_scene()
	arc_res(1,8)
	arc_res(2,8)
	saving = false
	scene_action = "load"
end

function delta_scene(n,d)
	if n==1 then
		s[1] = clamp(s[1] - d,1,28)
		meta.bank = (s[1] >> 2) + 1
	elseif n==2 then
		s[2] = clamp(s[2] - d,1,28)
		meta.scene = (s[2] >> 2) + 1
	elseif n==3 then
		if d>0 then scene_action = "erase"
		else scene_action = "load" end
	elseif n==4 then
		if d>0 then scene_action = "save"
		else scene_action = "load" end
	end
	dirty = true
end

function redraw_scene()
	arc_led_all(1,0)
	for n=1,8 do
		arc_led(1,42-n*2,n == meta.bank and 15 or 1)
	end
	arc_led_all(2,0)
	for n=1,8 do
		arc_led(2,51-n*4,n == meta.scene and 15 or 1)
		if meta.slot[meta.bank][n] then
			arc_led(2,52-n*4,1)
			arc_led(2,50-n*4,1)
		end
	end
	arc_led_all(3,scene_action=="erase" and 1 or 0)
	arc_led_all(4,scene_action=="save" and 1 or 0)
end


-- SELECT
--
function enter_select()
	print("ENTER SELECT!")
	edit_n = 0
	selected = false
	select_level = 2
	seldelta = {0,0,0,0}
	dirty = true
	sm1 = metro.new(select_pulse, 150, -1)
end

function delta_select(n,d)
	if selected == false then
		seldelta[n] = seldelta[n] + d
		if math.abs(seldelta[n]) > 5 then
			selected = true
			select_level = 4
			edit_n = n
			sm2 = metro.new(select_wait, 600, 1)		
		end
	end
end

function redraw_select()
	if not selected then
		for n=1,4 do
			arc_led_all(n,select_level + math.abs(seldelta[n]))
		end
	else
		for n=1,4 do
			arc_led_all(n,edit_n == n and select_level or 0)
		end
	end
end

function select_pulse()
	if not selected then select_level = (select_level % 2) + 1
	else select_level = select_level - 1 end
	dirty = true
end

function select_wait()
	print("wait")
	metro.stop(sm1)
	set_mode(4)
	print("TO EDIT MODE")
	for n=1,4 do 
		if cc[edit_n][n].a then
			midi_cc(cc[edit_n][n].cc,cc[edit_n][n].min,cc[edit_n][n].ch)
		end
	end
end



-- EDIT
--
TOTAL_PARAMS = 6
param_name = {"MIN","MAX","SLEW","CC NUM","CC CH","ACTIVE"}
function enter_edit()
	param = 1
end

function delta_edit(n,d)
	if param == 1 then
		local l = cc[edit_n][n].min
		local a = clamp(l + d,0,127)
		if l ~= a then
			cc[edit_n][n].min = a
			midi_cc(cc[edit_n][n].cc,a,cc[edit_n][n].ch)
			dirty = true
		end
	elseif param == 2 then
		local l = cc[edit_n][n].max
		local a = clamp(l + d,0,127)
		if l ~= a then
			cc[edit_n][n].max = a
			midi_cc(cc[edit_n][n].cc,a,cc[edit_n][n].ch)
			dirty = true
		end
	elseif param == 3 then
		local l = cc[edit_n][n].slew
		local a = clamp(l + d,0,127)
		if l ~= a then
			cc[edit_n][n].slew = a
			--print("slew = "..a)
			dirty = true
		end
	elseif param == 4 then
		local l = cc[edit_n][n].cc
		local a = clamp(l + d,0,127)
		if l ~= a then
			cc[edit_n][n].cc = a
			ps("cc %d,%d = %d",edit_n,n,a)
			dirty = true
		end
	elseif param == 5 then
		local l = cc[edit_n][n].ch
		local a = clamp(l - d,1,16)
		if l ~= a then
			cc[edit_n][n].ch = a
			ps("ch %d,%d = %d",edit_n,n,a)
			dirty = true
		end
	elseif param == 6 then
		cc[edit_n][n].a = d>0
		dirty = true
	end
end

function redraw_edit()
	for n=1,4 do
		local act = cc[edit_n][n].a and 1 or 0
		arc_led_all(n,0)
		arc_led(n,36,param == 1 and 10 or act)
		arc_led(n,30,param == 2 and 10 or act)
		arc_led(n,33,param == 3 and 10 or act)
		if param == 1 then
			point2(n,cc[edit_n][n].min * 8)
		elseif param == 2 then
			point2(n,cc[edit_n][n].max * 8)
		elseif param == 3 then
			point2(n,cc[edit_n][n].slew * 8)
		elseif param == 4 then
			local z = cc[edit_n][n].cc
			local a = math.floor(z / 100)
			local b = math.floor((z%100)/10)
			local c = math.floor(z%10)
			--ps("%d = %d %d %d",z,a,b,c)
			arc_led(n,63,a==1 and 10 or 1)
			for i=1,9 do
				arc_led(n,51+i,b==i and 10 or 1)
				arc_led(n,40+i,c==i and 10 or 1)
			end
		elseif param == 5 then
			for i=1,16 do
				arc_led(n,24-i,cc[edit_n][n].ch==i and 10 or 1)
			end
		elseif param == 6 then
			for i=1,32 do arc_led(n,(47+i)%64+1,cc[edit_n][n].a and 1 or 0) end
		end
	end
end



func_delta = {delta_normal, delta_scene, delta_select, delta_edit}
func_redraw = {redraw_normal, redraw_scene, redraw_select, redraw_edit}
func_enter = {enter_normal, enter_scene, enter_select, enter_edit}
function set_mode(n)
	mode = n
	arc = func_delta[n]
	func_enter[n]()
	dirty = true
end
function redraw()
	if dirty then
		func_redraw[mode]()
		arc_refresh()
		dirty = false
	end
end


function arc_key(z)
	if z == 1 then
		km = metro.new(key_timer,500,1)
	elseif km then
		--print("keyshort")
		metro.stop(km)
		if mode==1 then
			set_mode(2)
			print("TO SCENE MODE")
		elseif mode==2 then
			set_mode(1)
			print("TO NORMAL MODE")
		elseif mode==3 then
			set_mode(1)
			print("TO NORMAL MODE")
			metro.stop(sm1)
		elseif mode==4 then
			print("EDIT MODE: TOGGLE PARAM")
			param = (param % TOTAL_PARAMS) + 1
			ps("PARAM: %s", param_name[param])
			if param==1 then
				for n=1,4 do if cc[edit_n][n].a then
					midi_cc(cc[edit_n][n].cc,cc[edit_n][n].min,cc[edit_n][n].ch) end end
			elseif param==2 then
				for n=1,4 do if cc[edit_n][n].a then
					midi_cc(cc[edit_n][n].cc,cc[edit_n][n].max,cc[edit_n][n].ch) end end
			end
			dirty = true
		end
	end
end

function key_timer()
	--print("keylong!")
	metro.stop(km)
	km = nil
	if mode==1 then
		set_mode(3)
		print("TO SELECT MODE")
	elseif mode==2 then
		if scene_action == "load" then
			if meta.slot[meta.bank][meta.scene] then
				set_mode(1)
				print("LOAD PSET")
				print("TO NORMAL MODE")
				slew.allfreeze()
				pset_write(1,meta)
				cc = pset_read(1+(meta.bank-1)*8+meta.scene)
				-- reset slew positions:
				for n=1,4 do
					for k=1,4 do
						slew.to(sl[n][k], cc.p[n], 0)
					end
				end
				-- CAN REMOVE LATER:
				if not cc[1][1].ch then for x=1,4 do for y=1,4 do cc[x][y].ch = 1 end end end
				if not cc[1][1].a then for x=1,4 do for y=1,4 do cc[x][y].a = true end end end
			else
				print("BLANK PSET HERE")
				init_cc()
			end
		elseif scene_action == "erase" then
			print("ERASED SLOT")
			meta.slot[meta.bank][meta.scene] = false
			scene_action = "load"
			pset_write(1,meta)
		elseif scene_action == "save" then
			print("SAVED PSET")
			meta.slot[meta.bank][meta.scene] = true
			scene_action = "load"
			pset_write(1+(meta.bank-1)*8+meta.scene,cc)
			pset_write(1,meta)
		end
		dirty = true
	elseif mode==3 then
		set_mode(1)
		metro.stop(sm1)
		print("TO NORMAL MODE")
	elseif mode==4 then
		set_mode(1)
		print("TO NORMAL MODE")
		print("UPDATE ALL POSITIONS")
		delta_update_all()
	end
end



-- draw point 1-1024
function pointr3(n,x)
	-- FIXME this is not efficient
	local xx = math.floor(linlin(0,127,1,768,127-x)) + 128 + 512
	local c = xx >> 4
	arc_led_rel(n,c%64+1,15)
	arc_led_rel(n,(c+1)%64+1,xx%16)
	arc_led_rel(n,(c+63)%64+1,15-(xx%16))
end

function point2(n,x)
	local xx = math.floor(linlin(0,RANGE,1,768,x)) + 128 + 512
	local c = xx >> 4
	arc_led_rel(n,c%64+1,15-(xx%16))
	arc_led_rel(n,(c+1)%64+1,(xx%16))
end


init()
