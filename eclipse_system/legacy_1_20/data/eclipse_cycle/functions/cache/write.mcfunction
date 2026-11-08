data modify storage eclipse_cycle:args daily set value {ready:1b}
execute store result storage eclipse_cycle:args daily.kind int 1 run scoreboard players get #kind ec.sys
execute store result storage eclipse_cycle:args daily.start int 1 run scoreboard players get #start ec.sys
execute store result storage eclipse_cycle:args daily.end int 1 run scoreboard players get #end ec.sys
execute store result storage eclipse_cycle:args daily.center_x int 1 run scoreboard players get #center_x ec.sys
execute store result storage eclipse_cycle:args daily.center_z int 1 run scoreboard players get #center_z ec.sys
execute store result storage eclipse_cycle:args daily.axis_x int 1 run scoreboard players get #axis_x ec.sys
execute store result storage eclipse_cycle:args daily.axis_z int 1 run scoreboard players get #axis_z ec.sys
execute store result storage eclipse_cycle:args daily.peak int 1 run scoreboard players get #peak ec.sys
execute store result storage eclipse_cycle:args daily.syzygy int 1 run scoreboard players get #syzygy ec.sys
execute store result storage eclipse_cycle:args daily.beta int 1 run scoreboard players get #beta ec.sys
$data modify storage eclipse_cycle:state days.d$(day) set from storage eclipse_cycle:args daily
