# Pos -> floor(block) -> floor(chunk), including negative positions.
execute store result score #cx ec.sys run data get entity @s Pos[0] 1
execute store result score #cz ec.sys run data get entity @s Pos[2] 1
scoreboard players operation #cx ec.sys /= #sixteen ec.sys
scoreboard players operation #cz ec.sys /= #sixteen ec.sys
execute if score @s ec.day = #day ec.sys if score @s ec.cx = #cx ec.sys if score @s ec.cz = #cz ec.sys run return 0
execute store result storage eclipse_cycle:args cx int 1 run scoreboard players get #cx ec.sys
execute store result storage eclipse_cycle:args cz int 1 run scoreboard players get #cz ec.sys
function eclipse_cycle:space/chunk_lookup with storage eclipse_cycle:args
scoreboard players operation @s ec.cx = #cx ec.sys
scoreboard players operation @s ec.cz = #cz ec.sys
scoreboard players operation @s ec.day = #day ec.sys
scoreboard players operation @s ec.inside = #inside ec.sys
