//choose a downsize scle and a directory
#@ String (label=" ", value="<html><font size=6><b>High Throughput Analysis</font><br><font color=teal>Cell Adhesion Assay</font></b></html>", visibility=MESSAGE, persist=false) heading
#@ String(label="Select mode:", choices={"2x2", "4x4"}, style="radioButtonHorizontal") binning
#@ File(label="Select directory:", style="directory") dir
#@ String (label=" ", value="<html><img src=\"https://live.staticflickr.com/65535/48557333566_d2a51be746_o.png\"></html>", visibility=MESSAGE, persist=false) logo
#@ String (label=" ", value="<html><font size=2><b>Neuromolecular Biology Lab</b><br>ERI BIOTECMED, Universitat de València (Valencia, Spain)</font></html>", visibility=MESSAGE, persist=false) message

//get file list and create an output folder
list=getFileList(dir);
dirName=File.getName(dir);
output=dir+File.separator+dirName+"_dwsz"+binning;
File.makeDirectory(output);

//set the scale
if (binning=="2x2") {
	scale=0.25;
} else {
	scale=0.0625;
}

//resize and save
setBatchMode(true);
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], ".tif")) {
		open(list[i]);
		index=indexOf(list[i], ".");
		rename("original");
		run("Scale...", "x="+scale+" y="+scale+" interpolation=None average create title=["+list[i]+"]");
		selectImage(list[i]);
		saveAs("tif", output+File.separator+substring(list[i], 0, index));
		close(list[i]);
		close("original");
	}
}
setBatchMode(false);
