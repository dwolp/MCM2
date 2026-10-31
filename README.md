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
that stay here. The options are together in the launcher's **Additional
Tweaks** box.

Like the original, **this repository contains no game files**: you need your
own copy of Motocross Madness 2.

## Changes in this fork

| Change | What it does | Status |
| --- | --- | --- |
| [Ultrawide support](#ultrawide-support) | 21:9 view, black bars past 21:9, unstretched race display, clearer launcher Display settings | Pull request [#3](https://github.com/crspytopgn/openmcm2/pull/3) (open) |
| [White line in the terrain](#white-line-in-the-terrain) | Fixes a bright line across the ground a little way into the distance | Pull request [#4](https://github.com/crspytopgn/openmcm2/pull/4) (open) |
| [Track records are saved](#track-records-are-saved) | Best laps, stunt scores and race times are now written to the record tables | Pull request [#5](https://github.com/crspytopgn/openmcm2/pull/5) (open) |
| [Enduro gates both ways](#enduro-gates-both-ways) | A gate counts whichever way you ride through it, as in the original | Pull request [#6](https://github.com/crspytopgn/openmcm2/pull/6) (open) |
| [Easier riding](#easier-riding) | Makes Easy easier: forgiving landings, a wider course, slower computer riders | Fork only |
| [Controller vibration](#controller-vibration) | The pad thumps on landings, knocks over bumps and jolts in crashes | Fork only |
| [Modernised HUD](#modernised-hud) | Crisp speedometer, clean see-through panel, radar and dial, smooth radar lines, panel text that fits | Fork only |
| [Quick get-up](#quick-get-up) | G or a pad's Back puts you straight back on the bike after a crash | Fork only |
| [Live gap to your best lap](#live-gap-to-your-best-lap) | Under the race panel: how far ahead or behind your best lap you are | Fork only |
| [Camera comfort](#camera-comfort) | A steadier chase camera and a field of view setting | Fork only |
| [Play without the launcher](#play-without-the-launcher) | The game starts with the launcher's settings on its own, and a button makes a "Play MM2" desktop shortcut | Fork only |
| [One-lap races](#one-lap-races) | National and Supercross can be 1 lap long | Fork only |

### Ultrawide support

* A window wider than 4:3 sees more to the sides, up to 21:9. On anything
  wider (such as 32:9) the race is drawn 21:9 in the middle with black bars
  at the sides.
* The race display (speed, laps, radar and so on) keeps its shape instead of
  stretching; each piece moves to the nearest edge. The menus stay 4:3 in
  the middle.
* New launcher option **Race display nearer the middle**
  (`--centred-display`, in Additional Tweaks), for screens wider than
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

### Easier riding

One launcher checkbox under **Additional Tweaks** (`--easier`), off by
default. Off is the original game. When on, it changes races on the Easy
difficulty only; Medium and Hard stay as the original. On Easy:

* **Forgiving landings.** Land a jump roughly level on both wheels and the
  bike takes a much harder landing without throwing you off. Nose-first
  landings and flips still crash.
* **Wider course.** The course counts 20 ft wider on each side before the
  off-course timer starts.
* **Slower rivals.** The computer riders are slower, and you come off your
  bike less in other crashes.

### Controller vibration

**Controller vibration** in Additional Tweaks (`--vibration=N` or
`--vibration=off`), on by default, with a Weaker/Stronger slider. A pad
that can vibrate thumps when you land (harder landings thump harder),
knocks over sharp bumps, jolts as you crash and rumbles while the rider
tumbles. Nothing in the menus or replays, or while the game is out of
focus. Works with Xbox pads on Windows and pads on Linux; not on a Mac.
Started without the launcher, the game's own Force Feedback setting in
Options > Controls is used instead.

### Modernised HUD

**Modernised HUD** in Additional Tweaks, on by default (off:
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

### Quick get-up

After a crash, **G** on the keyboard or **Back** (View) on a pad puts you
straight back on the bike where the crash would have, instead of waiting
for it to play out; the screen says so while you are down. Upright but
stuck, it puts you back on the course. Not in network races.

### Live gap to your best lap

**Live gap to your best lap** in Additional Tweaks (`--lap-gap`), on by
default. A box under the race panel shows how far ahead (green) or behind
(red) your best lap you are at each point of the course, and each lap's
time and gap as it ends. Lap 1 starts at the gate rather than the line,
so the comparing starts from lap 2; the best lap is kept when you restart
with R.

### Camera comfort

* **Steadier camera** in Additional Tweaks (`--steady-camera`), on by
  default: the chase camera rises and dips with the bike more gently, so
  bumps don't shake the view; it still turns with the bike as the
  original does. Off is the original game's.
* **Field of view** in Additional Tweaks (`--fov=N`), 60° to 120°: how
  wide the riding cameras see. 85° is the original game's.

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
