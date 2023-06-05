minetest.register_entity("face_object_example:example_sam",{
	initial_properties = {
		visual = "mesh",
		mesh = "character.b3d", -- from player_api, set to optional depends just for CDB to work
		animation_speed = 30,
		textures = {"character.png"},
		collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
		nametag = "Face Object Example: Sam",
		infotext = "Rightclick to look at Sam. \nPunch to remove it.",
		hp_max = 1,
		is_visible = true,
	},
	on_rightclick = function(self, clicker)
		local obj = self.object
		face_object.face_each_other(obj,clicker)
	end,
	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir, damage)
		local obj = self.object
		obj:set_hp(0)
	end,
})

minetest.register_chatcommand("face_object_example",{
	description = "Example of Face Object",
	privs = {server=true},
	func = function(name,param)
		local player = minetest.get_player_by_name(name)
		local pos = player:get_pos()
		minetest.add_entity(pos, "face_object_example:example_sam")
	end
})
