//choose a macro mode and a directory
#@ String (label=" ", value="<html><font size=6><b>Rectangle Crop</font><br><font color=teal>Batch processing</font></b></html>", visibility=MESSAGE, persist=false) heading
#@ File(label="Select a directory:", style="directory") dir
#@ File (label="Select an image", style="file") file
#@ String (label=" ", value="<html><img src=\"https://live.staticflickr.com/65535/48557333566_d2a51be746_o.png\"></html>", visibility=MESSAGE, persist=false) logo
#@ String (label=" ", value="<html><font size=2><b>Neuromolecular Biology Lab</b><br>ERI BIOTECMED - Universitat de València (Spain)</font></html>", visibility=MESSAGE, persist=false) message

//create the selection
open(file);
setTool("rectangle");
waitForUser("Make a rectangular selection");
selection=selectionType(); // 0 = rectangle
while (selection != 0) {
	setTool("rectangle");
	run("Select None");
	waitForUser("Make a rectangular selection");
	selection=selectionType();
}

roiManager("add");
run("Close All");

//crop images
setBatchMode(true);
print("Start batch process");
list=getFileList(dir);
dirName=File.getName(dir);
dirParent=File.getParent(dir);
outputDir=dirParent+File.separator+dirName+"_Crop";
File.makeDirectory(outputDir);
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], ".tif")) {
		print("Processing", list[i]);
		open(dir+File.separator+list[i]);
		roiManager("select", 0);
		run("Crop");
		formatIndex=lastIndexOf(list[i], ".tif");
		saveName=substring(list[i], 0, formatIndex);
		saveAs("tif", outputDir+File.separator+saveName);
		close();
	}
}
roiManager("deselect");
roiManager("save", outputDir+File.separator+"CropROI.zip");
selectWindow("ROI Manager");
run("Close");
setBatchMode(false);
print("End of process");