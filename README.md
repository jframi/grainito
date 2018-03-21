# 26th Feb 2018 - New color version

# grainito
Grainito automates the ImageJ analysis (http://imagej.nih.gov/ij/) of grain images captured using a flat bed scanner.

It is an ImageJ macro that automatically analyses all jpg images in a given directory.


## Installation

Save the macro files (grainito.ijm and grainito_color.ijm) in the **plugins** directory of ImageJ. Start ImageJ, the two macros will be available in the Plugins menu.

## Analysis

### Color (grainito_color.ijm)
This is the preferred version as a colored (green or blue) background is more efficient for grain detection.
The program will ask for different parameters:

- Crop image size
    + sizew: this is the width of the region of interest (centered on original image)
    + sizeh: this is the height of the region of interest (centered on original image)
- Hue threshold
    + huemin: min hue value for color threshold
    + huemax: max hue value for color threshold
- Grain size range and circularity
    + minsize: min grain size
    + maxsize: max grain size
    + mincirc: min grain circularity
- Use watershed: watershed improves seperation of clingy grains
    + watershed: 0 for no and 1 for yes
- Erode before getting particles RGB components
    + erodepth: number of erode passes to reduce grain size



### Black and white (grainito.ijm)

Choose background color (Black or White)

Choose a threshold method (see ImageJ documentation)

All images (*.jpg) of the directory will be analysed.

The macro will save for each image :
- a new image named image.mask.jpg : thresholded image with detected grains
- a text file named image.txt : a table with one row per grain and morphological variables



## Post analysis

Le script perl postgrainito.pl permet de concaténer tous les fichiers txt en un seul en rajoutant le nom du fichier en première colonne.

Une fois importé dans R ce fichier peut etre analysé pour avoir les statistiques de chaque image;
