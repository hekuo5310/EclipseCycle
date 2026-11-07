# AABB rejection, then conservative fixed-point ellipse membership.
scoreboard players set #inside ec.sys 0
scoreboard players operation #dx ec.sys = #x ec.sys
scoreboard players operation #dx ec.sys -= #center_x ec.sys
scoreboard players operation #dz ec.sys = #z ec.sys
scoreboard players operation #dz ec.sys -= #center_z ec.sys
execute if score #dx ec.sys matches ..-1 run scoreboard players operation #dx ec.sys *= #neg ec.sys
execute if score #dz ec.sys matches ..-1 run scoreboard players operation #dz ec.sys *= #neg ec.sys
execute if score #dx ec.sys > #axis_x ec.sys run return 0
execute if score #dz ec.sys > #axis_z ec.sys run return 0
scoreboard players operation #dx ec.sys *= #scale ec.sys
scoreboard players operation #dx ec.sys += #axis_x ec.sys
scoreboard players remove #dx ec.sys 1
scoreboard players operation #dx ec.sys /= #axis_x ec.sys
scoreboard players operation #dz ec.sys *= #scale ec.sys
scoreboard players operation #dz ec.sys += #axis_z ec.sys
scoreboard players remove #dz ec.sys 1
scoreboard players operation #dz ec.sys /= #axis_z ec.sys
scoreboard players operation #dx ec.sys *= #dx ec.sys
scoreboard players operation #dz ec.sys *= #dz ec.sys
scoreboard players operation #dx ec.sys += #dz ec.sys
execute if score #dx ec.sys <= #million ec.sys run scoreboard players set #inside ec.sys 1
