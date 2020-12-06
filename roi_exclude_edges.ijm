setOption("ExpandableArrays", true);
excludeEdges();

function excludeEdges() {
	
	roiEdge=newArray();
	run("Set Measurements...", "bounding display redirect=None decimal=2");
	roiManager("deselect");
	roiManager("measure");
	nROI=roiManager("count");
	getDimensions(width, height, channels, slices, frames);
	toScaled(width);
	toScaled(height);
	roiEdgeCount=0;
	for (i=0; i<nROI; i++) {
		bx=getResult("BX", i);
		by=getResult("BY", i);
		iWidth=getResult("Width", i);
		iHeight=getResult("Height", i);
		makePoint(bx, by);	
		if (bx == 0 || by == 0 || bx + iWidth >= width || by + iHeight >= height) {
			roiEdge[roiEdgeCount]=i;
			roiEdgeCount++;
		}
	}
	if (roiEdgeCount != 0) {
		roiManager("select", roiEdge);
		roiManager("delete");
	}
	run("Clear Results");
	run("Select None");
	roiManager("show all with labels");
}