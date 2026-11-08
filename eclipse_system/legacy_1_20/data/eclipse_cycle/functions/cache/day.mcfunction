$execute unless data storage eclipse_cycle:state days.d$(day).ready run function eclipse_cycle:astro/day
$execute unless data storage eclipse_cycle:state days.d$(day).ready run function eclipse_cycle:cache/write with storage eclipse_cycle:args
$execute store result score #kind ec.sys run data get storage eclipse_cycle:state days.d$(day).kind
$execute store result score #start ec.sys run data get storage eclipse_cycle:state days.d$(day).start
$execute store result score #end ec.sys run data get storage eclipse_cycle:state days.d$(day).end
$execute store result score #center_x ec.sys run data get storage eclipse_cycle:state days.d$(day).center_x
$execute store result score #center_z ec.sys run data get storage eclipse_cycle:state days.d$(day).center_z
$execute store result score #axis_x ec.sys run data get storage eclipse_cycle:state days.d$(day).axis_x
$execute store result score #axis_z ec.sys run data get storage eclipse_cycle:state days.d$(day).axis_z
$execute store result score #peak ec.sys run data get storage eclipse_cycle:state days.d$(day).peak
$execute store result score #syzygy ec.sys run data get storage eclipse_cycle:state days.d$(day).syzygy
$execute store result score #beta ec.sys run data get storage eclipse_cycle:state days.d$(day).beta
scoreboard players operation #loaded_day ec.sys = #day ec.sys
