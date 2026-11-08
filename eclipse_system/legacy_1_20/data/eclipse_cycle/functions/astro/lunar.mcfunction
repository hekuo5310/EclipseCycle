scoreboard players operation #umbra ec.sys = #parallax ec.sys
scoreboard players operation #umbra ec.sys -= #sun_r ec.sys
scoreboard players add #umbra ec.sys 12
scoreboard players operation #limit ec.sys = #parallax ec.sys
scoreboard players operation #limit ec.sys += #sun_r ec.sys
scoreboard players operation #limit ec.sys += #moon_r ec.sys
execute if score #abs_beta ec.sys >= #limit ec.sys run return 0
scoreboard players set #kind ec.sys 7
scoreboard players operation #limit ec.sys = #umbra ec.sys
scoreboard players operation #limit ec.sys += #moon_r ec.sys
execute if score #abs_beta ec.sys < #limit ec.sys run scoreboard players set #kind ec.sys 6
scoreboard players operation #limit ec.sys = #abs_beta ec.sys
scoreboard players operation #limit ec.sys += #moon_r ec.sys
execute if score #limit ec.sys <= #umbra ec.sys run scoreboard players set #kind ec.sys 5
