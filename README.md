<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/icon/openmcm2-dark.svg">
  <img src="assets/icon/openmcm2.svg" alt="OpenMCM2" width="360">
</picture>

# OpenMCM2 (Daniel's fork)

A fork of **[OpenMCM2](https://github.com/crspytopgn/openmcm2)**, the
open-source Rust engine for Motocross Madness 2, with better graphics, ray
tracing, night races and a pile of gameplay tweaks and fixes.

* **[Download the latest release](https://github.com/dwolp/MCM2/releases/latest)**
  for Windows, macOS or Linux, unpack it and start `mm2-launcher`.
* You need your own copy of Motocross Madness 2. This repository contains
  no game files.
* For how to play, keys, controllers, building and file formats, see the
  [original README](https://github.com/crspytopgn/openmcm2#readme).

## New in 1.2

* **Ray tracing** (the **Ray traced** preset; needs an NVIDIA RTX, AMD RX 6000
  or newer card):
  * real sun shadows from everything, including the hills, soft where they
    fall far;
  * light shafts through the trees;
  * reflections in puddles, wet ground and bike paint.
* **Night races**: lit Nationals light poles, and headlights that cast
  shadows (the headlights need ray tracing).
* **Time of day and weather** are now picked in the game, on the Event page.
* **A new launcher**: sidebar pages, with every setting explained.
* **TAA anti-aliasing**: no more shimmering billboards, leaves or fences.
* **Faster forests**: far trees are drawn as flat pictures, as the original
  game did.
* **Dust clouds that cast shadows**.
* **Fixes**: no more flickering tents and logos far off, and steady nights.

Full notes are on the [release page](https://github.com/dwolp/MCM2/releases/latest).

## Everything else this fork changes

Most options are in the game: Options, then **Tweaks...**.

**Gameplay**

* **Difficulty table**: Easy, Normal and Hard can each be tuned from 1 to 10:
  rival speed, rival skill, how easily you crash, and Quarry tricks.
* **Air steering and air braking**: sliders to bend or shorten your flight
  in the air. Far left is the original game.
* **Quick get-up**: G, or Back on a pad, puts you straight back on the bike
  after a crash.
* **Live gap to your best lap** under the race panel.
* **Controller vibration** on landings, bumps and crashes (Windows and Linux).
* **One-lap races** for National and Supercross.

**Look and feel**

* **Ultrawide support**: 21:9 view, black bars past it, and a race display
  that isn't stretched.
* **Modernised HUD**: a crisp speedometer, plus a see-through panel and radar.
* **Steadier camera** and an adjustable **field of view**.
* **Settings in the game**: VSync, a frame-rate counter and a working
  Display Resolution option.
* **Every graphics setting shown** in the launcher: presets, anti-aliasing
  and scene resolution.
* **Play without the launcher**: a "Play MM2" desktop shortcut uses your
  launcher settings.

**Fixes**

* Track records (best laps, scores, race times) are saved.
* Enduro and Baja gates count from either side, as in the original game.
* The Difficulty Level on the single event page is no longer ignored.
* Computer riders no longer pile into each other off the start gate.
* 3D grass grows only on green ground.
* No white line across the terrain in the distance.

## Building

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
