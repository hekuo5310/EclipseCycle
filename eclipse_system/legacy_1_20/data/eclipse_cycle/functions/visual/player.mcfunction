execute unless predicate eclipse_cycle:active_window run scoreboard players set @s ec.view 0
execute unless predicate eclipse_cycle:active_window run return 0
execute if score #kind ec.sys matches 1..4 run function eclipse_cycle:space/player_chunk
execute if score #kind ec.sys matches 1..4 unless score @s ec.inside matches 1 run scoreboard players set @s ec.view 0
execute if score #kind ec.sys matches 1..4 unless score @s ec.inside matches 1 run return 0
execute if score #kind ec.sys matches 1 unless score @s ec.view matches 1 run function eclipse_cycle:visual/total_solar
execute if score #kind ec.sys matches 2 unless score @s ec.view matches 2 run function eclipse_cycle:visual/annular_solar
execute if score #kind ec.sys matches 3 unless score @s ec.view matches 3 run function eclipse_cycle:visual/partial_solar
execute if score #kind ec.sys matches 4 unless score @s ec.view matches 4 run function eclipse_cycle:visual/hybrid_solar
execute if score #kind ec.sys matches 5 unless score @s ec.view matches 5 run function eclipse_cycle:visual/total_lunar
execute if score #kind ec.sys matches 6 unless score @s ec.view matches 6 run function eclipse_cycle:visual/partial_lunar
execute if score #kind ec.sys matches 7 unless score @s ec.view matches 7 run function eclipse_cycle:visual/penumbral_lunar
scoreboard players operation @s ec.view = #kind ec.sys
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 1 run function eclipse_cycle:visual/pulse_total_solar
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 2 run function eclipse_cycle:visual/pulse_annular_solar
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 3 run function eclipse_cycle:visual/pulse_partial_solar
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 4 run function eclipse_cycle:visual/pulse_hybrid_solar
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 5 run function eclipse_cycle:visual/pulse_total_lunar
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 6 run function eclipse_cycle:visual/pulse_partial_lunar
execute if score #pulse ec.sys matches 0 if score #kind ec.sys matches 7 run function eclipse_cycle:visual/pulse_penumbral_lunar
