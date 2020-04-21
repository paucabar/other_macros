//choose a macro mode and a directory
#@ String (label=" ", value="<html><font size=6><b>Filename Transformation</font><br><font color=teal>IN Cell Analyzer</font></b></html>", visibility=MESSAGE, persist=false) heading
#@ String(label="Select data input:", choices={"Operetta", "NIS Elements"}, style="radioButtonVertical") input
#@ File(label="Select a directory:", style="directory") dir
#@ String (label=" ", value="<html><img src=\"https://live.staticflickr.com/65535/48557333566_d2a51be746_o.png\"></html>", visibility=MESSAGE, persist=false) logo
#@ String (label=" ", value="<html><font size=2><b>Neuromolecular Biology Lab</b><br>ERI BIOTECMED - Universitat de València (Spain)</font></html>", visibility=MESSAGE, persist=false) message

//Operetta
if(input=="Operetta") {
	print("Initializing Filename Transformation");
	//create an array containing the names of the files in the directory path
	list = getFileList(dir);
	Array.sort(list);
	tiffFiles=0;

	//count the number of TIF files
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "tif") || endsWith(list[i], "tiff")) {
			tiffFiles++;
		}
	}

	//check that the directory contains TIF files
	if (tiffFiles==0) {
		beep();
		exit("No tif files")
	}

	//create a an array containing only the names of the TIF files in the directory path
	tiffArray=newArray(tiffFiles);
	count=0;
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "tif") || endsWith(list[i], "tiff")) {
			tiffArray[count]=list[i];
			count++;
		}
	}
	//create an output directory
	outputFolderPath=dir+File.separator+"Filename Transformation";
	File.makeDirectory(outputFolderPath);

	setBatchMode(true);
	for(i=0; i<tiffArray.length; i++) {
		open(dir+"\\"+tiffArray[i]);
		print("Load: "+tiffArray[i]);
		well=substring(tiffArray[i], 0, 6);
		fIndex=indexOf(tiffArray[i], "f");
		pIndex=indexOf(tiffArray[i], "p");
		field=substring(tiffArray[i], fIndex+1, pIndex);
		while(lengthOf(field)<3) {
			field="0"+field;
		}
		chIndex=indexOf(tiffArray[i], "ch");
		skIndex=indexOf(tiffArray[i], "sk");
		channel=substring(tiffArray[i], chIndex, skIndex);
		saveAs("tif", outputFolderPath+"\\"+well+"(fld "+field+" wv "+channel+" - "+channel+")");
		close();
		print("Save as: "+well+"(fld "+field+" wv "+channel+" - "+channel+").tif");
	}
	setBatchMode(false);
	print("End of process");
	print("All the images have been transformed");
	print("Find the new image dataset at:");
	print(outputFolderPath);
}

//NIS Elements
if(input=="NIS Elements") {
	print("Initializing Filename Transformation");
	//create an array containing the names of the files in the directory path
	list = getFileList(dir);
	Array.sort(list);
	tiffFiles=0;

	//count the number of TIF files
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "tif")) {
			tiffFiles++;
		}
	}

	//check that the directory contains TIF files
	if (tiffFiles==0) {
		beep();
		exit("No tif files")
	}

	//create a an array containing only the names of the TIF files in the directory path
	tiffArray=newArray(tiffFiles);
	count=0;
	for (i=0; i<list.length; i++) {
		if (endsWith(list[i], "tif")) {
			tiffArray[count]=list[i];
			count++;
		}
	}
	//create an output directory
	outputFolderPath=dir+File.separator+"Filename Transformation";
	File.makeDirectory(outputFolderPath);

	//dialog box
	Dialog.create("NIS Elements");
	Dialog.addSlider("Digits (field):", 1, 3, 3);
	Dialog.show()
	digits=Dialog.getNumber();

	setBatchMode(true);
	for(i=0; i<tiffArray.length; i++) {
		open(dir+"\\"+tiffArray[i]);
		print("Load: "+tiffArray[i]);
		extensionIndex=indexOf(tiffArray[i], ".tif");
		cLastIndex=lastIndexOf(tiffArray[i], "c");
		channel=substring(tiffArray[i], cLastIndex, extensionIndex);
		field=substring(tiffArray[i], cLastIndex-digits, cLastIndex);
		while(lengthOf(field)<3) {
			field="0"+field;
		}
		if(cLastIndex-digits<=6) {
			well=substring(tiffArray[i], 0, cLastIndex-digits);
			while(lengthOf(well)<6) {
				well+=" ";
			}
		} else {
			well=substring(tiffArray[i], 0, 6);
		}
		saveAs("tiff", outputFolderPath+"\\"+well+"(fld "+field+" wv "+channel+" - "+channel+")");
		close();
		print("Save as: "+well+"(fld "+field+" wv "+channel+" - "+channel+").tif");
	}
	setBatchMode(false);
}
print("End of process");
print("All the images have been transformed");
print("Find the new image dataset at:");
print(outputFolderPath);
