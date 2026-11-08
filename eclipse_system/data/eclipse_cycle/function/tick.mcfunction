scoreboard players enable @a ec.opt
tag @a[scores={ec.opt=1}] add ec.eligible
execute as @a[tag=ec.eligible,scores={ec.opt=2..,ec.view=1..}] run title @s clear
tag @a[scores={ec.opt=2..}] remove ec.eligible
scoreboard players set @a[scores={ec.opt=1..}] ec.opt 0
scoreboard players enable @a[tag=ec.eligible] ec.spawn
scoreboard players set @a[tag=!ec.eligible] ec.view 0
execute unless entity @a[tag=ec.eligible] run function eclipse_cycle:visual/hide
execute unless entity @a[tag=ec.eligible] run return 0
function eclipse_cycle:cache/ensure
scoreboard players add #pulse ec.sys 1
execute if score #pulse ec.sys matches 20.. run scoreboard players set #pulse ec.sys 0
execute as @a[tag=ec.eligible,scores={ec.spawn=1..}] run function eclipse_cycle:space/spawn
execute as @a[tag=ec.eligible] at @s if dimension minecraft:overworld run function eclipse_cycle:visual/player
execute as @a[tag=ec.eligible] at @s unless dimension minecraft:overworld run scoreboard players set @s ec.view 0
bossbar set eclipse_cycle:total_solar players @a[tag=ec.eligible,scores={ec.view=1}]
bossbar set eclipse_cycle:annular_solar players @a[tag=ec.eligible,scores={ec.view=2}]
bossbar set eclipse_cycle:partial_solar players @a[tag=ec.eligible,scores={ec.view=3}]
bossbar set eclipse_cycle:hybrid_solar players @a[tag=ec.eligible,scores={ec.view=4}]
bossbar set eclipse_cycle:total_lunar players @a[tag=ec.eligible,scores={ec.view=5}]
bossbar set eclipse_cycle:partial_lunar players @a[tag=ec.eligible,scores={ec.view=6}]
bossbar set eclipse_cycle:penumbral_lunar players @a[tag=ec.eligible,scores={ec.view=7}]
