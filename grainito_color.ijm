//////////////////////////////////////////////////////////////////////////////////
// grainito_color
// v 2.0
// J.F. Rami - 2018
//
//    This program is free software; you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation; either version 2 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//
//////////////////////////////////////////////////////////////////////////////////

macro "grainito_color Action Tool - C059T3e16G"{

//Prompt for a directory that contain jpg images
dir = getDirectory("Choose a Directory "); 

// Use this one in case of batch usage
//dir=getArgument()

// Create masks subdirectory if not exists
if (File.exists(dir+File.separator+"masks")!=1){
	File.makeDirectory(dir+File.separator+"masks"); 
}

// list of files in the directory
list = getFileList(dir); 

// hide operations on screen
setBatchMode(true); 

//Define parameters
	// Crop image size
	sizew = getNumber("Crop image width", 5000);
	sizeh = getNumber("Crop image height", 3000);
	// Hue threshold
	// huemin = getNumber("Hue threshold min value", 68);
	// huemax = getNumber("Hue threshold max value", 108);
	// Grain size range and circularity
	minsize = getNumber("Grain min size (area)", 4000);
	maxsize = getNumber("Grain max size (area)", 8000);
	mincirc = getNumber("Grain min circularity (0-1))", 0.5);
	// Use wateshed
	watershed = getNumber("Use watershed (0=no, 1=yes)", 1);
	// Erode before getting particles RGB components
	erodepth = getNumber("Erode depth", 0);
	median_radius = 5;


// loop on files
for (i=0; i<list.length; i++) { 
	showProgress(i, list.length);
	// if file is jpg
	if (endsWith(list[i],".jpg")){
		//open image
		open(dir+list[i]);
		//crop image
		getDimensions(width, height, channelCount, sliceCount, frameCount);
		cropx1 = (width-sizew)/2;
		cropy1 = (height-sizeh)/2;
		cropw =  sizew;
		croph =  sizeh;
		makeRectangle(cropx1, cropy1, cropw, croph);
		run("Crop");
		run("Duplicate...", "title="+list[i]+".crop.jpg");

			// Thresholder on Hue
			a=getTitle();
			run("Lab Stack");
			run("Convert Stack to Images");
			selectWindow("L*");
			close();
			selectWindow("b*");
			close();
			selectWindow("a*");
			//setThreshold(huemin, huemax);
			run("8-bit");
			setAutoThreshold(); 
			run("Convert to Mask");
			//run("Invert");
			rename(a);
		// Median Filter to eliminate single white points
		run("Median...", "radius="+median_radius);
		if (watershed==1){
			run("Watershed");		
		}
		run("Duplicate...", "title="+list[i]+"backup");
		selectWindow(a);
		run("Set Measurements...", "area mean centroid perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
		run("Analyze Particles...", "size="+minsize+"-"+maxsize+" circularity="+mincirc+"-1.00 show=Masks display exclude clear");
		selectWindow("Mask of "+a);
		run("Duplicate...", "title=Mask of "+a+"backup");
		saveAs("Jpeg", dir+"masks/"+list[i]+"main_mask.jpg");
		// Export cropped image with outlines
		run("Duplicate...", "title=outlineexport");
		run("Outline");
		run("Dilate");
		run("Red");
		selectWindow(list[i]);
		run("Duplicate...", "title="+list[i]+"outline.jpg");
		run("Add Image...", "image=outlineexport x=0 y=0 opacity=100 zero");
		saveAs("Jpeg", dir+"masks/"+list[i]+"outline.jpg");
		close();
		selectWindow("outlineexport");
		close();
		// Save Main report
		selectWindow("Results");
		saveAs("Text", dir+list[i]+".main.txt");

		// Go back to original image and split to RGB
		selectWindow(list[i]);
		run("Split Channels");
		mins=minsize/3;
		selectWindow("Mask of "+a);
		for (e=1; e<erodepth; e++) {
			run("Erode");
		}
		run("Duplicate...", "title="+list[i]+"backup2");
		run("Set Measurements...", "mean redirect='"+list[i]+" (red)' decimal=0");
		run("Analyze Particles...", "size="+mins+"-"+maxsize+" circularity="+mincirc+"-1.00 show=Masks display exclude clear");
		selectWindow("Results");
		saveAs("Text", dir+list[i]+".red.txt");
		close();
		selectWindow("Mask of "+a);
		run("Duplicate...", "title="+list[i]+"backup3");
		run("Set Measurements...", "mean redirect='"+list[i]+" (green)' decimal=0");
		run("Analyze Particles...", "size="+mins+"-"+maxsize+" circularity="+mincirc+"-1.00 show=Masks display exclude clear");
		selectWindow("Results");
		saveAs("Text", dir+list[i]+".green.txt");
		close();
		selectWindow("Mask of "+a);
		run("Duplicate...", "title="+list[i]+"backup4");
		run("Set Measurements...", "mean redirect='"+list[i]+" (blue)' decimal=0");
		run("Analyze Particles...", "size="+mins+"-"+maxsize+" circularity="+mincirc+"-1.00 show=Masks display exclude clear");

		selectWindow("Results");
		saveAs("Text", dir+list[i]+".blue.txt");
		close();

		// close all images before moving to next one
		while (nImages>0) { 
	          		selectImage(nImages); 
	          		close(); 
      		} 
	}
} 
}
