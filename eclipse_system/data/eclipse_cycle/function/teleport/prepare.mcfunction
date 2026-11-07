# Operator API. Run as the player. ec.tx/ty/tz are the requested Overworld block coordinates.
execute unless entity @s[type=minecraft:player,tag=ec.eligible] run return 0
scoreboard players set @s ec.ready 0
scoreboard players set @s ec.target 0
execute unless score @s ec.tx matches -29999983..29999983 run return 0
execute unless score @s ec.tz matches -29999983..29999983 run return 0
execute unless score @s ec.ty matches -64..319 run return 0
execute at @s unless dimension minecraft:the_nether run return 0
execute at @s run function eclipse_cycle:space/obsidian
execute unless score @s ec.portal matches 1 run return 0
function eclipse_cycle:cache/ensure
scoreboard players operation #sample_x ec.sys = @s ec.tx
scoreboard players operation #sample_z ec.sys = @s ec.tz
function eclipse_cycle:space/range5
scoreboard players operation @s ec.target = #inside ec.sys
scoreboard players operation @s ec.px = @s ec.tx
scoreboard players operation @s ec.py = @s ec.ty
scoreboard players operation @s ec.pz = @s ec.tz
scoreboard players operation @s ec.pday = #day ec.sys
scoreboard players set @s ec.ready 1
