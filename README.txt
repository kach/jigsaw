+----------------------------------------------------------------------------+
| Summer is not obligatory. We can start an infernally hard jigsaw puzzle in |
| June with the knowledge that if there are enough rainy days, we may just   |
| finish it by Labor Day, but if not, there's no harm, no penalty. We may    |
| have better things to do.                                                  |
|                               -- Nancy Gibbs                               |
+----------------------------------------------------------------------------+

This is just a silly little program I wrote that generates SVG paths for
cutting out tricky triangular jigsaw puzzles inspired by the art of MC Escher.
Notice how each boundary's notches are designed such that once connected, the
pieces cannot be slid apart.

I laser cut the pieces by importing the SVG into Inkscape and then using the
plugin here:

https://github.com/TurnkeyTyranny/laser-gcode-exporter-inkscape-plugin

to generate gcode. You might have to set the "fill" to transparent manually,
because for whatever reason Inkscape doesn't see the directive in the SVG.

You can find sample output in this repository, as well as some pictures of my
successful and unsuccessful attempts to actually manufacture a physical puzzle.

A note on materials: in my experience, wood tends to char and splinter when
laser cut, making it unsuitable for puzzle pieces. Fiberboard works better,
with the caveat that if the laser cutter doesn't penetrate all the way through,
you may need to use an X-ACTO knife to separate the pieces.

Enjoy!
