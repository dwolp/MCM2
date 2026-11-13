# OpenMCM2 1.2.0 (Daniel's fork)

A big graphics update on top of
[1.0.4](https://github.com/dwolp/MCM2/releases/tag/v1.0.4): ray tracing,
night races with floodlit Nationals, steadier pictures, faster forests and
a new launcher. You need your own copy of Motocross Madness 2; see the
[README](https://github.com/dwolp/MCM2#readme) for what this fork changes.

Download the archive for your computer below, unpack it and start the
launcher (`mm2-launcher`). An earlier 1.0 launcher offers this update
itself.

## New in 1.2.0

* **A new launcher**: pages for Play, Graphics, Tracks and Updates in a
  sidebar, with the PLAY button always at hand. Buttons, sliders and
  switches replace the drop-down lists and check boxes, and every effect
  has a line saying what it does.
* **Ray tracing** (Enhanced graphics, pick the **Ray traced** preset; needs
  an NVIDIA RTX, AMD RX 6000 or newer graphics card). Built on what the
  graphics card traces as rays:
  * True sun shadows from every object and from the hills, soft where
    they fall far.
  * Beams of sunlight through the trees and past the riders.
  * Wet ground, puddles and bike paint reflecting what is round them.
  * In the domed stadium, a fan of shadows from its floodlights.
* **Night races**: pick **Night** as the time of day.
  * On the Nationals the light poles light pools of track, with or
    without ray tracing. Their light is worked out once as the race
    loads, with the soft shadows of everything that never moves; without
    ray tracing the hills shade it.
  * With ray tracing, each bike's headlight lights the track ahead and
    casts long shadows, and the riders cast shadows in the floodlights.
  * The sponsors' boards along the Nationals glow, lit from behind.
* **Time of day and weather in the game**: pick them on the Event page
  before each race, under Difficulty. Your choice is kept for the next
  race and the next start.
* **Dust clouds that cast shadows**, softer and without square blotches.
* **Steadier pictures**: anti-aliasing is now one choice: Off, MSAA 2×,
  4× or 8×, or the new **TAA**. TAA blends each frame with the ones
  before, so billboards, leaves and fences stop shimmering. Below 100%
  scene resolution it also rebuilds the picture at the screen's own
  sharpness: the fastest good-looking way to play with ray tracing.
* **Every graphics setting shown**: the anti-aliasing and the scene
  resolution (Auto or 50–100% of the screen) are settings of their own.
  A preset sets them and the effects; change any and it shows as
  **Custom**. Medium uses TAA; Ultra has every effect but ray tracing,
  with lasting ruts. The trackside props and crowd and the colour grade
  are in no preset, as a matter of taste: turn them on under Effects.
* **Faster forests**: far off, trees are drawn as the game's own flat
  pictures of them, as the original game did. The forest tracks run
  noticeably faster, with or without ray tracing.

## Fixes

* **Flickering tents, signs and logos far off**: the tents' walls and the
  logos on boards and banners no longer flicker in and out at a distance.
* **Billboards no longer shimmer** along the tracks.
* **Steadier nights**: the sponsors' boards glow steadily, lit only by
  their own light, and fences, signs and other things beside the track no
  longer flicker in the lamps' light. No more flickering black specks on
  tree trunks and posts either.

On an RTX 4070 at 3440×1440 by day, the Ray traced preset runs at about
90 frames a second in Iron Mountain's forest and 115 on Morenci Mine;
High without ray tracing at about 160 and 180.
