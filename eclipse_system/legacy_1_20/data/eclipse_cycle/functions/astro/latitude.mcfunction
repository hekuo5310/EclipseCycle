# At new/full, 2D = 0 mod 360, so the sin(F) terms combine.
scoreboard players operation #angle ec.sys = #f ec.sys
function eclipse_cycle:math/sin
scoreboard players operation #sin ec.sys *= #b1 ec.sys
scoreboard players operation #sin ec.sys /= #scale ec.sys
scoreboard players operation #beta ec.sys = #sin ec.sys
scoreboard players operation #angle ec.sys = #m ec.sys
scoreboard players operation #angle ec.sys += #f ec.sys
function eclipse_cycle:math/sin
scoreboard players operation #sin ec.sys *= #b2 ec.sys
scoreboard players operation #sin ec.sys /= #scale ec.sys
scoreboard players operation #beta ec.sys += #sin ec.sys
scoreboard players operation #angle ec.sys = #m ec.sys
scoreboard players operation #angle ec.sys -= #f ec.sys
function eclipse_cycle:math/sin
scoreboard players operation #sin ec.sys *= #b3 ec.sys
scoreboard players operation #sin ec.sys /= #scale ec.sys
scoreboard players operation #beta ec.sys += #sin ec.sys
scoreboard players operation #abs_beta ec.sys = #beta ec.sys
execute if score #abs_beta ec.sys matches ..-1 run scoreboard players operation #abs_beta ec.sys *= #neg ec.sys
