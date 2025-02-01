# erosion (working title)

cool maritime / tehn collaborative vision

for iii arc

four meta-knobs controlling four midi cc each

# PLAY

- delta n: each knob outputs cc values
- key/short: go to SCENE
- key/long: go to EDIT

# SCENE

loads, saves, and erases scene data. a scene consists of the settings and current positions of the knobs and cc configuration per knob (min, max, slew, channel).

scenes are organized into 8 BANKS, each with 8 SCENES

- delta 1: select the BANK (position hightlighted)
- delta 2: select the SCENE (position highlighted, slots with data rendered wide)
- delta 3: CW changes action to CLEAR (CCW resets to LOAD)
- delta 4: CW changes action to SAVE (CCW resets to LOAD)

if ring 3/4 are not lit, action is LOAD (default).

- key/short: abort, back to PLAY
- key/long: execute action. LOAD (if slot is not empty) will return you to PLAY.

# EDIT

first you will be presented with which knob to edit, the knobs will pulse. select by turning the chosen knob either direction slightly. a short timeout will confirm your selection.

now you are editing cc min, max, slew, and ch for the four elements of the knob you previously selected.

- key/short: change parameter (min, max, slew, cc, ch)
- key/long: save, returns to PLAY
- delta n: change parameter value

each knob displays the parameter value (CCW towards zero, CW towards max). below each knob is an indicator of the parameter, shown as three tick marks.

- left: min
- right: max
- center: slew

cc is displayed on the right side as pixel-numbers from top-to-bottom: 1, 1-9, 1-9. to get the cc number, assemble the digits. (or see the diii screen for a numeric!)

ch is displayed on the left side as a pixel number 1-16.

TODO: slew is not yet implemented

changes to min and max will send the this cc value via midi, to help tune your instruments to the ranges you seek. when changing parameter modes all cc positions will be sent.

after editing be sure to save your SCENE so it will return next time.

note that a SCENE will be saved with current positions of each knob, so resuming in the exact state is assured.

when booting up the last-saved SCENE will be active.
