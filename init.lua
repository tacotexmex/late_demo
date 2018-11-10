--[[
	Late Demo - LATE mod demonstration for Minetest
	(c) Pierre-Yves Rollo

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation, either version 2.1 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
--]]

late_demo = {}
late_demo.name = minetest.get_current_modname()
late_demo.path = minetest.get_modpath(late_demo.name)
late_demo.mods = {
	extra = minetest.global_exists("late_extra_impacts"),
	armor = minetest.global_exists("armor"),
	wielded_light = minetest.global_exists("wielded_light"),
}

local stacks = {
	'late_demo:invisibility_ring',
	'late_demo:regeneration_ring',
	'late_demo:bad_ring',
	'late_demo:light_amulet',
	'late_demo:antidote_amulet',
	'late_demo:lightweight_amulet',
	'late_demo:darkstone 10',
	'late_demo:lightstone 10',
	'late_demo:poison 10',
}

minetest.register_chatcommand("late_demo", {
	params = "",
	description = "Gives a bunch of items using Late for demonstration",
	func = function(name, param)
		minetest.chat_send_player(name, "[LATE demo] Adding toys to your inventory. Have fun!")
		if minetest.get_player_by_name(name) then
			local inv = minetest.get_player_by_name(name):get_inventory()
			for _, stackstr in pairs(stacks) do
				local stack = ItemStack(stackstr)
				if not inv:contains_item("main", stack)
					and inv:room_for_item("main", stack) then
					inv:add_item("main", stack)
				end
			end
		end
	end,
})


-- 3D Armor integration
if late_demo.mods.armor then
	-- Allow extra stuff to be equiped also
	if armor.elements then
		table.insert(armor.elements, "neck")
		table.insert(armor.elements, "finger")
	end
end

-- Basic impact items
minetest.register_tool("late_demo:invisibility_ring", {
	description = "Invisibility ring",
	inventory_image = "late_demo_ring_simple.png",
	groups = { armor_finger=1 },
	texture = "late_demo_transparent",
	preview = "late_demo_ring_armor_preview",
	effect_equip = {
		impacts = { texture={opacity=0}, nametag={opacity=0} },
	}
})

minetest.register_tool("late_demo:regeneration_ring", {
	description = "Regeneration ring",
	inventory_image = "late_demo_ring_gem.png",
	groups = { armor_finger = 1 },
	texture = "late_demo_transparent",
	preview = "late_demo_ring_armor_preview",
	effect_equip = {
		impacts = { damage={ -1, 5 } },
	}
})

minetest.register_tool("late_demo:bad_ring", {
	description = "Bad ring",
	inventory_image = "late_demo_ring_double_spikes.png",
	groups = { armor_finger = 1 },
	texture = "late_demo_transparent",
	preview = "late_demo_ring_armor_preview",
	effect_equip = {
		raise = 5, fall = 1,
		impacts = { damage = {1, 3}, speed = 0.5 },
	}
})

minetest.register_tool("late_demo:light_amulet", {
	description = "Light amulet",
	inventory_image = "late_demo_amulet_big_gem.png",
	groups = { armor_neck = 1 },
	texture = "late_demo_amulet_armor_texture",
	preview = "late_demo_amulet_armor_preview",
	effect_equip = {
		groups = { vision=1 },
		raise = 1, fall = 3,
		impacts = { daylight=1 },
	}
})

minetest.register_tool("late_demo:antidote_amulet", {
	description = "Antidote amulet",
	inventory_image = "late_demo_amulet_big.png",
	groups = { armor_neck = 1 },
	texture = "late_demo_amulet_armor_texture",
	preview = "late_demo_amulet_armor_preview",
	effect_equip = {
		raise = 1, fall = 3,
		impacts = { effects = { poison=0 } },
	}
})

minetest.register_tool("late_demo:lightweight_amulet", {
	description = "Light weight amulet",
	inventory_image = "late_demo_amulet_ankh.png",
	groups = { armor_neck = 1 },
	texture = "late_demo_amulet_armor_texture",
	preview = "late_demo_amulet_armor_preview",
	effect_equip = {
		impacts = { gravity = 0.5 }, raise = 3, fall = 3,
	}
})

minetest.register_node("late_demo:darkstone", {
	description = "Dark stone of darkness",
	tiles = { "default_stone.png", "default_stone.png", "default_stone.png",
		"default_stone.png", "default_stone.png", "late_demo_rune_f.png" },
	groups = {cracky = 3, stone = 1, building = 1, effect_trigger = 1},
	paramtype = "light",
	paramtype2 = "facedir",
	effect_near = {
		groups = { vision=1 },
		distance = 10, spread = 5,
		impacts = { daylight = 0 },
	},
})

minetest.register_node("late_demo:lightstone", {
	description = "Light stone of daylight",
	tiles = {"default_stone.png", "default_stone.png", "default_stone.png",
		"default_stone.png", "default_stone.png", "late_demo_rune_o.png" },
	groups = {cracky = 3, stone = 1, building = 1, effect_trigger = 1},
	paramtype = "light",
	paramtype2 = "facedir",
	effect_near = {
		groups = { vision=1 },
		distance = 10, spread = 5,
		impacts = { daylight = 1 },
	},
})

if late_demo.mods.extra and late_demo.mods.wielded_light then
	minetest.register_tool("late_demo:tchernostick", {
		description = "Tchernostick",
		inventory_image = "late_demo_tchernostick.png",
		on_use = late.on_use_tool_callback,
		effect_use_on = {
			impacts = { texture = { colorize = '#00FF0060' }, illuminate = 10, nametag = { colorize="green"}  },
			duration = 30, raise = 5, fall = 5,
		}
	})
	table.insert(stacks, 'late_demo:tchernostick')
end

minetest.register_craftitem("late_demo:poison", {
	description = "Poison",
	inventory_image = "late_demo_potion.png",
	effect_use = {
		groups = { poison=1 },
		raise = 3, fall = 4,
		impacts = { damage = { 1, 1 } },
		duration = 10,
		stop_on_death = true,
	},
	on_use = late.on_use_tool_callback,
})
