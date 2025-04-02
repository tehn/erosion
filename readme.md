# erosion

cool maritime / tehn collaborative vision

for iii arc

_four meta-knobs controlling four MIDI CC each_

### PLAY

- DELTA N: each knob outputs up to four CC values
- KEY/SHORT: go to SCENE
- KEY/LONG: go to EDIT

### SCENE

Loads, saves, and erases scene data. a scene consists of the settings and current positions of the knobs and CC configuration per knob (min, max, slew, CC, CH, active).

Scenes are organized into 8 BANKS, each with 8 SCENES

- DELTA 1: select the BANK (position hightlighted)
- DELTA 2: select the SCENE (position highlighted, slots with data rendered wide)
- DELTA 3: CW changes action to CLEAR (CCW resets to LOAD)
- DELTA 4: CW changes action to SAVE (CCW resets to LOAD)

If ring 3/4 are not lit, action is LOAD (default).

- KEY/SHORT: abort, back to PLAY
- KEY/LONG: execute action. LOAD (if slot is not empty) will return you to PLAY.

### EDIT

First you will be presented with which knob to edit, the knobs will pulse. Select by turning the chosen knob either direction slightly. A short timeout will confirm your selection.

Now you are editing parameters for the four elements of the knob you previously selected.

- KEY/SHORT: change parameter (min, max, slew, CC, CH, active)
- KEY/LONG: save, returns to PLAY
- DELTA N: change parameter value

PARAMETER CYCLE: min, max, slew, CC number, MIDI channel, active

Each knob displays the parameter value (CCW towards zero, CW towards max). Below each knob is an indicator of the parameter, shown as three tick marks.

- left: min
- right: max
- center: slew

CC is displayed on the right side as pixel-numbers from top-to-bottom: 1, 1-9, 1-9. To get the CC number, assemble the digits (or see the diii screen for a numeric!)

CH is displayed on the left side as a pixel number 1-16.

Active is shown with a half-circle over the top of the ring. Deactivated positions cease to display the three ticks at the bottom as a reminder of this off-state.

Changes to min and max will send the this CC value via MIDI, to help tune your instruments to the ranges you seek. When changing parameter modes all CC positions will be sent.

After editing be sure to save your SCENE so it will return next time.

Note that a SCENE will be saved with current positions of each knob, so resuming in the exact state is assured.

When booting up the last-saved SCENE will be active.
