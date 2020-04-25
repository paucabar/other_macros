//choose a macro mode and a directory
#@ String (label=" ", value="<html><font size=6><b>Illumination Correction</font><br><font color=teal>Retrospective multi-image</font></b></html>", visibility=MESSAGE, persist=false) heading
#@ String(label="Select mode:", choices={"Generate correction function", "Correct images"}, style="radioButtonVertical") mode
#@ File(label="Select a directory:", style="directory") dir
#@ String (label=" ", value="<html><img src=\"https://live.staticflickr.com/65535/48557333566_d2a51be746_o.png\"></html>", visibility=MESSAGE, persist=false) logo
#@ String (label=" ", value="<html><font size=2><b>Neuromolecular Biology Lab</b><br>ERI BIOTECMED - Universitat de València (Spain)</font></html>", visibility=MESSAGE, persist=false) message


//Identification of the TIF files
//create an array containing the names of the files in the directory path
list = getFileList(dir);
Array.sort(list);
tifFiles=0;

//count the number of TIF files
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "tif")) {
		tifFiles++;
	}
}

//check that the directory contains TIF files
if (tifFiles==0) {
	beep();
	exit("No TIF files")
}

//create a an array containing only the names of the TIF files in the directory path
tifArray=newArray(tifFiles);
count=0;
for (i=0; i<list.length; i++) {
	if (endsWith(list[i], "tif")) {
		tifArray[count]=list[i];
		count++;
	}
}

//Extraction of the ‘well’ and ‘field’ information from the images’ filenames
//calculate: number of wells, images per well, images per field and fields per well
nWells=1;
nFields=1;
well=newArray(tifFiles);
field=newArray(tifFiles);
well0=substring(tifArray[0],0,6);
field0=substring(tifArray[0],11,14);

for (i=0; i<tifArray.length; i++) {
	well[i]=substring(tifArray[i],0,6);
	field[i]=substring(tifArray[i],11,14);
	well1=substring(tifArray[i],0,6);
	field1=substring(tifArray[i],11,14);
	if (field0!=field1 || well1!=well0) {
		nFields++;
		field0=substring(tifArray[i],11,14);
	}
	if (well1!=well0) {
		nWells++;
		well0=substring(tifArray[i],0,6);
	}
}

wellName=newArray(nWells);
imagesxwell = (tifFiles / nWells);
imagesxfield = (tifFiles / nFields);
fieldsxwell = nFields / nWells;

//Extraction of the ‘channel’ information from the images’ filenames
//create an array containing the names of the channels
channels=newArray(imagesxfield);
for (i=0; i < channels.length; i++) {
	index1=indexOf(tifArray[i], "wv ");
	index2=lastIndexOf(tifArray[i], ").");
	channels[i]=substring(tifArray[i], index1+3, index2);
}

//create output directory
dirName=File.getName(dir);
dirParent=File.getParent(dir);
outputDir=dirParent+File.separator+dirName+"_IllumCorection";
File.makeDirectory(outputDir);
File.makeDirectory(outputDir+File.separator+"Flat-field");
if (mode == "Correct images") {
	File.makeDirectory(outputDir+File.separator+"Corrected_images");
}

setBatchMode(true);
for (i=0;i<channels.length; i++) {
	run("Image Sequence...", "open=["+dir+"] file=["+channels[i]+"] sort");
	rename(channels[i]);
	//compute shading correction
	print("Computing shading correction for channel "+channels[i]);
	run("BaSiC ", "processing_stack=["+channels[i]+"] flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading only] lambda_flat=0.50 lambda_dark=0.50");
	selectWindow("Flat-field:"+channels[i]);
	saveAs("tif", outputDir+File.separator+"Flat-field"+File.separator+"Flat-field_"+channels[i]);
	run ("Close All");
}

if (mode == "Correct images") {
	for (i=0; i<tifArray.length; i++) {
		channelFound=false;
		chlCount=0;
		while (!channelFound) {
			if (indexOf(tifArray[i], channels[chlCount]) != -1) {
				print("Correcting", tifArray[i]);
				channelFound=true;
				open(dir+File.separator+tifArray[i]);
				open(outputDir+File.separator+"Flat-field"+File.separator+"Flat-field_"+channels[chlCount]+".tif");
				imageCalculator("Divide create", tifArray[i], "Flat-field_"+channels[chlCount]+".tif");
				formatIndex=lastIndexOf(tifArray[i], ".tif");
				saveName=substring(tifArray[i], 0, formatIndex);
				saveAs("tif", outputDir+File.separator+"Corrected_images"+File.separator+saveName);
				run("Close All");
			}
			chlCount++;
		}
	}
}
print("End of process");
setBatchMode(false);