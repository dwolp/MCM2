<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/icon/openmcm2-dark.svg">
  <img src="assets/icon/openmcm2.svg" alt="OpenMCM2" width="360">
</picture>

# OpenMCM2 (Daniel's fork)

This is a fork of **[crspytopgn/openmcm2](https://github.com/crspytopgn/openmcm2)**,
the open-source Rust engine for Motocross Madness 2. Everything about the
engine itself (what it is, how to play, building, keys, controllers, formats,
tests) is in the
[original README](https://github.com/crspytopgn/openmcm2#readme).

This fork adds a few fixes and gameplay options on top. Some of them are
offered back to the original as pull requests; the rest are personal tweaks
that stay here. The options are together in the game's **Tweaks** box
(Options, then **Tweaks...** at the bottom).

Like the original, **this repository contains no game files**: you need your
own copy of Motocross Madness 2.

## Changes in this fork

### Bug fixes

| Fix | What was wrong | Status |
| --- | --- | --- |
| [White line in the terrain](#white-line-in-the-terrain) | A bright line across the ground a little way into the distance | Pull request [#4](https://github.com/crspytopgn/openmcm2/pull/4) (open) |
| [Track records are saved](#track-records-are-saved) | Best laps, stunt scores and race times were never written to the record tables | Pull request [#5](https://github.com/crspytopgn/openmcm2/pull/5) (open) |
| [Enduro gates both ways](#enduro-gates-both-ways) | A gate only counted from one side; in the original it counts from either | Pull request [#6](https://github.com/crspytopgn/openmcm2/pull/6) (open) |
| [Difficulty Level in single events](#difficulty-level-in-single-events) | The single event page's Easy/Normal/Hard was ignored: every race was Normal | Fork only |
| [3D grass only on green ground](#3d-grass-only-on-green-ground) | The enhanced look's 3D grass also grew on dirt, sand and rock | Fork only |
| [Cleaner starts](#cleaner-starts) | In National and Supercross races the computer riders piled into each other off the gate | Fork only |
| [Display Resolution works](#settings-in-the-game) | Options > Graphics > Display Resolution listed old 16-bit modes and did nothing | Fork only |
| [Frame rate in the game](#settings-in-the-game) | F2's frame rate only showed in the window's title bar, so not at all full screen | Fork only |

### Options in the Tweaks box

All in the game: Options, then **Tweaks...** at the bottom. Point at one to
see what it does. They are saved for the launcher and the desktop shortcut
too, and each has a command-line switch.

| Option | What it does | Default |
| --- | --- | --- |
| [Difficulty...](#difficulty-table) | Easy, Normal and Hard set from 1 to 10: the other riders' speed and skill, how easily you crash, Quarry tricks | The original's (3, 5, 7) |
| [Air steering](#air-steering) | A slider: how much steering in the air bends your flight | 100% (the middle; far left is the original) |
| [Air braking](#air-braking) | A slider: how much braking in the air shortens your flight | 100% (the middle; far left is the original) |
| [Quick get-up](#quick-get-up) | G or a pad's Back puts you straight back on the bike after a crash | On |
| [Modernised HUD](#modernised-hud) | Crisp speedometer, see-through panel, radar and dial, smooth radar lines, panel text that fits | On |
| [Race display nearer the middle](#ultrawide-support) | On screens wider than 16:9, the race display where it sits on 16:9 | Off |
| [Live gap to your best lap](#live-gap-to-your-best-lap) | Under the race panel: how far ahead or behind your best lap you are | On |
| [Steadier camera](#camera-comfort) | The chase camera rises and dips with the bike more gently | On |
| [Field of view](#camera-comfort) | How wide the riding cameras see, 60° to 120° | 85° (the original's) |
| [Controller vibration](#controller-vibration) | The pad thumps on landings, knocks over bumps and jolts in crashes, with a strength slider | On, 50% |
| [VSync](#settings-in-the-game) | A picture each time the screen refreshes, with no tearing | On |
| [Show frame rate](#settings-in-the-game) | The frames a second at the bottom left (F2 too) | Off |

### Other additions

| Change | What it does | Status |
| --- | --- | --- |
| [Ultrawide support](#ultrawide-support) | 21:9 view, black bars past 21:9, unstretched race display, clearer launcher Display settings | Pull request [#3](https://github.com/crspytopgn/openmcm2/pull/3) (open) |
| [Settings in the game](#settings-in-the-game) | The Tweaks box, and the window size changed from the game's Options | Fork only |
| [Play without the launcher](#play-without-the-launcher) | The game starts with the launcher's settings on its own, and a button makes a "Play MM2" desktop shortcut | Fork only |
| [One-lap races](#one-lap-races) | National and Supercross can be 1 lap long | Fork only |

### Ultrawide support

* A window wider than 4:3 sees more to the sides, up to 21:9. On anything
  wider (such as 32:9) the race is drawn 21:9 in the middle with black bars
  at the sides.
* The race display (speed, laps, radar and so on) keeps its shape instead of
  stretching; each piece moves to the nearest edge. The menus stay 4:3 in
  the middle.
* New option **Race display nearer the middle**
  (`--centred-display`, in the game's Tweaks), for screens wider than
  16:9: puts the race display where it sits on a 16:9 screen, so you
  don't have to look to the far corners.
* The launcher's **Display** box is redesigned: choose *Full screen
  (recommended)* or *In a window*, and the sizes are grouped by shape
  (4:3 Classic, 16:9 Widescreen, 21:9 Ultrawide) with their common names.
  It detects your monitor and only offers windows that fit on it.

### White line in the terrain

With the enhanced look, a thin bright line could show across the ground
where the detailed nearby ground meets the far terrain. The two now overlap
slightly, so there is no gap to see through.

### Track records are saved

Finishing a race never wrote to the high-score tables. Now a finished
single-player race (not practice, network races or replays) enters your
best lap (or stunt score) and, for 5- and 10-lap races, your whole race
time into the track's records.

### Enduro gates both ways

In Enduro and Baja, a checkpoint gate only counted if you rode through it
from one side. In the original game it counts from either side, and now it
does here too (for human riders; computer riders are unchanged).

### Difficulty Level in single events

The single event page's Difficulty Level (Easy, Normal, Hard) was ignored:
the page put it back to Normal and every single event was raced on Normal
whatever was picked. Now the race uses the level picked, and the page keeps
it while you switch tabs.

### 3D grass only on green ground

With the enhanced look's 3D grass, tufts also grew on dirt, sand and rock.
Each tuft's random roll came from a formula built on `sin()`, which far
from the middle of a map loses its precision and returns exactly 0, and a
roll of 0 slipped past the "is this ground green?" test. An integer
formula replaces it, and ground with no green now never grows grass.
Brown tracks such as Chanos and most Nationals now have no 3D grass, as
was meant; green stadium floors in Supercross still grow some.

### Cleaner starts

In National and Supercross races the computer riders often crashed into
each other off the gate. The gate is about 55 ft wide, but each rider
heads for its own lane only up to 7 ft either side of the course's middle,
so the whole field squeezed into the middle at once, riders cut across
each other, and two riders were often given almost the same lane and
rubbed side by side until one was thrown off.

Now the lanes are handed out in the gate's order from left to right and
kept at least 3.5 ft apart, and each rider keeps its place across the gate
for 2 seconds after the drop, then eases into its lane over the next 6.
Over all 16 Nationals, the computer riders touch each other about 85%
less in the first 12 seconds, and crash a third less often there.

### Difficulty table

**Difficulty...** in the game's Tweaks opens a table of the four things
the original game changes between Easy, Normal and Hard, one column per
level. Each cell is a step from 1 to 10, set with its arrows, and higher
is always harder (`--difficulty=`, the twelve steps row by row). The
original game's Easy, Normal and Hard are steps 3, 5 and 7, and
**Original** puts them back. Pointing at a cell says what its step
stands for:

| Step | 1 | 2 | **3** | 4 | **5** | 6 | **7** | 8 | 9 | 10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Rivals' speed: engine power, % of Normal | 70 | 77 | **85** | 92 | **100** | 107 | **115** | 135 | 160 | 180 |
| Rivals' skill: how easily they crash, and their trick chance in a race, % of Normal | 150 | 130 | **115** | 107 | **100** | 88 | **77** | 55 | 35 | 20 |
| How easily you crash: the hit you can take, % of Normal | 130 | 120 | **110** | 105 | **100** | 97 | **95** | 80 | 65 | 50 |
| Rivals' tricks (Stunt Quarry): wait between tricks, s | 35 | 30 | **25** | 20 | **15** | 10 | **5** | 3 | 1 | 0 |

Steps 8 to 10 climb steeply, so 10 is far past Hard. Over 8 Nationals
with rivals' speed and skill both set the same in the Hard column, the
computer riders average:

| Rivals' speed and skill | Pace | Crashes a minute |
| --- | --- | --- |
| 7 (Hard) | 52.5 ft/s | 1.95 |
| 8 | 56.9 ft/s | 1.00 |
| 9 | 59.7 ft/s | 0.80 |
| 10 | 61.5 ft/s | 0.47 |

Most of a skilled rider's crashes are landings in the middle of a trick,
so the skill row also sets how often they try one in a race (the game's
2% a frame in the air at its own steps).
A table saved before the steps (as percentages) goes back to the
original's.
More engine power mostly helps the computer riders out of slow corners:
they already have more than they use, so their top speed hardly changes.
The single event page's Difficulty Level, a Pro Circuit's difficulty and a
network game's choose the column.

### Controller vibration

**Controller vibration** in the game's Tweaks (`--vibration=N` or
`--vibration=off`), on by default, with a strength slider. A pad
that can vibrate thumps when you land (harder landings thump harder),
knocks over sharp bumps, jolts as you crash and rumbles while the rider
tumbles. It is strong: half way on the slider is about full strength for
a hard landing, and smaller landings and bumps are felt too. Nothing in
the menus or replays, or while the game is out of focus. Works with Xbox pads on Windows and pads on Linux; not on a Mac.
Started by hand without `--vibration`, the game's own Force Feedback
setting in Options > Controls is used until it is set in Tweaks.

### Modernised HUD

**Modernised HUD** in the game's Tweaks, on by default (off:
`--original-race-display`). The race display's art is 640×480-era and is
enlarged about three times on a 1440p screen:

* The speedometer's numbers and marks are taken out of its picture and
  drawn crisp at the screen's resolution, in the same places; the needle
  has smooth edges.
* The race panel, the radar and the speedometer's face are drawn as
  see-through grey shapes with a faint light rim, at the screen's
  resolution, in place of their old pictures: a rounded box with faint
  rules between the panel's lines, a disc with the radar's rings and
  cross, and a round dial cut flat at the bottom with a hub over the
  needle.
* The panel, radar and speedometer pictures are enlarged smoothly, so their
  curves don't step.
* The radar's track lines and crosshair are smooth instead of stepping in
  blocks.

Either way, the race panel's text is a little smaller so long times stay in
their boxes, and a line that still wouldn't fit is drawn smaller.

### Air steering

**Air steering** in the game's Tweaks (`--air-steer=N`), a slider from
off to 200% in steps of 10, at 100% in the middle by default. In the
original, steering in the air only turns the bike slightly (about 11° a
second) and the flight goes on as it was. With this, steering also bends
the flight, about 20° a second at full lock at 100% (twice that at
200%), and turns the bike with it so it lands in line with where it is
going. Off, far left, is the original game.

### Air braking

**Air braking** in the game's Tweaks (`--air-brake=N`), a slider from
off to 200% in steps of 10, at 100% in the middle by default. Holding the
brake in the air takes off a little of your speed, about 6 ft/s each
second at full brake at 100% (twice that at 200%), so you can come up
short of a landing you would overshoot. The brake still tips the nose
down too if Brake Gyro is on in Options > Controls, as in the original.
Off, far left, is the original game, where braking in the air changes
nothing about the flight.

### Quick get-up

**Quick get-up** in the game's Tweaks, on by default (off:
`--no-quick-get-up`). After a crash, **G** on the keyboard or **Back**
(View) on a pad puts you
straight back on the bike where the crash would have, instead of waiting
for it to play out; the screen says so while you are down. Upright but
stuck, it puts you back on the course. Not in network races.

### Live gap to your best lap

**Live gap to your best lap** in the game's Tweaks (`--lap-gap`), on by
default. A box under the race panel shows how far ahead (green) or behind
(red) your best lap you are at each point of the course, and each lap's
time and gap as it ends. Lap 1 starts at the gate rather than the line,
so the comparing starts from lap 2; the best lap is kept when you restart
with R.

### Camera comfort

* **Steadier camera** in the game's Tweaks (`--steady-camera`), on by
  default: the chase camera rises and dips with the bike more gently, so
  bumps don't shake the view; it still turns with the bike as the
  original does. Off is the original game's.
* **Field of view** in the game's Tweaks (`--fov=N`), 60° to 120°: how
  wide the riding cameras see. 85° is the original game's.

### Settings in the game

* **Tweaks...** at the bottom of Options opens **Additional Tweaks**, built
  from the game's own Advanced Options pieces: every option in
  [the list above](#options-in-the-tweaks-box), with what the one under
  the pointer does shown below them. Its **Difficulty...** button opens
  the [difficulty table](#difficulty-table). Changes count from the next
  race. The launcher no longer has them.
* Options > Graphics > **Display Resolution** is real now: Full Screen or
  a window of a size that fits your screen (the launcher's sizes), changed
  at once. The original's list of 16-bit modes did nothing.
* Both are saved to the launcher's settings, so the desktop shortcut and
  the launcher's PLAY use them too; the launcher reloads them when the
  game ends. Its Display box now only says how the game will start.
* **VSync** and **Show frame rate** are in Tweaks too, under Screen. The
  frame rate is drawn small at the bottom left of the game, in menus
  and races, rather than in the window's title bar; F2 still shows or
  hides it.

### Play without the launcher

Started with no arguments (a double-click, a shortcut), `mm2-viewer`
starts with the settings last saved in the launcher, just as the
launcher's PLAY does, and keeps `last-run.log` too. With no game set up
yet, it opens the launcher instead. Arguments still work as before.

**Make a desktop shortcut**, under the launcher's PLAY button, puts a
**Play MM2** shortcut to it on the desktop. It always uses the launcher's
latest settings, so it never needs making again. On a Mac it is a
`.command` script, on Linux a `.desktop` entry.

The launcher's settings code is now its own small crate, `mm2-settings`,
shared by the launcher and the game.

### One-lap races

The laps list for National and Supercross races started at 2; now it starts
at 1, as for Baja and Enduro.

## Playing this fork

Build it as the original README describes, from this repository:

```sh
cargo build --release -p mm2-viewer -p mm2-launcher
./target/release/mm2-launcher
```

## Legal

OpenMCM2 is an independent fan project. It is not affiliated with, endorsed by
or sponsored by Microsoft or Rainbow Studios. Motocross Madness is a trademark
of Microsoft Corporation, and the game, its data and artwork are © Microsoft.
This repository contains no game files and no code from the original game.
Do not commit game files, extracted assets or texture packs made from them.

## Licence

Same as the original: either of the [Apache License, Version 2.0](LICENSE-APACHE)
or the [MIT licence](LICENSE-MIT), at your option, except `crates/mm2-indeo`,
which is under the GNU LGPL 2.1 or later
([COPYING.LGPLv2.1](crates/mm2-indeo/COPYING.LGPLv2.1)). The Indeo 5 decoder
is a port of [FFmpeg](https://ffmpeg.org)'s, by Maxim Poliakovski. Ground
materials for `--enhanced` are from [ambientCG](https://ambientcg.com), CC0.
