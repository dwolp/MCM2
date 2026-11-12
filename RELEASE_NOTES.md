# OpenMCM2 1.2.0 (Daniel's fork)

Night races get floodlights for everyone, ray tracing gets steadier, and
the time of day and weather move into the game. On top of
[1.1.0](https://github.com/dwolp/MCM2/releases/tag/v1.1.0). You need your
own copy of Motocross Madness 2; see the
[README](https://github.com/dwolp/MCM2#readme) for what this fork changes.

Download the archive for your computer below, unpack it and start the
launcher (`mm2-launcher`). An earlier launcher offers this update itself.

## New in 1.2.0

* **Time of day and weather in the game**: pick them on the Event page
  before each race, under Difficulty, instead of in the launcher. Your
  choice is kept for the next race and the next start.
* **Floodlit Nationals at night, with or without ray tracing**: the light
  poles' light is worked out once as the race loads, every pole and the
  shadows of everything that never moves, softer than before. Without ray
  tracing the poles now light their pools of track too (the hills shade
  them); before, there was only a brighter moon. With ray tracing only the
  riders' shadows in it are traced each frame. The floodlights are also a
  little brighter.
* **Faster ray-traced shadows at night**: each part of the screen looks
  only at the lamps that can reach it, and neighbouring pixels that see
  the same thing share their rays.

* **Presets**: the trackside props and crowd and the colour grade are in
  no preset now, as they're a matter of taste: turn them on under Effects.
  The Ray traced preset now has smooth hills.

## Fixes

* **Flickering specks on tree trunks and posts at night**: with ray
  tracing, the headlights and floodlights left black specks that
  flickered on thin trunks and fence posts. They are gone.
