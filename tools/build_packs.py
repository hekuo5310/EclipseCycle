#!/usr/bin/env python3
"""Generate the Java Edition packs. No ephemerides are generated."""
import json
from pathlib import Path
import shutil
import struct
import zlib

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "eclipse_system"
RES = ROOT / "eclipse_resources"
NS = "eclipse_cycle"
STATE = NS + ":state"
ARG = NS + ":args"
SYS = "ec.sys"
F = DATA / "data" / NS / "function"
TYPES = [
    ("total_solar", "日全食", "Total solar eclipse", "purple", "reverse_portal", "block.beacon.activate", 560, 96, 100),
    ("annular_solar", "日环食", "Annular solar eclipse", "yellow", "flame", "block.amethyst_block.chime", 520, 80, 82),
    ("partial_solar", "日偏食", "Partial solar eclipse", "white", "cloud", "block.note_block.chime", 700, 300, 42),
    ("hybrid_solar", "全环食", "Hybrid solar eclipse", "blue", "electric_spark", "block.conduit.activate", 520, 72, 92),
    ("total_lunar", "月全食", "Total lunar eclipse", "red", "crimson_spore", "block.respawn_anchor.charge", 0, 0, 100),
    ("partial_lunar", "月偏食", "Partial lunar eclipse", "purple", "witch", "block.note_block.harp", 0, 0, 59),
    ("penumbral_lunar", "半影月食", "Penumbral lunar eclipse", "white", "ash", "block.note_block.flute", 0, 0, 24),
]

def write(path, content):
    """Write a UTF-8 pack file with a trailing newline."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content + "\n", encoding="utf-8")

def obj(path, content):
    """Write pack metadata or another JSON resource."""
    write(path, json.dumps(content, ensure_ascii=False, indent=2))

def fn(path, *lines):
    """Write a function into the modern pack layout."""
    write(F / (path + ".mcfunction"), "\n".join(lines).strip())

def set_(key, value):
    """Build a command that assigns a system score."""
    return f"scoreboard players set #{key} {SYS} {value}"

def op(to, operator, source):
    """Build an operation between two system scores."""
    return f"scoreboard players operation #{to} {SYS} {operator} #{source} {SYS}"

def add(key, value):
    """Build an addition or subtraction for a system score."""
    action = "add" if value >= 0 else "remove"
    return f"scoreboard players {action} #{key} {SYS} {abs(value)}"

def match(key, interval):
    """Build an execute clause that matches a system score range."""
    return f"if score #{key} {SYS} matches {interval}"

def cmp(a, operator, b):
    """Build an execute clause that compares two system scores."""
    return f"if score #{a} {SYS} {operator} #{b} {SYS}"

def call(path):
    """Build a call to a function in the pack namespace."""
    return f"function {NS}:{path}"

def when(condition, cmd):
    """Run a command only when its execute clauses pass."""
    return f"execute {condition} run {cmd}"

def stop(condition):
    """End the current function when its execute clauses pass."""
    return when(condition, "return 0")

def save(storage, field, key):
    """Build a command that copies a system score into integer storage."""
    return f"execute store result storage {storage} {field} int 1 run scoreboard players get #{key} {SYS}"

def read(storage, field, key):
    """Build a command that loads an integer storage field into a system score."""
    return f"execute store result score #{key} {SYS} run data get storage {storage} {field}"

CONSTANTS = dict(zero=0, neg=-1, four=4, sixteen=16, scale=1000, turn=3600, half=1800,
                 synodic=29531, draconic=27212, anomalistic=27555, year=365242,
                 sin_denom=4050000, phase_window=14765, moon_ratio=273,
                 parallax_base=959, parallax_amplitude=61, sun_amplitude=4, sun_base=267,
                 topo_delta=18, million=1000000, lat_scale=680, tilt=234, b1=4955, b2=281, b3=278)
OBJECTIVES = {name: "dummy" for name in
              "sys view cx cz day inside zone tx ty tz px py pz pday ready portal target".split()}
OBJECTIVES.update(opt="trigger", spawn="trigger")

LEGACY_OVERLAY = "legacy_1_20"
for base, preferred, last in [(DATA, 48, [94, 1]), (RES, 34, [75, 0])]:
    metadata = {"pack": {
        "pack_format": preferred,
        "supported_formats": [18, last[0]],
        "min_format": 18,
        "max_format": last,
        "description": "日月蚀轮 / Eclipse Cycle",
    }}
    if base == DATA:
        metadata["overlays"] = {"entries": [{
            "directory": LEGACY_OVERLAY,
            "formats": [18, 41],
            "min_format": 18,
            "max_format": 41,
        }]}
    obj(base / "pack.mcmeta", metadata)
for tag in ("load", "tick"):
    obj(DATA / "data/minecraft/tags/function" / (tag + ".json"), {"values": [NS + ":" + tag]})

fn("load",
   when(f"unless data storage {STATE} schema", call("install")),
   "scoreboard players set @a ec.view 0", set_("loaded_day", -1),
   call("visual/hide"))
fn("install",
   *(f"scoreboard objectives add ec.{name} {kind}" for name, kind in OBJECTIVES.items()),
   *(set_(name, value) for name, value in CONSTANTS.items()),
   set_("spawn_x", 0), set_("spawn_z", 0), set_("pulse", 0),
   *(command for key, zh, en, color, particle, sound, a, b, level in TYPES for command in (
       f'bossbar add {NS}:{key} {{"translate":"{NS}.{key}","fallback":"{en}"}}',
       f"bossbar set {NS}:{key} color {color}", f"bossbar set {NS}:{key} value {level}")),
   f"data modify storage {STATE} schema set value 1")

fn("tick",
   "scoreboard players enable @a ec.opt",
   "tag @a[scores={ec.opt=1}] add ec.eligible",
   "execute as @a[tag=ec.eligible,scores={ec.opt=2..,ec.view=1..}] run title @s clear",
   "tag @a[scores={ec.opt=2..}] remove ec.eligible",
   "scoreboard players set @a[scores={ec.opt=1..}] ec.opt 0",
   "scoreboard players enable @a[tag=ec.eligible] ec.spawn",
   "scoreboard players set @a[tag=!ec.eligible] ec.view 0",
   when("unless entity @a[tag=ec.eligible]", call("visual/hide")),
   stop("unless entity @a[tag=ec.eligible]"),
   call("cache/ensure"),
   add("pulse", 1), when(match("pulse", "20.."), set_("pulse", 0)),
   when("as @a[tag=ec.eligible,scores={ec.spawn=1..}]", call("space/spawn")),
   when("as @a[tag=ec.eligible] at @s if dimension minecraft:overworld", call("visual/player")),
   when("as @a[tag=ec.eligible] at @s unless dimension minecraft:overworld", "scoreboard players set @s ec.view 0"),
   *(f"bossbar set {NS}:{row[0]} players @a[tag=ec.eligible,scores={{ec.view={code}}}]" for code, row in enumerate(TYPES, 1)))

FIELDS = ("kind", "start", "end", "center_x", "center_z", "axis_x", "axis_z", "peak", "syzygy", "beta")
fn("cache/ensure",
   f"execute in minecraft:overworld store result score #day {SYS} run time query day",
   f"execute in minecraft:overworld store result score #clock {SYS} run time query daytime",
   stop(cmp("day", "=", "loaded_day")),
   save(ARG, "day", "day"),
   f"function {NS}:cache/day with storage {ARG}")
fn("cache/day",
   f"$execute unless data storage {STATE} days.d$(day).ready run {call('astro/day')}",
   f"$execute unless data storage {STATE} days.d$(day).ready run function {NS}:cache/write with storage {ARG}",
   *("$" + read(STATE, "days.d$(day)." + field, field) for field in FIELDS),
   op("loaded_day", "=", "day"))
fn("cache/write",
   f"data modify storage {ARG} daily set value {{ready:1b}}",
   *(save(ARG, "daily." + field, field) for field in FIELDS),
   f"$data modify storage {STATE} days.d$(day) set from storage {ARG} daily")

fn("astro/day",
   "# Find the next mean new/full syzygy relative to the start of this game day.",
   *(set_(field, 0) for field in FIELDS),
   stop(match("day", "..-1")), stop(match("day", "2147483..")),
   op("t", "=", "day"), op("t", "*=", "scale"),
   op("age", "=", "t"), op("age", "%=", "synodic"),
   op("wait_new", "=", "zero"), op("wait_new", "-=", "age"), op("wait_new", "%=", "synodic"),
   op("wait_full", "=", "phase_window"), op("wait_full", "-=", "age"), op("wait_full", "%=", "synodic"),
   set_("phase", 0), op("wait", "=", "wait_new"),
   when(cmp("wait_full", "<", "wait_new"), set_("phase", 1)),
   when(match("phase", 1), op("wait", "=", "wait_full")),
   stop(match("wait", "1000..")),
   op("t", "+=", "wait"), op("syzygy", "=", "t"), call("astro/angles"),
   "# Fold F to the signed distance to the nearest node, in tenths of a degree.",
   op("node_delta", "=", "f"), op("node_delta", "%=", "half"),
   when(match("node_delta", "900.."), add("node_delta", -1800)),
   stop(match("node_delta", "..-241")), stop(match("node_delta", "241..")),
   call("astro/latitude"), call("astro/radii"),
   when(match("phase", 0), call("astro/solar")),
   when(match("phase", 1), call("astro/lunar")),
   stop(match("kind", 0)),
   op("peak", "=", "wait"), op("peak", "+=", "wait"),
   when(match("phase", 0), add("peak", 5000)),
   when(match("phase", 1), add("peak", 17000)),
   op("start", "=", "peak"), add("start", -500), op("end", "=", "peak"), add("end", 500),
   when(match("phase", 0), call("astro/center")))

def angle(name, period, offset):
    """Emit commands for a wrapped orbital angle in tenths of a degree."""
    return (op(name, "=", "t"), op(name, "%=", period), op(name, "*=", "turn"),
            op(name, "/=", period), add(name, offset), op(name, "%=", "turn"))

fn("astro/angles",
   *angle("f", "draconic", 932), *angle("m", "anomalistic", 1350),
   *angle("sun_long", "year", 2800), *angle("sun_m", "year", 3570))
fn("astro/latitude",
   "# At new/full, 2D = 0 mod 360, so the sin(F) terms combine.",
   op("angle", "=", "f"), call("math/sin"), op("sin", "*=", "b1"),
   op("sin", "/=", "scale"), op("beta", "=", "sin"),
   op("angle", "=", "m"), op("angle", "+=", "f"), call("math/sin"),
   op("sin", "*=", "b2"), op("sin", "/=", "scale"), op("beta", "+=", "sin"),
   op("angle", "=", "m"), op("angle", "-=", "f"), call("math/sin"),
   op("sin", "*=", "b3"), op("sin", "/=", "scale"), op("beta", "+=", "sin"),
   op("abs_beta", "=", "beta"), when(match("abs_beta", "..-1"), op("abs_beta", "*=", "neg")))
fn("math/sin",
   "# Bhaskara approximation. Input: tenths of degrees. Output: per mille.",
   op("angle", "%=", "turn"), op("sign", "=", "neg"),
   when(match("angle", "..1799"), set_("sign", 1)),
   when(match("angle", "1800.."), add("angle", -1800)),
   set_("product", 1800), op("product", "-=", "angle"), op("product", "*=", "angle"),
   op("denom", "=", "sin_denom"), op("denom", "-=", "product"), op("denom", "/=", "four"),
   op("sin", "=", "product"), op("sin", "*=", "scale"),
   op("sin", "/=", "denom"), op("sin", "*=", "sign"))
fn("astro/radii",
   op("angle", "=", "m"), add("angle", 900), call("math/sin"),
   op("sin", "*=", "parallax_amplitude"), op("sin", "/=", "scale"),
   op("parallax", "=", "parallax_base"), op("parallax", "+=", "sin"),
   op("moon_r", "=", "parallax"), op("moon_r", "*=", "moon_ratio"), op("moon_r", "/=", "scale"),
   op("angle", "=", "sun_m"), add("angle", 900), call("math/sin"),
   op("sin", "*=", "sun_amplitude"), op("sin", "/=", "scale"),
   op("sun_r", "=", "sun_base"), op("sun_r", "+=", "sin"))
fn("astro/solar",
   op("limit", "=", "parallax"), op("limit", "+=", "moon_r"), op("limit", "+=", "sun_r"),
   stop(cmp("abs_beta", ">=", "limit")),
   set_("kind", 3), stop(cmp("abs_beta", ">=", "parallax")),
   op("gamma", "=", "abs_beta"), op("gamma", "*=", "scale"), op("gamma", "/=", "parallax"),
   op("gamma", "*=", "gamma"), op("radicand", "=", "million"), op("radicand", "-=", "gamma"),
   call("math/sqrt"), op("root", "*=", "topo_delta"), op("root", "/=", "scale"),
   op("near_r", "=", "moon_r"), op("near_r", "+=", "root"),
   set_("kind", 4),
   when(cmp("near_r", "<=", "sun_r"), set_("kind", 2)),
   when(cmp("moon_r", ">=", "sun_r"), set_("kind", 1)))
fn("math/sqrt",
   "# Integer square root of #radicand in [0,1000000].",
   set_("root", 0),
   *(command for bit in (512, 256, 128, 64, 32, 16, 8, 4, 2, 1) for command in (
       op("trial", "=", "root"), add("trial", bit), op("square", "=", "trial"),
       op("square", "*=", "trial"), when(cmp("square", "<=", "radicand"), op("root", "=", "trial")))))
fn("astro/lunar",
   op("umbra", "=", "parallax"), op("umbra", "-=", "sun_r"), add("umbra", 12),
   op("limit", "=", "parallax"), op("limit", "+=", "sun_r"), op("limit", "+=", "moon_r"),
   stop(cmp("abs_beta", ">=", "limit")), set_("kind", 7),
   op("limit", "=", "umbra"), op("limit", "+=", "moon_r"),
   when(cmp("abs_beta", "<", "limit"), set_("kind", 6)),
   op("limit", "=", "abs_beta"), op("limit", "+=", "moon_r"),
   when(cmp("limit", "<=", "umbra"), set_("kind", 5)))
fn("astro/center",
   "# Nearest node longitude at conjunction, plus approximate declination and shadow offset.",
   op("angle", "=", "sun_long"), op("angle", "-=", "node_delta"), op("angle", "%=", "turn"),
   op("center_x", "=", "angle"), when(match("center_x", "1800.."), add("center_x", -3600)),
   call("math/sin"), op("sin", "*=", "tilt"), op("sin", "/=", "scale"),
   op("center_z", "=", "beta"), op("center_z", "*=", "lat_scale"), op("center_z", "/=", "parallax"),
   op("center_z", "+=", "sin"), op("center_z", "*=", "neg"),
   when(match("center_z", "..-801"), set_("center_z", -800)),
   when(match("center_z", "801.."), set_("center_z", 800)),
   *(command for code, row in enumerate(TYPES[:4], 1) for command in (
       when(match("kind", code), set_("axis_x", row[6])),
       when(match("kind", code), set_("axis_z", row[7])))))

def get_player(objective, key):
    """Copy an objective from the executing player to a system score."""
    return f"scoreboard players operation #{key} {SYS} = @s ec.{objective}"

def put_player(key, objective):
    """Copy a system score to an objective on the executing player."""
    return f"scoreboard players operation @s ec.{objective} = #{key} {SYS}"

fn("space/player_chunk",
   "# Pos -> floor(block) -> floor(chunk), including negative positions.",
   f"execute store result score #cx {SYS} run data get entity @s Pos[0] 1",
   f"execute store result score #cz {SYS} run data get entity @s Pos[2] 1",
   op("cx", "/=", "sixteen"), op("cz", "/=", "sixteen"),
   stop(f"if score @s ec.day = #day {SYS} if score @s ec.cx = #cx {SYS} if score @s ec.cz = #cz {SYS}"),
   save(ARG, "cx", "cx"), save(ARG, "cz", "cz"),
   f"function {NS}:space/chunk_lookup with storage {ARG}",
   put_player("cx", "cx"), put_player("cz", "cz"), put_player("day", "day"),
   put_player("inside", "inside"))
CHUNK_KEY = "days.d$(day).chunks.c$(cx)_$(cz)"
fn("space/chunk_lookup",
   f"$execute unless data storage {STATE} {CHUNK_KEY} run {call('space/chunk_compute')}",
   f"$execute unless data storage {STATE} {CHUNK_KEY} run execute store result storage {STATE} {CHUNK_KEY} int 1 run scoreboard players get #inside {SYS}",
   "$" + read(STATE, CHUNK_KEY, "inside"))
fn("space/chunk_compute",
   op("x", "=", "cx"), op("x", "*=", "sixteen"), add("x", 8),
   op("z", "=", "cz"), op("z", "*=", "sixteen"), add("z", 8),
   call("space/ellipse"))

fn("space/ellipse",
   "# AABB rejection, then conservative fixed-point ellipse membership.",
   set_("inside", 0),
   op("dx", "=", "x"), op("dx", "-=", "center_x"),
   op("dz", "=", "z"), op("dz", "-=", "center_z"),
   when(match("dx", "..-1"), op("dx", "*=", "neg")),
   when(match("dz", "..-1"), op("dz", "*=", "neg")),
   stop(cmp("dx", ">", "axis_x")), stop(cmp("dz", ">", "axis_z")),
   op("dx", "*=", "scale"), op("dx", "+=", "axis_x"), add("dx", -1), op("dx", "/=", "axis_x"),
   op("dz", "*=", "scale"), op("dz", "+=", "axis_z"), add("dz", -1), op("dz", "/=", "axis_z"),
   op("dx", "*=", "dx"), op("dz", "*=", "dz"), op("dx", "+=", "dz"),
   when(cmp("dx", "<=", "million"), set_("inside", 1)))

def range_probe(name, radius):
    """Emit a nine-point rectangle probe against the current solar belt."""
    # A linear, axis-aligned map preserves the extrema of all nine probes.
    # Reduce the 3x3 samples to bounds, then evaluate the nearest rectangle point.
    lines = [set_("inside", 0), stop(match("kind", "0")), stop(match("kind", "5..")),
             op("min_x", "=", "sample_x"), op("max_x", "=", "sample_x"),
             op("min_z", "=", "sample_z"), op("max_z", "=", "sample_z")]
    for x in (-radius, 0, radius):
        for z in (-radius, 0, radius):
            lines.extend((op("x", "=", "sample_x"), op("z", "=", "sample_z")))
            if x:
                lines.append(add("x", x))
            if z:
                lines.append(add("z", z))
            lines.extend((op("min_x", "<", "x"), op("max_x", ">", "x"),
                          op("min_z", "<", "z"), op("max_z", ">", "z")))
    lines.extend((op("x", "=", "center_x"), op("x", ">", "min_x"), op("x", "<", "max_x"),
                  op("z", "=", "center_z"), op("z", ">", "min_z"), op("z", "<", "max_z"),
                  call("space/ellipse")))
    fn(name, *lines)

range_probe("space/range30", 30)
range_probe("space/range5", 5)
fn("space/spawn",
   "scoreboard players set @s ec.spawn 0",
   op("sample_x", "=", "spawn_x"), op("sample_z", "=", "spawn_z"),
   call("space/respawn"),
   call("space/range30"), put_player("inside", "zone"),
   'tellraw @s [{"translate":"eclipse_cycle.spawn_result","fallback":"Spawn overlap (1 = yes): "},{"score":{"name":"@s","objective":"ec.zone"}}]')
fn("space/respawn",
   "# The Overworld dimension may be omitted by the 1.21.5–1.21.8 serializer.",
   when('if data entity @s respawn{dimension:"minecraft:overworld"}', call("space/respawn_modern")),
   when("if data entity @s respawn.pos[0] unless data entity @s respawn.dimension", call("space/respawn_modern")),
   stop("if data entity @s respawn"),
   stop("unless data entity @s SpawnX"), stop("unless data entity @s SpawnZ"),
   when('if data entity @s SpawnDimension unless data entity @s {SpawnDimension:"minecraft:overworld"}', "return 0"),
   f"execute store result score #sample_x {SYS} run data get entity @s SpawnX",
   f"execute store result score #sample_z {SYS} run data get entity @s SpawnZ")
fn("space/respawn_modern",
   f"execute if data entity @s respawn.pos[0] store result score #sample_x {SYS} run data get entity @s respawn.pos[0]",
   f"execute if data entity @s respawn.pos[2] store result score #sample_z {SYS} run data get entity @s respawn.pos[2]")

offsets = [(0, -1, 0), (0, 0, 0), (0, 1, 0)]
for dist in range(1, 6):
    offsets.extend([(dist, 0, 0), (-dist, 0, 0), (0, 0, dist), (0, 0, -dist)])

def relative(offset):
    """Encode an integer offset as a relative Minecraft coordinate."""
    return "~" + (str(offset) if offset else "")

fn("space/obsidian",
   "scoreboard players set @s ec.portal 0",
   *(f"execute if score @s ec.portal matches 0 if block {' '.join(map(relative, pos))} minecraft:obsidian run scoreboard players set @s ec.portal 1"
     for pos in offsets))

fn("teleport/prepare",
   "# Operator API. Run as the player. ec.tx/ty/tz are the requested Overworld block coordinates.",
   stop("unless entity @s[type=minecraft:player,tag=ec.eligible]"),
   "scoreboard players set @s ec.ready 0",
   "scoreboard players set @s ec.target 0",
   stop("unless score @s ec.tx matches -29999983..29999983"),
   stop("unless score @s ec.tz matches -29999983..29999983"),
   stop("unless score @s ec.ty matches -64..319"),
   stop("at @s unless dimension minecraft:the_nether"),
   when("at @s", call("space/obsidian")), stop("unless score @s ec.portal matches 1"),
   call("cache/ensure"),
   get_player("tx", "sample_x"), get_player("tz", "sample_z"),
   call("space/range5"), put_player("inside", "target"),
   *(f"scoreboard players operation @s ec.p{axis} = @s ec.t{axis}" for axis in "xyz"),
   put_player("day", "pday"), "scoreboard players set @s ec.ready 1")
fn("teleport/consume",
   "# One-use prepared target. Run as the same player in the Nether.",
   stop("unless entity @s[type=minecraft:player,tag=ec.eligible]"),
   stop("unless score @s ec.ready matches 1"),
   "scoreboard players set @s ec.ready 0",
   stop("at @s unless dimension minecraft:the_nether"),
   f"execute in minecraft:overworld store result score #commit_day {SYS} run time query day",
   stop(f"unless score @s ec.pday = #commit_day {SYS}"),
   *(f"execute store result storage {ARG} {axis} int 1 run scoreboard players get @s ec.p{axis}" for axis in "xyz"),
   set_("moved", 0),
   f"function {NS}:teleport/move with storage {ARG}",
   stop(match("moved", "0")),
   'title @s actionbar [{"translate":"eclipse_cycle.target_result","fallback":"Prepared target overlap (1 = yes): "},{"score":{"name":"@s","objective":"ec.target"}}]')
fn("teleport/move",
   f"$execute in minecraft:overworld positioned $(x) $(y) $(z) store success score #moved {SYS} run tp @s ~ ~ ~")

fn("visual/hide", *(f"bossbar set {NS}:{row[0]} players" for row in TYPES))
INACTIVE = f"unless predicate {NS}:active_window"
OUTSIDE_BELT = match("kind", "1..4") + " unless score @s ec.inside matches 1"
HIDE_VIEW = "scoreboard players set @s ec.view 0"
fn("visual/player",
   when(INACTIVE, HIDE_VIEW), stop(INACTIVE),
   when(match("kind", "1..4"), call("space/player_chunk")),
   when(OUTSIDE_BELT, HIDE_VIEW), stop(OUTSIDE_BELT),
   *(when(match("kind", code) + f" unless score @s ec.view matches {code}", call("visual/" + row[0]))
     for code, row in enumerate(TYPES, 1)),
   put_player("kind", "view"),
   *(when(match("pulse", "0") + " " + match("kind", code), call("visual/pulse_" + row[0]))
     for code, row in enumerate(TYPES, 1)))

def score_source(key):
    """Build a predicate number provider for a fixed system score."""
    return {"type": "minecraft:score", "target": {"type": "minecraft:fixed", "name": "#" + key},
            "score": SYS}

obj(DATA / "data" / NS / "predicate/active_window.json", {
    "condition": "minecraft:all_of", "terms": [
        {"condition": "minecraft:value_check", "value": score_source("kind"), "range": {"min": 1, "max": 7}},
        {"condition": "minecraft:value_check", "value": score_source("clock"),
         "range": {"min": score_source("start"), "max": score_source("end")}},
    ]})

def texture(path, code):
    """Draw a stage icon and encode it as a transparent RGBA PNG."""
    # Original raster art. Transparent background and seven eclipse silhouettes.
    size = 32
    colors = [(248, 199, 108), (255, 173, 57), (252, 216, 128), (245, 188, 103),
              (150, 41, 34), (191, 151, 141), (182, 176, 175)]
    rows = []
    for y in range(size):
        row = bytearray([0])
        for x in range(size):
            dx, dy = x - 15.5, y - 15.5
            r2 = dx * dx + dy * dy
            color = colors[code - 1]
            alpha = 0
            if code <= 4:
                offset, mask = [(0, 9.5), (0, 8), (7, 10), (1, 9)][code - 1]
                if r2 <= 150 and (dx - offset)**2 + dy*dy >= mask*mask:
                    alpha = 255 if r2 < 113 else (130 if code in (1, 4) else 45)
                elif r2 <= 93 and code in (1, 2, 4):
                    color, alpha = (26, 19, 33), 245
            elif r2 <= 118:
                shade = 0.52 if code == 6 and (dx - 5)**2 + (dy + 3)**2 < 106 else 1
                if (x * 13 + y * 7) % 23 < 4:
                    shade *= 0.84
                color, alpha = tuple(int(ch * shade) for ch in color), 255
            row.extend((*color, alpha))
        rows.append(bytes(row))

    def chunk(kind, content):
        """Encode a PNG chunk with its length and checksum."""
        return struct.pack(">I", len(content)) + kind + content + struct.pack(">I", zlib.crc32(kind + content))

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(b"\x89PNG\r\n\x1a\n" +
                     chunk(b"IHDR", struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0)) +
                     chunk(b"IDAT", zlib.compress(b"".join(rows))) + chunk(b"IEND", b""))

providers = []
zh_lang = {NS + ".spawn_result": "出生点范围与日食带重叠（1 = 是）："}
en_lang = {NS + ".spawn_result": "Spawn area intersects the solar belt (1 = yes): "}
zh_lang[NS + ".target_result"] = "传送前缓存的日食带重叠结果（1 = 是）："
en_lang[NS + ".target_result"] = "Prepared target overlap (1 = yes): "
for code, (key, zh, en, color, particle, sound, a, b, level) in enumerate(TYPES, 1):
    glyph = chr(0xe100 + code)
    text_color = "light_purple" if color == "purple" else color
    fn("visual/" + key,
       "title @s times 5 40 10",
       f'title @s subtitle {{"text":"{glyph}","font":"{NS}:stages"}}',
       f'title @s title {{"translate":"{NS}.{key}","fallback":"{en}","color":"{text_color}"}}',
       f"playsound minecraft:{sound} ambient @s ~ ~ ~ {0.35 + code * 0.05:.2f} 1")
    fx = ["effect give @s minecraft:darkness 2 0 true"] if code in (1, 4) else []
    fn("visual/pulse_" + key,
       f"particle minecraft:{particle} ~ ~1.8 ~ 0.7 0.5 0.7 0.02 {code + 3} normal @s", *fx)
    texture(RES / f"assets/{NS}/textures/font/{key}.png", code)
    providers.append({"type": "bitmap", "file": f"{NS}:font/{key}.png", "ascent": 14,
                      "height": 16, "chars": [glyph]})
    zh_lang[NS + "." + key] = zh
    en_lang[NS + "." + key] = en
obj(RES / f"assets/{NS}/font/stages.json", {"providers": providers})
obj(RES / f"assets/{NS}/lang/en_us.json", en_lang)
obj(RES / f"assets/{NS}/lang/zh_cn.json", zh_lang)


# Java 1.20.x discovers these registries under plural directory names.
# The loader selects this overlay by pack format; both layouts share one source.
for path in (Path(f"{NS}/function"), Path(f"{NS}/predicate"), Path("minecraft/tags/function")):
    legacy = path.with_name(path.name + "s")
    shutil.copytree(DATA / "data" / path, DATA / LEGACY_OVERLAY / "data" / legacy, dirs_exist_ok=True)
