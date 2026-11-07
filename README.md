# 日月蚀轮 / Eclipse Cycle

一个以 Minecraft 世界日为时钟的日月食模拟。首选版本为 **Java 1.21.1**，命名空间为 `eclipse_cycle`。同一套数据包和资源包覆盖正式版 **1.21–1.21.11**。

| Java 版 | 数据包格式 | 资源包格式 |
| --- | ---: | ---: |
| **1.21–1.21.1** | **48** | **34** |
| 1.21.2–1.21.3 | 57 | 42 |
| 1.21.4 | 61 | 46 |
| 1.21.5 | 71 | 55 |
| 1.21.6 | 80 | 63 |
| 1.21.7–1.21.8 | 81 | 64 |
| 1.21.9–1.21.10 | 88.0 | 69.0 |
| 1.21.11 | 94.1 | 75.0 |

两个包都用 1.21.1 的 `pack_format`，同时声明旧式 `supported_formats` 和新式 `min_format/max_format`。文本命令使用两个解析器都接受的带引号 JSON 写法。复活点读取兼容 1.21.1 的 `SpawnX/SpawnZ` 与 1.21.5 起的 `respawn.pos`，并区分下界重生锚。

## 安装

1. 将 `eclipse_system/` 放入存档的 `datapacks/`，保留该目录里的 `pack.mcmeta`。执行 `/reload`，用 `/datapack list` 确认已启用。
2. 单机把 `eclipse_resources/` 放入 `resourcepacks/` 并启用。独立服务器将其目录**内部**打包成 ZIP，上传到玩家能直接下载的 HTTPS 地址。
3. 进游戏执行 `/trigger ec.opt set 1` 开启体验，`/trigger ec.opt set 2` 关闭。资格保存在玩家标签 `ec.eligible`。数据包单独启用时，事件文字、音效、粒子、bossbar 和黑暗效果仍可用。
4. 如需检测重生区域，先将世界出生点的 X/Z 同步到下列分数，然后玩家执行 `/trigger ec.spawn`。有主世界床点时优先使用该点。默认的世界出生点配置是 (0, 0)。

```mcfunction
scoreboard players set #spawn_x ec.sys 120
scoreboard players set #spawn_z ec.sys -80
```

资源包从仓库根目录打包后，计算实际 ZIP 的 SHA-1，修改服务器配置并重启。

```sh
(cd eclipse_resources && zip -r ../eclipse_resources.zip pack.mcmeta assets)
sha1sum eclipse_resources.zip
```

```properties
resource-pack=https://example.org/downloads/eclipse_resources.zip
resource-pack-sha1=填写上一步所得的40位十六进制SHA-1
require-resource-pack=true
resource-pack-prompt={"text":"日月蚀轮 / Eclipse Cycle"}
```

原版服务器负责强制资源包并断开拒绝者。这些版本的纯命令无法可靠读取客户端资源包加载状态。玩家资格是显式同意标记，在单机和允许可选资源包的服务器上同样适用。缺少资格的玩家跳过表现与空间判定。无人具备资格时，tick 也会跳过全局天文计算。客户端资源包装载失败的情形不能通过自定义物品、`custom_model_data` 或记分板反向识别。

## 文件结构

```text
eclipse_system/
  pack.mcmeta
  data/
    minecraft/tags/function/{load,tick}.json
    eclipse_cycle/
      function/
        {load,install,tick}.mcfunction
        astro/{day,angles,latitude,radii,solar,lunar,center}.mcfunction
        math/{sin,sqrt}.mcfunction
        cache/{ensure,day,write}.mcfunction
        space/{player_chunk,chunk_lookup,chunk_compute,ellipse,range30,range5,spawn,respawn,respawn_modern,obsidian}.mcfunction
        teleport/{prepare,consume,move}.mcfunction
        visual/{hide,player,<7种食相>,pulse_<7种食相>}.mcfunction
      predicate/active_window.json
eclipse_resources/
  pack.mcmeta
  assets/eclipse_cycle/
    font/stages.json
    lang/{en_us,zh_cn}.json
    textures/font/<7种食相>.png
tools/build_packs.py
```

两个包的展开文件已经随仓库提供。修改重复命令、资源或常数后，用 `python3 tools/build_packs.py` 重新生成。游戏运行只依赖两个包。原创整数数学函数放在 `eclipse_cycle:math/*`，工程没有第三方数学命名空间。

## 天文模型

本模型用独立的游戏历元，相位常数是玩法参数。它不会给出现实日期、UTC、真实食带、当地接触时刻或观测建议。地图定位只在原点附近的坐标范围内有意义。运行时只使用世界日、世界昼夜时刻和下列固定常数。

### 朔望、交点与黄纬

一天用 1000 个计算单位表示。从 `t₀ = 1000 × 世界日` 开始，用非负取模计算到下一个朔和望的等待量，取较小值。

```text
w_new  = (−t₀) mod 29531
w_full = (14765 − t₀) mod 29531
若 min(w_new, w_full) ≥ 1000，则本日无朔望候选。
t = t₀ + min(w_new, w_full)
F = 93.2° + 360° × ((t mod 27212) / 27212)
M = 135.0° + 360° × ((t mod 27555) / 27555)
L = 280.0° + 360° × ((t mod 365242) / 365242)
A = 357.0° + 360° × ((t mod 365242) / 365242)
```

朔望月、交点月和近点月分别约为 29.531、27.212、27.555 日。F 为月球相对升交点的平均角度，M 为月球平近点角，L 和 A 是近似太阳黄经与平近点角。先将 F 折叠到距任一交点的 ±90° 区间，绝对值大于 24° 时剔除候选。

低精度黄纬采用四个主要项，D 为日月平均伸距。

```text
β ≈ 5.128° sin F + 0.281° sin(M+F) + 0.278° sin(M−F) + 0.173° sin(2D−F)
```

在平均朔或望取 `2D ≡ 0°`，第一项和第四项合成 `4.955° sin F`。函数将角度量化至 0.1°、黄纬量化至 0.001°。半周内用 Bhāskara 正弦有理近似 `4x(180−x)/(40500−x(180−x))`，另一半周翻转符号。所有分母为整数且非零，游戏日超过安全的整数范围时记录为无事件。

视半径与月球水平视差用下式估算，数值单位为毫度。

```text
p  = 959 + 61 cos M
rm = 0.273 p
rs = 267 + 4 cos A
b  = |β|
u  = p − rs + 12        地球本影半径，12 为近似大气修正
v  = p + rs             地球半影半径
rn = rm + 18 √(1−(b/p)²)  中心日食近端估计，仅在 b < p 时计算
```

### 类型与时间

| 类型 ID | 事件 | 判定条件 |
| --- | --- | --- |
| 1 | 日全食 | 朔，`b < p` 且 `rm ≥ rs` |
| 2 | 日环食 | 朔，`b < p` 且 `rn ≤ rs`、`rm < rs` |
| 3 | 日偏食 | 朔，`p ≤ b < p+rm+rs` |
| 4 | 全环食 | 朔，`b < p` 且 `rm < rs < rn` |
| 5 | 月全食 | 望，`b+rm ≤ u` |
| 6 | 月偏食 | 望，`b+rm > u` 且 `b < u+rm` |
| 7 | 半影月食 | 望，`u+rm ≤ b < v+rm` |

日食峰值映射到主世界昼间 tick `5000 + 2w`，月食映射到夜间 tick `17000 + 2w`。有效窗口是峰值前后 500 tick。白天和夜间映射解决了平均朔望模型的连续时刻与 Minecraft 昼夜表现的对齐问题。阈值附近会受截断、缺少摄动项及近端几何简化影响。全环食以独立档位呈现，同一带内的各区块共享全环食类型。

### 日食带中心与空间模板

日食候选的近似交点经度是 `λ = L − F折叠`。映射采用等距圆柱式线性尺度，X 向东，Z 向南，1° = 10 格。

```text
X = 10 × wrap(λ, −180°, 180°)
Z = −10 × clamp(23.4° sin λ + 68° × β/p, −80°, 80°)
```

其中 `β/p` 是同单位的无量纲比值。23.4° 正弦项近似太阳赤纬，68° 是游戏地图的纬向缩放参数。整数取整后，缓存保存方块坐标及半轴。地图是有限原点图幅，±180° 处没有循环拼接。完全不用墨卡托、对数或逐玩家经纬变换。

| 日食 | X 半轴（格） | Z 半轴（格） |
| --- | ---: | ---: |
| 日全食 | 560 | 96 |
| 日环食 | 520 | 80 |
| 日偏食 | 700 | 300 |
| 全环食 | 520 | 72 |

精判先拒绝 `abs(dx)>a` 或 `abs(dz)>b`，再检查 `ceil(1000·abs(dx)/a)² + ceil(1000·abs(dz)/b)² ≤ 1000000`。向上取整对边缘判定是保守的，极少数贴边点可能被略过。AABB 粗筛作用于完整的凸椭圆模板，平方前已限制输入范围。区块采用 `(16cx+8, 16cz+8)` 代表整个区块，边界因此会呈区块阶梯。月食在主世界夜间可见，跳过食带几何。

## 缓存与有限采样

`tick` 先检查资格。第一次遇到某世界日时，`cache/ensure` 经 `cache/day` 调用 `astro/day`，一次写入整条记录。日内只读记分板中的活动记录和时刻。回到已计算的世界日直接从 storage 恢复。无事件日也写入 `ready`，类型为 0。

```text
storage eclipse_cycle:state
  schema: 1
  days.d<world_day>:
    ready, kind, start, peak, end, syzygy, beta
    center_x, center_z, axis_x, axis_z
    chunks.c<chunk_x>_<chunk_z>: 0 | 1
```

上述尖括号是字段命名说明。活动日食窗口内，合格玩家用 `floor(floor(Pos)/16)` 取得区块坐标。玩家记分板 `ec.day/ec.cx/ec.cz/ec.inside` 未变时直接复用结果。换区块或换日时查全局 storage。同一天首次访问某区块才跑椭圆判定，已有 0 或 1 都可复用。缓存随存档保留，大小随访问日期和区块数增长。若调整计算模型并需要重算，先备份世界，再删除 `eclipse_cycle:state` 的 `days`、清除 `ec.day` 分数并 `/reload`。

- **出生或复活位置 ±30 格**。显式触发时读取主世界床点（`SpawnX/SpawnZ` 或 `respawn.pos`），没有主世界复活点时用配置坐标。取中心、四角和四边中点，归约成矩形的四个极值。在线性映射下，矩形内距椭圆中心最近的点即可用于重叠判定，即使 9 个点本身都在带外也可发现重叠。结果保存在玩家的 `ec.zone`。
- **下界黑曜石**。传送预检在玩家脚下、脚部、头部及四个水平方向 1–5 格共取 23 个点，发现黑曜石即停，结果存 `ec.portal`。这是 10 格邻域内的稀疏取样，会漏过采样轴之间或更远的方块。
- **主世界目标 ±5 格**。采用相同的 9 点矩形重叠法，避免遍历 121 格。预检结果存 `ec.target`。传送完成时用 actionbar 回显这个已保存的分数。

### 管理员传送接口

这个接口提供可选的脚本入口。原版下界传送门照常运作。对已同意且位于下界的玩家执行以下命令，坐标由管理员选择，目的地应当可安全落脚。

```mcfunction
scoreboard players set <玩家> ec.tx 120
scoreboard players set <玩家> ec.ty 80
scoreboard players set <玩家> ec.tz -80
execute as <玩家> run function eclipse_cycle:teleport/prepare
scoreboard players get <玩家> ec.ready
scoreboard players get <玩家> ec.target
execute as <玩家> run function eclipse_cycle:teleport/consume
```

`ec.ready=1` 代表黑曜石与目标预检通过，`ec.target` 表示预检当天的食带重叠情况。管理脚本可自行决定是否按重叠结果执行传送。`consume` 校验维度与同一天的一次性准备记录，读取已暂存的坐标，成功传送后回显预检结果。它不会在传送时重做目标的 9 点采样。之后的正常 tick 仍按通用区块缓存处理玩家位置。

## 视觉与原版限制

七种事件分别使用不同的标题、bossbar 强度、粒子与音效。日全食和全环食额外刷新短时黑暗效果。资源包的七张原创食相图包含遮挡太阳、日环、日偏与暗红月亮，通过 `title subtitle` 选用自定义 bitmap 字形。禁用提示后，bossbar 从该玩家移除，已有短时黑暗效果按原持续时间结束。

1.21.1 可静态覆盖 `textures/environment/sun.png` 和 `moon_phases.png`。1.21.11 将原版太阳和月相迁至天体图集。直接覆盖的贴图会持续存在，无法通过物品 `custom_model_data`、本项目的比分或玩家所在区块按事件切换。纯数据包也无法移动天空中的太阳和月亮、渲染月球从太阳前经过或改变主世界的自然光照曲线。本项目交付的是**按事件切换的画面提示**。原版天空贴图保持原样。

**独立可选视觉层。** Celestial Order Fix 的作者发布页标记为 CC0-1.0。其用途是调整天体渲染顺序。它与本项目没有事件通信，也不影响判定、位置或缓存。本仓库没有集成或分发该着色器。 [Celestial Order Fix](https://modrinth.com/shader/celestial-order-fix)

## 许可证与来源

| 来源 | 许可证或使用依据 | 使用方式与兼容性 |
| --- | --- | --- |
| Eclipse Cycle 函数、生成器、图案 | [MPL-2.0](LICENSE) | 原创项目文件，沿用仓库现有许可 |
| 朔望月等周期、黄纬级数系数、Bhāskara 正弦式 | 数值与数学关系作为事实和公式使用 | 只参考数学关系，独立用原版命令实现，不分发参考书或网页正文、代码和图像 |
| Minecraft 命令、谓词、内置粒子及音效 | [Minecraft EULA](https://www.minecraft.net/en-us/eula) 管辖游戏 | 使用游戏公开接口和资源 ID，分发物无 Mojang 二进制或纹理、音效副本 |
| Celestial Order Fix | 作者标记 CC0-1.0 | 仅列为独立可选项，无捆绑、调用或修改 |
| gm、N_lib、nn_math | 未引入，无需依赖其许可 | 原创 `eclipse_cycle:math/sin` 和 `math/sqrt` 作为替代 |

格式与复活点变更见 [Mojang Java 1.21](https://feedback.minecraft.net/hc/en-us/articles/27547857163917-Minecraft-Java-Edition-1-21-Tricky-Trials)、[1.21.5](https://feedback.minecraft.net/hc/en-us/articles/35298208390797-Minecraft-Java-Edition-1-21-5-Spring-to-Life)、[1.21.9](https://www.minecraft.net/en-us/article/minecraft-java-edition-1-21-9) 和 [1.21.11](https://www.minecraft.net/en-us/article/minecraft-java-edition-1-21-11) 的说明。低精度黄纬项可对照 [Position of the Moon](https://www.braeunig.us/space/plntpos.htm)。仓库中没有 NASA 事件表、Besselian 元素、路径数据或预计算日期与位置，也没有第三方数学库。
