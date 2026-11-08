$execute unless data storage eclipse_cycle:state days.d$(day).chunks.c$(cx)_$(cz) run function eclipse_cycle:space/chunk_compute
$execute unless data storage eclipse_cycle:state days.d$(day).chunks.c$(cx)_$(cz) run execute store result storage eclipse_cycle:state days.d$(day).chunks.c$(cx)_$(cz) int 1 run scoreboard players get #inside ec.sys
$execute store result score #inside ec.sys run data get storage eclipse_cycle:state days.d$(day).chunks.c$(cx)_$(cz)
