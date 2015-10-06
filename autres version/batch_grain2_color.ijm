//demande un repertoire qui contient les images
dir = getDirectory("Choose a Directory "); 
// list des fichiers dans le repertoire (doit ne contenir que les images)
list = getFileList(dir); 
// on ne voit pas les operations a l'ecran
setBatchMode(true); 
// boucle sur les images
for (i=0; i<list.length; i++) { 

	showProgress(i, list.length);
	if (endsWith(list[i],".jpg")){
	open(dir+list[i]);
	run("Duplicate...", "title="+list[i]+".8bit.jpg");
	run("8-bit");
	run("Threshold...");
	run("Set Measurements...", "area redirect=None decimal=3");
	setAutoThreshold("Otsu dark"); 
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=[Bare Outlines] display exclude clear summarize add"); 
	run("Close-");
	run("Fill Holes");
	run("Watershed");
	run("Set Measurements...", "area mean perimeter bounding fit shape feret's integrated median skewness kurtosis area_fraction stack redirect="+list[i]+".8bit.jpg decimal=3");
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display exclude clear summarize add");
	saveAs("Jpeg", dir+list[i]+"_Mask_Otsu.jpg");
	selectWindow("Results");
	saveAs("Text", dir+list[i]+".Otsu.main.txt");
	close; 
	selectWindow(list[i]);
	run("Split Channels");
	selectWindow("Drawing of "+list[i]+".8bit.jpg");
	run("Set Measurements...", "integrated redirect='"+list[i]+" (red)' decimal=0");
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display exclude clear summarize add");
	selectWindow("Results");
	saveAs("Text", dir+list[i]+".Otsu.red.txt");
	close;
	selectWindow("Drawing of "+list[i]+".8bit.jpg");
	run("Set Measurements...", "integrated redirect='"+list[i]+" (green)' decimal=0");
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display exclude clear summarize add");
	selectWindow("Results");
	saveAs("Text", dir+list[i]+".Otsu.green.txt");
	close;
	selectWindow("Drawing of "+list[i]+".8bit.jpg");
	run("Set Measurements...", "integrated redirect='"+list[i]+" (blue)' decimal=0");
	run("Analyze Particles...", "size=200-Infinity circularity=0.00-1.00 show=Masks display exclude clear summarize add");
	selectWindow("Results");
	saveAs("Text", dir+list[i]+".Otsu.blue.txt");
	close;
	
	close;	
	close; 
	close; 
	close; 
	}
} 
