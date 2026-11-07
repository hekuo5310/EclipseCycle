# Nearest node longitude at conjunction, plus approximate declination and shadow offset.
scoreboard players operation #angle ec.sys = #sun_long ec.sys
scoreboard players operation #angle ec.sys -= #node_delta ec.sys
scoreboard players operation #angle ec.sys %= #turn ec.sys
scoreboard players operation #center_x ec.sys = #angle ec.sys
execute if score #center_x ec.sys matches 1800.. run scoreboard players remove #center_x ec.sys 3600
function eclipse_cycle:math/sin
scoreboard players operation #sin ec.sys *= #tilt ec.sys
scoreboard players operation #sin ec.sys /= #scale ec.sys
scoreboard players operation #center_z ec.sys = #beta ec.sys
scoreboard players operation #center_z ec.sys *= #lat_scale ec.sys
scoreboard players operation #center_z ec.sys /= #parallax ec.sys
scoreboard players operation #center_z ec.sys += #sin ec.sys
scoreboard players operation #center_z ec.sys *= #neg ec.sys
execute if score #center_z ec.sys matches ..-801 run scoreboard players set #center_z ec.sys -800
execute if score #center_z ec.sys matches 801.. run scoreboard players set #center_z ec.sys 800
execute if score #kind ec.sys matches 1 run scoreboard players set #axis_x ec.sys 560
execute if score #kind ec.sys matches 1 run scoreboard players set #axis_z ec.sys 96
execute if score #kind ec.sys matches 2 run scoreboard players set #axis_x ec.sys 520
execute if score #kind ec.sys matches 2 run scoreboard players set #axis_z ec.sys 80
execute if score #kind ec.sys matches 3 run scoreboard players set #axis_x ec.sys 700
execute if score #kind ec.sys matches 3 run scoreboard players set #axis_z ec.sys 300
execute if score #kind ec.sys matches 4 run scoreboard players set #axis_x ec.sys 520
execute if score #kind ec.sys matches 4 run scoreboard players set #axis_z ec.sys 72
