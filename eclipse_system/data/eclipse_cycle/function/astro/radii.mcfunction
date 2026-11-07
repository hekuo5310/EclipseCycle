scoreboard players operation #angle ec.sys = #m ec.sys
scoreboard players add #angle ec.sys 900
function eclipse_cycle:math/sin
scoreboard players operation #sin ec.sys *= #parallax_amplitude ec.sys
scoreboard players operation #sin ec.sys /= #scale ec.sys
scoreboard players operation #parallax ec.sys = #parallax_base ec.sys
scoreboard players operation #parallax ec.sys += #sin ec.sys
scoreboard players operation #moon_r ec.sys = #parallax ec.sys
scoreboard players operation #moon_r ec.sys *= #moon_ratio ec.sys
scoreboard players operation #moon_r ec.sys /= #scale ec.sys
scoreboard players operation #angle ec.sys = #sun_m ec.sys
scoreboard players add #angle ec.sys 900
function eclipse_cycle:math/sin
scoreboard players operation #sin ec.sys *= #sun_amplitude ec.sys
scoreboard players operation #sin ec.sys /= #scale ec.sys
scoreboard players operation #sun_r ec.sys = #sun_base ec.sys
scoreboard players operation #sun_r ec.sys += #sin ec.sys
