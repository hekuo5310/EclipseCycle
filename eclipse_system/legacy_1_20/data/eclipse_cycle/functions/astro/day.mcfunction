# Find the next mean new/full syzygy relative to the start of this game day.
scoreboard players set #kind ec.sys 0
scoreboard players set #start ec.sys 0
scoreboard players set #end ec.sys 0
scoreboard players set #center_x ec.sys 0
scoreboard players set #center_z ec.sys 0
scoreboard players set #axis_x ec.sys 0
scoreboard players set #axis_z ec.sys 0
scoreboard players set #peak ec.sys 0
scoreboard players set #syzygy ec.sys 0
scoreboard players set #beta ec.sys 0
execute if score #day ec.sys matches ..-1 run return 0
execute if score #day ec.sys matches 2147483.. run return 0
scoreboard players operation #t ec.sys = #day ec.sys
scoreboard players operation #t ec.sys *= #scale ec.sys
scoreboard players operation #age ec.sys = #t ec.sys
scoreboard players operation #age ec.sys %= #synodic ec.sys
scoreboard players operation #wait_new ec.sys = #zero ec.sys
scoreboard players operation #wait_new ec.sys -= #age ec.sys
scoreboard players operation #wait_new ec.sys %= #synodic ec.sys
scoreboard players operation #wait_full ec.sys = #phase_window ec.sys
scoreboard players operation #wait_full ec.sys -= #age ec.sys
scoreboard players operation #wait_full ec.sys %= #synodic ec.sys
scoreboard players set #phase ec.sys 0
scoreboard players operation #wait ec.sys = #wait_new ec.sys
execute if score #wait_full ec.sys < #wait_new ec.sys run scoreboard players set #phase ec.sys 1
execute if score #phase ec.sys matches 1 run scoreboard players operation #wait ec.sys = #wait_full ec.sys
execute if score #wait ec.sys matches 1000.. run return 0
scoreboard players operation #t ec.sys += #wait ec.sys
scoreboard players operation #syzygy ec.sys = #t ec.sys
function eclipse_cycle:astro/angles
# Fold F to the signed distance to the nearest node, in tenths of a degree.
scoreboard players operation #node_delta ec.sys = #f ec.sys
scoreboard players operation #node_delta ec.sys %= #half ec.sys
execute if score #node_delta ec.sys matches 900.. run scoreboard players remove #node_delta ec.sys 1800
execute if score #node_delta ec.sys matches ..-241 run return 0
execute if score #node_delta ec.sys matches 241.. run return 0
function eclipse_cycle:astro/latitude
function eclipse_cycle:astro/radii
execute if score #phase ec.sys matches 0 run function eclipse_cycle:astro/solar
execute if score #phase ec.sys matches 1 run function eclipse_cycle:astro/lunar
execute if score #kind ec.sys matches 0 run return 0
scoreboard players operation #peak ec.sys = #wait ec.sys
scoreboard players operation #peak ec.sys += #wait ec.sys
execute if score #phase ec.sys matches 0 run scoreboard players add #peak ec.sys 5000
execute if score #phase ec.sys matches 1 run scoreboard players add #peak ec.sys 17000
scoreboard players operation #start ec.sys = #peak ec.sys
scoreboard players remove #start ec.sys 500
scoreboard players operation #end ec.sys = #peak ec.sys
scoreboard players add #end ec.sys 500
execute if score #phase ec.sys matches 0 run function eclipse_cycle:astro/center
