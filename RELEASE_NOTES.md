# OpenMCM2 1.0.1 (Daniel's fork)

A fix for Linux on top of [1.0.0](https://github.com/dwolp/MCM2/releases/tag/v1.0.0).
You need your own copy of Motocross Madness 2; see the
[README](https://github.com/dwolp/MCM2#readme) for what this fork changes.

Download the archive for your computer below, unpack it and start the
launcher (`mm2-launcher`). A 1.0.0 launcher offers this update itself.

## Fixes

* **Menu text on Arch Linux** (and other distributions that file their
  fonts in their own folders): the menus showed every box and picture
  but no text. The game now looks through all the font folders, including
  your own `~/.local/share/fonts`, for Arial or a font of the same size,
  Liberation Sans or Arimo, and falls back to DejaVu Sans. On Arch,
  `sudo pacman -S ttf-liberation` gives the closest match to the original.
