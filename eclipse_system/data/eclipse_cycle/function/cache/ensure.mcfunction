execute in minecraft:overworld store result score #day ec.sys run time query day
execute in minecraft:overworld store result score #clock ec.sys run time query daytime
execute if score #day ec.sys = #loaded_day ec.sys run return 0
execute store result storage eclipse_cycle:args day int 1 run scoreboard players get #day ec.sys
function eclipse_cycle:cache/day with storage eclipse_cycle:args
