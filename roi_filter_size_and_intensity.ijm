setOption("ExpandableArrays", true);
sizeAndIntensitySelection(20, 100, "DAPI", 50);


function sizeAndIntensitySelection(min, max, grayscaleImage, meanThreshold) {
	roiDiscard=newArray();
	run("Set Measurements...", "area mean display redirect="+grayscaleImage+" decimal=2");
	roiManager("deselect");
	roiManager("measure");
	nROI=roiManager("count");
	discardCount=0;
	for (i=0; i<nROI; i++) {
		area=getResult("Area", i);
		mean=getResult("Mean", i);
		if (area < min || area > max || mean < meanThreshold) {
			roiDiscard[discardCount]=i;
			discardCount++;
		}
	}
	if (discardCount != 0) {
		roiManager("select", roiDiscard);
		roiManager("delete");
	}
	run("Clear Results");
}