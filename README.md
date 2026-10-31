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
that stay here.

Like the original, **this repository contains no game files**: you need your
own copy of Motocross Madness 2.

## Changes in this fork

| Change | What it does | Status |
| --- | --- | --- |
| [Ultrawide support](#ultrawide-support) | 21:9 view, black bars past 21:9, unstretched race display, clearer launcher Display settings | Pull request [#3](https://github.com/crspytopgn/openmcm2/pull/3) (open) |
| [White line in the terrain](#white-line-in-the-terrain) | Fixes a bright line across the ground a little way into the distance | Pull request [#4](https://github.com/crspytopgn/openmcm2/pull/4) (open) |
| [Track records are saved](#track-records-are-saved) | Best laps, stunt scores and race times are now written to the record tables | Pull request [#5](https://github.com/crspytopgn/openmcm2/pull/5) (open) |
| [Enduro gates both ways](#enduro-gates-both-ways) | A gate counts whichever way you ride through it, as in the original | Pull request [#6](https://github.com/crspytopgn/openmcm2/pull/6) (open) |
| [Easier riding](#easier-riding) | Forgiving landings, a wider course and an easier Easy, as one launcher option | Fork only |

### Ultrawide support

* A window wider than 4:3 sees more to the sides, up to 21:9. On anything
  wider (such as 32:9) the race is drawn 21:9 in the middle with black bars
  at the sides.
* The race display (speed, laps, radar and so on) keeps its shape instead of
  stretching; each piece moves to the nearest edge. The menus stay 4:3 in
  the middle.
* New launcher option **Race display nearer the middle**
  (`--centred-display`), shown on screens wider than 16:9: puts the race
  display where it sits on a 16:9 screen, so you don't have to look to the
  far corners.
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

One launcher checkbox under **Gameplay** (`--easier`), off by default. Off
is the original game. When on:

* **Forgiving landings.** Land a jump roughly level on both wheels and the
  bike takes a much harder landing without throwing you off. Nose-first
  landings and flips still crash.
* **Wider course.** The course counts 20 ft wider on each side before the
  off-course timer starts.
* **Easier Easy.** On the Easy difficulty the computer riders are slower and
  you come off your bike less. Medium and Hard are unchanged.

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
