# LBIC Mapping
Software written for LBIC Mapping System
  --to be paired with Picoscope 6 and Benbox laser engraving software

Instructions for LBIC
Getting Scans:
1. Open Picoscope 6 and Benbox
2. Follow “Instructions For Benbox”
  a. Set Z-Scan
  b. Set continuous
  c. Set 2300 speed
3. Import a rectangle with similar cell dimensions (using upper right-hand corner folder button)
  a. Orientation corresponds to looking at the laser from the power button.
  b. If box is not resized, then the dimensions should be more or less accurate.
  c. Note size for Matlab
4. Place sample so that laser begins in the top right hand corner. (Or move laser so that it will begin in the top right-hand corner)
5. Use “Perimeter” in Benbox to center sample
6. Turn on preamplifier
7. Run the laser while adjusting “Sensitivity” and “Multiplier” settings so that preamplifier does notoverload while the laser is on the cell
  a. ex) S=10^-4, M=1: 6 V → 6*10^-4*1 A = 0.6 mA
8. With Picoscope 6, open “PVSK Settings” to import settings
9. Adjust Channel A’s voltage max/min to maximize space on screen without overloading
10. Stop and restart Picoscope run, THEN start laser run.
11. When laser has finished, stop the Picoscope.
12. Save the Picoscope run as a .csv file using the dropdown.
  a. Save with pre-amp settings to help remember (ex: 20180704-0001 -5 1.csv)
  b. Make sure the run DOES NOT have ‘.’ (messes with saving the png)
  c. Sensitivity: -5; Multiplier: 1
 
 Tips:
● Refocus the laser if height of sample changes (or if it gets out of focus)
● Make sure the entire run is on one screen. If not, adjust seconds/div to be higher. (Also adjust number of samples to be higher.)
● Check if laser is done at bottom of Benbox (if it says 100%) or if progress bar is not there.
● Picoscope can run longer than necessary, just save 1 screen in “Save As” option.
● In Benbox, imported image will be 10 pixels per millimeter so to get a black square 6 x 6 cm, create a black square 600 x 600 pixels.

LBIC Image:
1. Open up Matlab.
2. Make sure newest version of picoheatmapzcan#.m is in the same folder as the saved file from picoscope run
3. Click and drag picoheatmapzcan#.m into Command Window.
4. Answer the questions that pop up. ([] indicates default)
  a. What is the file name?
    i. Whatever you saved the file as
  b. What is the sensitivity exponent [-3]?
  c. What is the multiplier [1]?
  d. What is the width of the box [1]?
  e. What is the height of the box [1]?
  f. Autoscale (Y/max(mA)) [Y]?
    i. Y or ‘enter’ autoscales
    ii. Any other number becomes the maximum
  g. What cell is this?
    i. Whatever title you want (ex: PVSK Cell 5)
  h. What is the cell width (mm)?
  i. What is the cell height (mm)?
5. Resulting image should save as the same name as the .csv file in the same folder
6. Image orientation corresponds to looking at the sample from the power of the laser

Tips:
● If result is not what’s expected, try taking another scan.
● If ‘Image may not be accurate.’ try taking another scan.
● Vertical waviness can be fixed by tightening the top strip that wheels run on.
● If memory issue, try rebooting MatLab.
