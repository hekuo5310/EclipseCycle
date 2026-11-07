scoreboard players set #inside ec.sys 0
execute if score #kind ec.sys matches 0 run return 0
execute if score #kind ec.sys matches 5.. run return 0
scoreboard players operation #min_x ec.sys = #sample_x ec.sys
scoreboard players operation #max_x ec.sys = #sample_x ec.sys
scoreboard players operation #min_z ec.sys = #sample_z ec.sys
scoreboard players operation #max_z ec.sys = #sample_z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players remove #x ec.sys 5
scoreboard players remove #z ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players remove #x ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players remove #x ec.sys 5
scoreboard players add #z ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players remove #z ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players add #z ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players add #x ec.sys 5
scoreboard players remove #z ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players add #x ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #sample_x ec.sys
scoreboard players operation #z ec.sys = #sample_z ec.sys
scoreboard players add #x ec.sys 5
scoreboard players add #z ec.sys 5
scoreboard players operation #min_x ec.sys < #x ec.sys
scoreboard players operation #max_x ec.sys > #x ec.sys
scoreboard players operation #min_z ec.sys < #z ec.sys
scoreboard players operation #max_z ec.sys > #z ec.sys
scoreboard players operation #x ec.sys = #center_x ec.sys
scoreboard players operation #x ec.sys > #min_x ec.sys
scoreboard players operation #x ec.sys < #max_x ec.sys
scoreboard players operation #z ec.sys = #center_z ec.sys
scoreboard players operation #z ec.sys > #min_z ec.sys
scoreboard players operation #z ec.sys < #max_z ec.sys
function eclipse_cycle:space/ellipse
