# One-use prepared target. Run as the same player in the Nether.
execute unless entity @s[type=minecraft:player,tag=ec.eligible] run return 0
execute unless score @s ec.ready matches 1 run return 0
scoreboard players set @s ec.ready 0
execute at @s unless dimension minecraft:the_nether run return 0
execute in minecraft:overworld store result score #commit_day ec.sys run time query day
execute unless score @s ec.pday = #commit_day ec.sys run return 0
execute store result storage eclipse_cycle:args x int 1 run scoreboard players get @s ec.px
execute store result storage eclipse_cycle:args y int 1 run scoreboard players get @s ec.py
execute store result storage eclipse_cycle:args z int 1 run scoreboard players get @s ec.pz
execute store success score #moved ec.sys run function eclipse_cycle:teleport/move with storage eclipse_cycle:args
execute if score #moved ec.sys matches 0 run return 0
title @s actionbar [{"translate":"eclipse_cycle.target_result","fallback":"Prepared target overlap (1 = yes): "},{"score":{"name":"@s","objective":"ec.target"}}]
