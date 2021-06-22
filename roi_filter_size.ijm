setOption("ExpandableArrays", true);
sizeSelection(0, 999999);

function sizeSelection(min, max) {
	roiDiscard=newArray();
	run("Set Measurements...", "area display redirect=None decimal=2");
	roiManager("deselect");
	roiManager("measure");
	nROI=roiManager("count");
	discardCount=0;
	for (i=0; i<nROI; i++) {
		area=getResult("Area", i);
		if (area < min || area > max) {
			roiDiscard[discardCount]=i;
			discardCount++;
			print (i);
		}
	}
	if (discardCount != 0) {
		roiManager("select", roiDiscard);
		roiManager("delete");
	}
	run("Clear Results");
}
