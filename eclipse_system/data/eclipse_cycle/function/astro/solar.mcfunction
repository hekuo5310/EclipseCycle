scoreboard players operation #limit ec.sys = #parallax ec.sys
scoreboard players operation #limit ec.sys += #moon_r ec.sys
scoreboard players operation #limit ec.sys += #sun_r ec.sys
execute if score #abs_beta ec.sys >= #limit ec.sys run return 0
scoreboard players set #kind ec.sys 3
execute if score #abs_beta ec.sys >= #parallax ec.sys run return 0
scoreboard players operation #gamma ec.sys = #abs_beta ec.sys
scoreboard players operation #gamma ec.sys *= #scale ec.sys
scoreboard players operation #gamma ec.sys /= #parallax ec.sys
scoreboard players operation #gamma ec.sys *= #gamma ec.sys
scoreboard players operation #radicand ec.sys = #million ec.sys
scoreboard players operation #radicand ec.sys -= #gamma ec.sys
function eclipse_cycle:math/sqrt
scoreboard players operation #root ec.sys *= #topo_delta ec.sys
scoreboard players operation #root ec.sys /= #scale ec.sys
scoreboard players operation #near_r ec.sys = #moon_r ec.sys
scoreboard players operation #near_r ec.sys += #root ec.sys
scoreboard players set #kind ec.sys 4
execute if score #near_r ec.sys <= #sun_r ec.sys run scoreboard players set #kind ec.sys 2
execute if score #moon_r ec.sys >= #sun_r ec.sys run scoreboard players set #kind ec.sys 1
