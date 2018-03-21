dir = getDirectory("Choose a Directory "); 


// list of files in the directory
list = getFileList(dir);

if (File.exists(dir+File.separator+"masks")!=1){
	File.makeDirectory(dir+File.separator+"masks"); 
}
