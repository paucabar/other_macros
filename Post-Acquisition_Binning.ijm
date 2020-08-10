//choose a downsize scle and a directory
#@ String (label=" ", value="<html><font size=6><b>Post-Acquisition Binning</font></b></html>", visibility=MESSAGE, persist=false) heading
#@ File(label="Select directory:", style="directory") dir
#@ String(label="Select mode:", choices={"2x2", "3x3", "4x4"}, style="radioButtonHorizontal") binning
#@ String (label=" ", value="<html><img src=\"https://live.staticflickr.com/65535/48557333566_d2a51be746_o.png\"></html>", visibility=MESSAGE, persist=false) logo
#@ String (label=" ", value="<html><font size=2><b>Neuromolecular Biology Lab</b><br>ERI BIOTECMED, Universitat de València (Valencia, Spain)</font></html>", visibility=MESSAGE, persist=false) message

//get file list and directory name
list=getFileList(dir);
dirName=File.getName(dir);

//count tif files
count=0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], ".tif")) {
		count++;
	}
}

//check if there are tif files
if (count==0) {
	beep();
	exit("No TIF files found in " + dir);
}

//create an output folder
output=dir+File.separator+dirName+"_dwsz"+binning;
File.makeDirectory(output);

//set the scale
if (binning=="2x2") {
	scale=1/4;
} else if (binning=="3x3") {
	scale=1/9;
} else {
	scale=1/16;
}

//resize and save
print("Processing");
setBatchMode(true);
progress=1;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], ".tif")) {
		print(list[i], "("+progress+"/"+count+")");
		open(list[i]);
		index=indexOf(list[i], ".");
		rename("original");
		run("Scale...", "x="+scale+" y="+scale+" interpolation=None average create title=["+list[i]+"]");
		selectImage(list[i]);
		saveAs("tif", output+File.separator+substring(list[i], 0, index));
		close(list[i]);
		close("original");
		progress++;
	}
}
setBatchMode(false);
print("End of process");