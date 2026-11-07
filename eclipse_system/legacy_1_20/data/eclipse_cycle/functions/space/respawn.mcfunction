# The Overworld dimension may be omitted by the 1.21.5–1.21.8 serializer.
execute if data entity @s respawn{dimension:"minecraft:overworld"} run function eclipse_cycle:space/respawn_modern
execute if data entity @s respawn.pos[0] unless data entity @s respawn.dimension run function eclipse_cycle:space/respawn_modern
execute if data entity @s respawn run return 0
execute unless data entity @s SpawnX run return 0
execute unless data entity @s SpawnZ run return 0
execute if data entity @s SpawnDimension unless data entity @s {SpawnDimension:"minecraft:overworld"} run return 0
execute store result score #sample_x ec.sys run data get entity @s SpawnX
execute store result score #sample_z ec.sys run data get entity @s SpawnZ
