# OpenMCM2 1.0.4 (Daniel's fork)

Fixes and small improvements on top of
[1.0.0](https://github.com/dwolp/MCM2/releases/tag/v1.0.0).
You need your own copy of Motocross Madness 2; see the
[README](https://github.com/dwolp/MCM2#readme) for what this fork changes.

Download the archive for your computer below, unpack it and start the
launcher (`mm2-launcher`). An earlier 1.0 launcher offers this update
itself.

## New in 1.0.4

* **Bumpers change tabs**: on a gamepad, LB and RB go to the previous
  and next tab on the menu screens that have them (Single Player, the
  network lobby, Options, the Pro Circuit, Records and Ghosts/Replays).
* **Better 3D grass** (Enhanced graphics): no more grey grass on the
  grey roads of the Baja, Enduro and Starlight Park tracks. The tufts are
  shorter, reach out to 160 ft, and sink into the ground far off instead
  of popping in.
* **Options that do nothing are greyed out**: the settings the original
  game had that this version doesn't use (the Advanced graphics sliders
  and check boxes, Sound Hardware, and the Garage suspension sliders)
  can no longer be changed.

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
