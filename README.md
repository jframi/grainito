# 26th Feb 2018 - New color version

# grainito
Grainito automates the ImageJ analysis (http://imagej.nih.gov/ij/) of grain images captured using a flat bed scanner.

It is an ImageJ macro that automatically analyses all jpg images in a given directory.


## Installation

Save the macro files (grainito.ijm and grainito_color.ijm) in the **plugins** directory of ImageJ.

Start ImageJ, the two macros will be available in the Plugins menu.

## Usage

### Image capture

#### Color (recommended)

Use a green or blue background inside the scanner lid

#### Black and white

It is recommended to leave the lid open to get a black background (provided the grains are not to dark). In case the grains are dark the lid will have to be closed with a white background but the shadow will be difficult to handle

### Color (grainito_color.ijm)
This is the preferred version as a colored (green or blue) background is more efficient for grain detection.

The program will ask for different parameters:

- Crop image size
    + sizew: this is the width of the region of interest (centered on original image)
    + sizeh: this is the height of the region of interest (centered on original image)
- Hue threshold : 
    + huemin: min hue value for color threshold
    + huemax: max hue value for color threshold  
    Values can be determined using the ImageJ Image>Adjust>Color Threshold.. on a typical image.  Min and Max value should flank the peak visible in the Hue histogram of the Color Threshold dialog box.
- Grain size range and circularity
    + minsize: min grain size
    + maxsize: max grain size
    + mincirc: min grain circularity
- Use watershed: watershed improves seperation of clingy grains
    + watershed: 0 for no and 1 for yes
- Erode before getting particles RGB components
    + erodepth: number of erode passes to reduce grain size

All images (*.jpg) of the directory will be analysed.

The program will save for each image :
- a text file named image.txt : a table with one row per grain and morphological variables
- 3 text files named image.red.txt, image.green.txt, image.blue.txt containing respectively the average R, G and B components of grains color
- In a separate *masks* subdirectory:
    + image.jpgmainmask.jpg : thresholded image with detected grains
    + image.jpgoutline.jpg : original (cropped) image with detected grain as red outlines


### Black and white (grainito.ijm)

This is an old version that is no longer recommended

Choose background color (Black or White)

Choose a threshold method (see [ImageJ documentation](http://imagej.net/Auto_Threshold))

All images (*.jpg) of the directory will be analysed.

The program will save for each image :
- a new image named image.mask.jpg : thresholded image with detected grains
- a text file named image.txt : a table with one row per grain and morphological variables


## Post analysis

- The R script `plot.grains.col.R` contains a function to read the txt files generated by the program

### Example

If the images are contained in the following directory : /Users/Me/Images_to_analyse/

```r
# Source R script
source("wherever/you/saved/plot.grains.col.R")
# Set working directory to the directory containing analyzed images
setwd("/Users/Me/Images_to_analyse/")

imgfiles<-grep("^.+\\.jpg$",dir(),value = T)
```

Then the function `plot.grains.col` can be used in different ways:

```r
mylist<-plot.grains.cols(img=imgfiles,plot ="none")
```

will put in a list object `mylist` the results of all images

This list has the following structure:

    $ Image1.jpg:List of [n images]
      ..$ Main   :'data.frame': main table with morphological variables  
      ..$ col    : vector of R colors  
      ..$ rgb    : matrix of RGB components  
      ..$ hsv    : matrix of HSV components  
      ..$ lab    : matrix of LAB components  
      ..$ meanrgb: mean R, G, and B values across grains  
      ..$ meanlab: mean L, A, and B values across grains  

The same function can be used to generate different plots for 1 or several images.

Three types of plots are proposed :

- grains: reproduce the original image with grains plotted as ellipses
```r
plot.grains.cols(img=imgfiles,plot ="grains")
```
or for a single image
```r
plot.grains.cols(img=imgfiles[2],plot ="grains")
```

- pie: plot the palette of grains colors as a pie
```r
plot.grains.cols(img=imgfiles[2],plot ="pie")
```

- rect: plot all palettes of the different images on a single plot as a rectangular chart
```r
plot.grains.cols(img=imgfiles,plot ="rect")
```



