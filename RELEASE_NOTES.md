# OpenMCM2 1.0.3 (Daniel's fork)

Fixes for the Steam Deck, Linux and Windows on top of
[1.0.0](https://github.com/dwolp/MCM2/releases/tag/v1.0.0).
You need your own copy of Motocross Madness 2; see the
[README](https://github.com/dwolp/MCM2#readme) for what this fork changes.

Download the archive for your computer below, unpack it and start the
launcher (`mm2-launcher`). An earlier 1.0 launcher offers this update
itself.

## Fixes

* **Mouse pointer in the Steam Deck's Gaming Mode** (new in 1.0.3):
  Gaming Mode hid the pointer, so the menus couldn't be used with the
  trackpad. The game now draws its own arrow there; everywhere else it
  keeps the system's.
* **Exporting textures for a high-res pack on Windows** (new in 1.0.3):
  `mm2-tools textures` stopped with "The system cannot find the path
  specified". Packs already made on a Mac still load. The export also
  leaves out the 28 tiny 4×4 frame corners that stopped Upscayl's batch
  partway; the game keeps its own.
* **Full screen on the Steam Deck** (1.0.2): switching to full screen
  crashed the game, and it then crashed on every start. It now plays full
  screen.
* **Menu text on Arch Linux and SteamOS** (1.0.1): the menus showed no
  text. The game now finds Arial, Liberation Sans, Arimo or DejaVu Sans in
  any font folder. On Arch, `sudo pacman -S ttf-liberation` gives the
  closest match to the original.
