scoreboard objectives add ec.sys dummy
scoreboard objectives add ec.view dummy
scoreboard objectives add ec.cx dummy
scoreboard objectives add ec.cz dummy
scoreboard objectives add ec.day dummy
scoreboard objectives add ec.inside dummy
scoreboard objectives add ec.zone dummy
scoreboard objectives add ec.tx dummy
scoreboard objectives add ec.ty dummy
scoreboard objectives add ec.tz dummy
scoreboard objectives add ec.px dummy
scoreboard objectives add ec.py dummy
scoreboard objectives add ec.pz dummy
scoreboard objectives add ec.pday dummy
scoreboard objectives add ec.ready dummy
scoreboard objectives add ec.portal dummy
scoreboard objectives add ec.target dummy
scoreboard objectives add ec.opt trigger
scoreboard objectives add ec.spawn trigger
scoreboard players set #zero ec.sys 0
scoreboard players set #neg ec.sys -1
scoreboard players set #four ec.sys 4
scoreboard players set #sixteen ec.sys 16
scoreboard players set #scale ec.sys 1000
scoreboard players set #turn ec.sys 3600
scoreboard players set #half ec.sys 1800
scoreboard players set #synodic ec.sys 29531
scoreboard players set #draconic ec.sys 27212
scoreboard players set #anomalistic ec.sys 27555
scoreboard players set #year ec.sys 365242
scoreboard players set #sin_denom ec.sys 4050000
scoreboard players set #phase_window ec.sys 14765
scoreboard players set #moon_ratio ec.sys 273
scoreboard players set #parallax_base ec.sys 959
scoreboard players set #parallax_amplitude ec.sys 61
scoreboard players set #sun_amplitude ec.sys 4
scoreboard players set #sun_base ec.sys 267
scoreboard players set #topo_delta ec.sys 18
scoreboard players set #million ec.sys 1000000
scoreboard players set #lat_scale ec.sys 680
scoreboard players set #tilt ec.sys 234
scoreboard players set #b1 ec.sys 4955
scoreboard players set #b2 ec.sys 281
scoreboard players set #b3 ec.sys 278
scoreboard players set #spawn_x ec.sys 0
scoreboard players set #spawn_z ec.sys 0
scoreboard players set #pulse ec.sys 0
bossbar add eclipse_cycle:total_solar {"translate":"eclipse_cycle.total_solar","fallback":"Total solar eclipse"}
bossbar set eclipse_cycle:total_solar color purple
bossbar set eclipse_cycle:total_solar value 100
bossbar add eclipse_cycle:annular_solar {"translate":"eclipse_cycle.annular_solar","fallback":"Annular solar eclipse"}
bossbar set eclipse_cycle:annular_solar color yellow
bossbar set eclipse_cycle:annular_solar value 82
bossbar add eclipse_cycle:partial_solar {"translate":"eclipse_cycle.partial_solar","fallback":"Partial solar eclipse"}
bossbar set eclipse_cycle:partial_solar color white
bossbar set eclipse_cycle:partial_solar value 42
bossbar add eclipse_cycle:hybrid_solar {"translate":"eclipse_cycle.hybrid_solar","fallback":"Hybrid solar eclipse"}
bossbar set eclipse_cycle:hybrid_solar color blue
bossbar set eclipse_cycle:hybrid_solar value 92
bossbar add eclipse_cycle:total_lunar {"translate":"eclipse_cycle.total_lunar","fallback":"Total lunar eclipse"}
bossbar set eclipse_cycle:total_lunar color red
bossbar set eclipse_cycle:total_lunar value 100
bossbar add eclipse_cycle:partial_lunar {"translate":"eclipse_cycle.partial_lunar","fallback":"Partial lunar eclipse"}
bossbar set eclipse_cycle:partial_lunar color purple
bossbar set eclipse_cycle:partial_lunar value 59
bossbar add eclipse_cycle:penumbral_lunar {"translate":"eclipse_cycle.penumbral_lunar","fallback":"Penumbral lunar eclipse"}
bossbar set eclipse_cycle:penumbral_lunar color white
bossbar set eclipse_cycle:penumbral_lunar value 24
data modify storage eclipse_cycle:state schema set value 1
