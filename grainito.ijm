//////////////////////////////////////////////////////////////////////////////////
// grainito
// v 1.3
// Copyright (C) 2013 J.F. Rami
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
//    You should have received a copy of the GNU General Public License
//    along with this program; if not, write to the Free Software
//    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//
//////////////////////////////////////////////////////////////////////////////////
//demande un repertoire qui contient les images
dir = getDirectory("Choose a Directory "); 
// list des fichiers dans le repertoire (doit ne contenir que les images)
list = getFileList(dir); 
// on ne voit pas les operations a l'ecran
setBatchMode(true);
//Selectionne la couleur de fond
//Selectionne le méthode de seuil
Dialog.create("Choose a background color:");
Dialog.addMessage("Please choose");
Dialog.addChoice("Choice:", newArray("Black","White"));
Dialog.show();
myChoiceBackg=Dialog.getChoice();
//Selectionne le méthode de seuil
Dialog.create("Choose a threshold method:");
Dialog.addMessage("Please choose");
Dialog.addChoice("Choice:", newArray("Default dark", "Huang dark", "Intermodes dark", "IsoData dark", "IJ_IsoData dark", "Li dark", "MaxEntropy dark", "Mean dark", "MinError dark", "Minimum dark", "Moments dark", "Otsu dark", "Percentile dark", "RenyiEntropy dark", "Shanbhag dark", "Triangle dark", "Yen dark"));
Dialog.show();
myChoicethres=Dialog.getChoice();

// boucle sur les images
for (i=0; i<list.length; i++) { 
	showProgress(i, list.length);
	if (endsWith(list[i],".jpg")){
	open(dir+list[i]); 
	run("8-bit");
	if(myChoiceBackg=="White")
	    run("Invert");
	run("Duplicate...", "title="+list[i]+".8bit.jpg");
	run("Threshold...");
	setAutoThreshold(myChoicethres); 
	run("Set Measurements...", "area mean perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect=None decimal=3");
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=[Bare Outlines] display exclude clear summarize add"); 
	run("Close-");
	run("Fill Holes");
	run("Watershed");
	run("Set Measurements...", "area mean perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect="+list[i]+" decimal=3");
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display exclude clear summarize add");
	saveAs("Jpeg", dir+list[i]+"_Mask_"+ myChoicethres+".jpg");
	selectWindow("Results"); 
	saveAs("Text", dir+list[i]+"."+ myChoicethres+".txt");
	run("Close All"); 
	}
} 

