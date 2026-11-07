scoreboard players set @s ec.spawn 0
scoreboard players operation #sample_x ec.sys = #spawn_x ec.sys
scoreboard players operation #sample_z ec.sys = #spawn_z ec.sys
function eclipse_cycle:space/respawn
function eclipse_cycle:space/range30
scoreboard players operation @s ec.zone = #inside ec.sys
tellraw @s [{"translate":"eclipse_cycle.spawn_result","fallback":"Spawn overlap (1 = yes): "},{"score":{"name":"@s","objective":"ec.zone"}}]
