# Integer square root of #radicand in [0,1000000].
scoreboard players set #root ec.sys 0
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 512
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 256
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 128
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 64
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 32
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 16
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 8
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 4
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 2
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
scoreboard players operation #trial ec.sys = #root ec.sys
scoreboard players add #trial ec.sys 1
scoreboard players operation #square ec.sys = #trial ec.sys
scoreboard players operation #square ec.sys *= #trial ec.sys
execute if score #square ec.sys <= #radicand ec.sys run scoreboard players operation #root ec.sys = #trial ec.sys
