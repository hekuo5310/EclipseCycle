# Bhaskara approximation. Input: tenths of degrees. Output: per mille.
scoreboard players operation #angle ec.sys %= #turn ec.sys
scoreboard players operation #sign ec.sys = #neg ec.sys
execute if score #angle ec.sys matches ..1799 run scoreboard players set #sign ec.sys 1
execute if score #angle ec.sys matches 1800.. run scoreboard players remove #angle ec.sys 1800
scoreboard players set #product ec.sys 1800
scoreboard players operation #product ec.sys -= #angle ec.sys
scoreboard players operation #product ec.sys *= #angle ec.sys
scoreboard players operation #denom ec.sys = #sin_denom ec.sys
scoreboard players operation #denom ec.sys -= #product ec.sys
scoreboard players operation #denom ec.sys /= #four ec.sys
scoreboard players operation #sin ec.sys = #product ec.sys
scoreboard players operation #sin ec.sys *= #scale ec.sys
scoreboard players operation #sin ec.sys /= #denom ec.sys
scoreboard players operation #sin ec.sys *= #sign ec.sys
